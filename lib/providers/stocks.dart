import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stock_helper/models/stock.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

//helper class for the processing the stocks list
class Stocks with ChangeNotifier {
  static List<Stock> _stocks = [
    Stock(
      id: Uuid().v1(),
      name: 'Google',
      ticker: 'GOOG',
      price: 2294.63,
      quantity: 1,
    ),
    Stock(
      id: Uuid().v1(),
      name: 'Microsoft',
      ticker: 'MSFT',
      price: 258.24,
      quantity: 2,
    ),
    Stock(
      id: Uuid().v1(),
      name: 'Facebook',
      ticker: 'FB',
      price: 301.55,
      quantity: 1,
    ),
    Stock(
      id: Uuid().v1(),
      name: 'Apple',
      ticker: 'AAPl',
      price: 130.2,
      quantity: 1,
    )
  ];

  List<Stock> get stocks {
    return [..._stocks];
  }

  final yahooHeaders = {
    'x-rapidapi-key': 'b8be287101msh595fa7833446797p1de827jsn3ba41daea700',
    'x-rapidapi-host': 'apidojo-yahoo-finance-v1.p.rapidapi.com'
  };

  final twelveHeaders = {
    'x-rapidapi-key': 'b8be287101msh595fa7833446797p1de827jsn3ba41daea700',
    'x-rapidapi-host': 'twelve-data1.p.rapidapi.com'
  };

  //featch the current prices of the stocks in the list
  Future<void> fetchCurrentPrices() async {
    //since we dont want to pay money we need to use 2 apis to get the prices
    //twelve api has 12 calls per min and 850 per day
    //yahoo has 500 per month
    var response = await http.get(
      Uri.parse(
          "https://twelve-data1.p.rapidapi.com/price?symbol=${getTickersStringTwelve(_stocks)}&format=json&outputsize=30"),
      headers: twelveHeaders,
    );
    List<Stock> failedStocks = [];//list because twelve api may fail with some stocks, and we will try with the yahoo if it fails

    Map<String, dynamic> extractedData = await jsonDecode(response.body);

    for (int i = 0; i < _stocks.length; i++) {
      try {
        _stocks[i].currentPrice =
            double.parse(extractedData[_stocks[i].ticker]["price"]);
      } catch (e) {
        failedStocks.add(_stocks[i]);
      }
    }
    //if a stock fails try with the yahoo api instead
    if (failedStocks.length > 0) {
      var response = await http.get(
        Uri.parse(
            "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-quotes?region=US&symbols=${getTickersStringYahoo(failedStocks)}"),
        headers: yahooHeaders,
      );
      final extractedData = await jsonDecode(response.body);

      List<dynamic> stockData = extractedData["quoteResponse"]["result"];
      for (int i = 0; i < stockData.length; i++) {
        Stock stock = findStockById(failedStocks[i].id);
        if(stock != null){
          stock.currentPrice = stockData[i]["regularMarketPrice"];
        }
      }
    }
  }

  //get the ticker string passed in the url in the format twelve api wants it
  String getTickersStringTwelve(List<Stock> stocks) {
    String tickerString = "";
    for (int i = 0; i < stocks.length - 1; i++) {
      tickerString += "${stocks[i].ticker}%2C%20";
    }
    tickerString += "${stocks[stocks.length - 1].ticker}";
    return tickerString;
  }

  //get the ticker string passed in the url in the format yahoo api wants it
  String getTickersStringYahoo(List<Stock> stocks) {
    String tickerString = "";
    for (int i = 0; i < stocks.length - 1; i++) {
      tickerString += "${_stocks[i].ticker}%2C";
    }
    tickerString += "${stocks[stocks.length - 1].ticker}";
    return tickerString;
  }

  //get the percentage of the increase/decrease for the stock
  String getPercentage(Stock stock) {
    String percentage = "";
    if (stock.price > stock.currentPrice) {
      percentage += "-";
      double difference =
          (stock.price - stock.currentPrice) / stock.currentPrice * 100;
      percentage += difference.toStringAsFixed(2);
    } else {
      percentage += "+";
      double difference =
          (stock.currentPrice - stock.price) / stock.price * 100;
      percentage += difference.toStringAsFixed(2);
    }
    percentage += "%";
    return percentage;
  }

  //get the total revenue from the stocks
  double getRevenue() {
    double total = 0;
    _stocks.forEach((stock) {
      total += (stock.currentPrice - stock.price) * stock.quantity;
    });
    return total;
  }

  //add a stock in the list
  void addStock(Stock stock) {
    _stocks.add(stock);
    notifyListeners();
  }

  //we check if a stock has a name since we also need the name, which means the stock exists
  Future<Stock> checkIfStockExists(Stock stock) async {
    var response = await http.get(
      Uri.parse(
          "https://apidojo-yahoo-finance-v1.p.rapidapi.com/stock/v2/get-summary?symbol=${stock.ticker}&region=US"),
      headers: yahooHeaders,
    );
    //sometimes we get data for stocks that dont have a price we need to check the price, we need to check the price
    //if the code fails it means that it is an invalid ticker
    try {
      final extractedData = await jsonDecode(response.body);
      double price = extractedData['price']['regularMarketPrice']['raw'];
      if (price > 0) {
        return new Stock(
          id: Uuid().v1(),
          name: extractedData['price']['shortName'],
          ticker: stock.ticker,
          price: stock.price,
          quantity: stock.quantity,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  //find a stock in the list using its id
  Stock findStockById(String id){
    return _stocks.firstWhere((prod) => prod.id == id);
  }

  //removes a stock
  void removeStock(String id){
    int stockIndex = _stocks.indexWhere((stock) => stock.id == id);
    _stocks.removeAt(stockIndex);
    notifyListeners();
  }
}
