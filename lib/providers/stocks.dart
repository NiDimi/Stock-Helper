import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stock_helper/models/stock.dart';
import 'package:http/http.dart' as http;

class Stocks with ChangeNotifier {
  static List<Stock> _stocks = [
    Stock(
      ticker: 'GOOG',
      price: 2294.63,
      quantity: 1,
    ),
    Stock(
      ticker: 'MSFT',
      price: 258.24,
      quantity: 2,
    ),
    Stock(
      ticker: 'FB',
      price: 301.55,
      quantity: 1,
    ),
    Stock(
      ticker: 'KER.PA',
      price: 640.20,
      quantity: 1,
    )
  ];

  List<Stock> get stocks {
    return [..._stocks];
  }

  var headers = {
    'x-rapidapi-key': 'b8be287101msh595fa7833446797p1de827jsn3ba41daea700',
    'x-rapidapi-host': 'apidojo-yahoo-finance-v1.p.rapidapi.com'
  };

  Future<void> fetchCurrentPrices() async {
    var response = await http.get(
      Uri.parse(
          "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-quotes?region=US&symbols=${getTickersString()}"),
      headers: headers,
    );
    final extractedData = await jsonDecode(response.body);
    List<dynamic> stockData = extractedData["quoteResponse"]["result"];
    for (int i = 0; i < stockData.length; i++) {
      _stocks[i].currentPrice = stockData[i]["regularMarketPrice"];
      _stocks[i].name = stockData[i]["longName"];
    }
    notifyListeners();
  }

  String getTickersString() {
    String tickerString = "";
    for (int i = 0; i < _stocks.length - 1; i++) {
      tickerString += "${_stocks[i].ticker}%2C";
    }
    tickerString += "${_stocks[_stocks.length - 1].ticker}";
    return tickerString;
  }

  String getPercentage(Stock stock) {
    String percentage = "";
    if (stock.price > stock.currentPrice) {
      percentage += "-";
      double difference = (stock.price - stock.currentPrice) /
          stock.currentPrice * 100;
      percentage += difference.toStringAsFixed(2);
    } else {
      percentage += "+";
      double difference = (stock.currentPrice - stock.price) / stock.price *
          100;
      percentage += difference.toStringAsFixed(2);
    }
    percentage += "%";
    return percentage;
  }

  double getRevenue() {
    double total = 0;
    _stocks.forEach((stock) {
      total += (stock.currentPrice - stock.price) * stock.quantity;
    });
    return total;
  }

  void addStock(Stock stock) {
    _stocks.add(stock);
    notifyListeners();
  }

  Future<bool> checkIfStockExists(String ticker) async {
    var response = await http.get(
      Uri.parse(
          "https://apidojo-yahoo-finance-v1.p.rapidapi.com/stock/v2/get-summary?symbol=$ticker&region=US"),
      headers: headers,
    );
    //sometimes we get data for stocks that dont have a price we need to check the price, we need to check the price
    //if the code fails it means that it is an invalid ticker
    try {
      final extractedData = await jsonDecode(response.body);
      double price = extractedData['price']['regularMarketPrice']['raw'];
      return price > 0;
    } catch(e){
      return false;
    }
  }
}
