import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import './stocks.dart';
import '../providers/portfolios.dart';
import '../models/portfolio.dart';
import '../models/stock.dart';

class HistoricPortfolios with ChangeNotifier {
  // list with all the portfolios
  static List<Portfolio> _portfolios = [];
  double _profit = 0.0;
  final String authToken;
  final String userId;


  HistoricPortfolios(this.authToken, this.userId);

  List<Portfolio> get portfolios {
    return [..._portfolios];
  }

  //close a stock and added into the historic data
  Future<void> addHistoricTransaction(Stock stock) async {
    //add the revenue of the stock to the final one
    _profit += (stock.currentPrice - stock.price) * stock.quantity;
    _storeProfit();
    //we need to check if we exceeded the 10 porfolios limit
    checkForTenPortfolio();
    //we need to check if we already have a portfolio that the stock belongs too
    final doesExist = _portfolios.indexWhere((portfolio) =>
        portfolio.portfolioStocks.stocks[0].portfolioId ==
        stock.portfolioId); //used to be in the same portfolio
    if (doesExist > -1) {
      await _addExistingPortfolio(doesExist, stock);
      return;
    }
    await _addNewPortfolio(stock);
  }

  //adds a stock to an existing portfolio in the history screen
  Future<void> _addExistingPortfolio(int index, Stock stock) async {
    final response = await http.patch(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/history/${_portfolios[index].id}/stocks/${_portfolios[index].portfolioStocks.stocks.length}.json?auth=$authToken'),
      body: json.encode({
        'id': stock.id,
        'name': stock.name,
        'ticker': stock.ticker,
        'price': stock.price,
        'quantity': stock.quantity,
        'portfolioId': stock.portfolioId,
        'currentPrice': stock.currentPrice,
        'creatorId' : userId,
      }),
    );

    if (response.statusCode >= 400) {
      return;
    }

    _portfolios[index].portfolioStocks.addHistoricStock(stock);
  }

  //generates a new portfolio since we closed a new portfolio
  Future<void> _addNewPortfolio(Stock stock) async {
    String name = Portfolios(null, null)
        .portfolios
        .firstWhere((portfolio) => portfolio.id == stock.portfolioId)
        .name;

    final response = await http.post(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/history.json?auth=$authToken'),
      body: json.encode({
        'name': name,
        'creatorId' : userId,
        'stocks': {
          '0': {
            'id': stock.id,
            'name': stock.name,
            'ticker': stock.ticker,
            'price': stock.price,
            'quantity': stock.quantity,
            'portfolioId': stock.portfolioId,
            'currentPrice': stock.currentPrice,
          }
        }
      }),
    );
    if (response.statusCode >= 400) {
      return;
    }

    _portfolios
        .add(Portfolio(id: json.decode(response.body)['name'], name: name));
    _portfolios[_portfolios.length - 1].portfolioStocks.addHistoricStock(stock);
  }

  void checkForTenPortfolio() async {
    if (_portfolios.length >= 10) {
      final response = await http.delete(Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/history/${_portfolios[0].id}.json?auth=$authToken'));
      if (response.statusCode >= 400) {
        return;
      }
      _portfolios.removeAt(0);
    }
  }

  //gets the revenue of all the portfolios
  double getRevenue() {
    return _profit;
  }

  //stores the revenue into memory
  Future<void> _storeProfit() async {
    final response = await http.put(
        Uri.parse('https://stockity-4ae33-default-rtdb.firebaseio.com/profit/$userId.json?auth=$authToken'),
        body: json.encode({'profit': _profit}));
    if (response.statusCode >= 400) {
      return;
    }
  }

  //fetches and sets the historic transactions from firebase
  Future<void> fetchAndSetHistoricData() async {
    final response = await http.get(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/history.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"'),
    );
    if (response.statusCode >= 400) {
      return;
    }

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData != null) {
      extractedData.forEach((portfolioId, portfolioData) {
        final tempStocksObj = Stocks(portfolioData['stocks'][0]['portfolioId']);
        tempStocksObj.stocks = (portfolioData['stocks'] as List<dynamic>)
            .map((stock) => Stock(
                  id: stock['id'],
                  name: stock['name'],
                  ticker: stock['ticker'],
                  price: stock['price'],
                  quantity: stock['quantity'],
                  portfolioId: stock['portfolioId'],
                  currentPrice: stock['currentPrice'],
                ))
            .toList();
        _portfolios.add(
          Portfolio(
              id: portfolioId,
              name: portfolioData['name'],
              portfolioStocks: tempStocksObj),
        );
      });
    }
    fetchProfit();
  }

  Future<void> fetchProfit() async {
    final response = await http.get(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/profit/$userId/profit.json?auth=$authToken'),
    );
    if (response.statusCode >= 400) {
      _profit = 0.0;
      return;
    }
    if(response.body == 'null'){
      _profit =0.0;
      return;
    }
    _profit = double.parse(response.body);
  }

  void logout(){
    _portfolios = [];
  }
}
