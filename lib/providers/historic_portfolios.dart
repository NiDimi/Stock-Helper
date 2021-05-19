import 'dart:convert';

import 'package:flutter/material.dart';
import './stocks.dart';
import '../providers/portfolios.dart';
import '../models/portfolio.dart';
import '../models/stock.dart';
import 'package:http/http.dart' as http;

class HistoricPortfolios with ChangeNotifier {
  // list with all the portfolios
  static List<Portfolio> _portfolios = [];

  List<Portfolio> get portfolios {
    return [..._portfolios];
  }

  //close a stock and added into the historic data
  Future<void> addHistoricTransaction(Stock stock) async {
    //first we need to check if we already have a portfolio that the stock belongs too
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
    _portfolios[index].portfolioStocks.addStock(stock);
    var response = await http.patch(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/history/${_portfolios[index].id}.json'),
      body: json.encode({
        'name': _portfolios[index].name,
        'stocks': _portfolios[index]
            .portfolioStocks
            .stocks
            .map((stock) => {
                  'id': stock.id,
                  'name': stock.name,
                  'ticker': stock.ticker,
                  'price': stock.price,
                  'quantity': stock.quantity,
                  'portfolioId': stock.portfolioId,
                  'currentPrice': stock.currentPrice,
                })
            .toList(),
      }),
    );
    if (response.statusCode >= 400) {
      //if it fails remove it
      _portfolios[index].portfolioStocks.removeStock(stock.id);
    }
  }

  //generates a new portfolio since we closed a new portfolio
  Future<void> _addNewPortfolio(Stock stock) async {
    String name = Portfolios()
        .portfolios
        .firstWhere((portfolio) => portfolio.id == stock.portfolioId)
        .name;

    var response = await http.post(
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
    _portfolios[_portfolios.length - 1].portfolioStocks.addStock(stock);
  }

  //gets the revenue of all the portfolios
  double getRevenue() {
    double total = 0;
    for (Portfolio portfolio in _portfolios) {
      total += portfolio.portfolioStocks.getRevenue();
    }
    return total;
  }

  //fetches and sets the historic transactions from firebase
  Future<void> fetchAndSetHistoricData() async {
    var response = await http.get(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/history.json'),
    );
    if (response.statusCode >= 400) {
      return;
    }

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData != null) {
      extractedData.forEach((portfolioId, portfolioData) {
        var test = portfolioData['stocks'][0]['portfolioId'];
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
