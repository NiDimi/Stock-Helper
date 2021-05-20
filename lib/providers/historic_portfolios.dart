import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './stocks.dart';
import '../providers/portfolios.dart';
import '../models/portfolio.dart';
import '../models/stock.dart';

class HistoricPortfolios with ChangeNotifier {
  // list with all the portfolios
  static List<Portfolio> _portfolios = [];
  double _revenue;
  static const KEY = 'revenue';

  HistoricPortfolios() {
    SharedPreferences.getInstance().then((prefs) {
      _revenue = prefs.getDouble(KEY);
      if (_revenue == null) {
        _revenue = 0.0;
      }
    });
  }

  List<Portfolio> get portfolios {
    return [..._portfolios];
  }

  //close a stock and added into the historic data
  Future<void> addHistoricTransaction(Stock stock) async {
    //add the revenue of the stock to the final one
    _revenue += (stock.currentPrice - stock.price) * stock.quantity;
    storeRevenue();
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
          'https://stockity-4ae33-default-rtdb.firebaseio.com/history/${_portfolios[index].id}/stocks/${_portfolios[index].portfolioStocks.stocks.length}.json'),
      body: json.encode({
        'id': stock.id,
        'name': stock.name,
        'ticker': stock.ticker,
        'price': stock.price,
        'quantity': stock.quantity,
        'portfolioId': stock.portfolioId,
        'currentPrice': stock.currentPrice,
      }),
    );

    if (response.statusCode >= 400) {
      return;
    }

    _portfolios[index].portfolioStocks.addHistoricStock(stock);
  }

  //generates a new portfolio since we closed a new portfolio
  Future<void> _addNewPortfolio(Stock stock) async {
    String name = Portfolios()
        .portfolios
        .firstWhere((portfolio) => portfolio.id == stock.portfolioId)
        .name;

    final response = await http.post(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/history.json'),
      body: json.encode({
        'name': name,
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
          'https://stockity-4ae33-default-rtdb.firebaseio.com/history/${_portfolios[0].id}.json'));
      if(response.statusCode >= 400){
        return;
      }
      _portfolios.removeAt(0);
    }
  }

  //gets the revenue of all the portfolios
  double getRevenue() {
    return _revenue;
  }

  //stores the revenue into memory
  Future<void> storeRevenue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(KEY, _revenue);
  }

  //fetches and sets the historic transactions from firebase
  Future<void> fetchAndSetHistoricData() async {
    final response = await http.get(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/history.json'),
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
  }
}
