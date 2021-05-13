import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/stock.dart';
import './stocks.dart';
import 'package:uuid/uuid.dart';

class ApiRequests with ChangeNotifier {
  final yahooHeaders = {
    'x-rapidapi-key': 'c240089657mshdadc79016c189a9p16df26jsnc6431c2dd55f',
    'x-rapidapi-host': 'apidojo-yahoo-finance-v1.p.rapidapi.com'
  };

  final twelveHeaders = {
    'x-rapidapi-key': 'c240089657mshdadc79016c189a9p16df26jsnc6431c2dd55f',
    'x-rapidapi-host': 'twelve-data1.p.rapidapi.com'
  };

  Future<void> fetchCurrentPrices(Stocks stocksData) async {
    //since we dont want to pay money we need to use 2 apis to get the prices
    //twelve api has 12 calls per min and 850 per day
    //yahoo has 500 per month

    if(!stocksData.readyForRequest()){//we only want to allow request after a certain time
      return;
    }

    List<Stock> stocks = stocksData.stocks;

    if(stocks.isEmpty){
      return;//make sure that we have stocks in the data passed
    }

    var response = await http.get(
      Uri.parse(
          "https://twelve-data1.p.rapidapi.com/price?symbol=${getTickersStringTwelve(stocks)}&format=json&outputsize=30"),
      headers: twelveHeaders,
    );
    List<Stock> failedStocks =
        []; //list because twelve api may fail with some stocks, and we will try with the yahoo if it fails

    Map<String, dynamic> extractedData = await jsonDecode(response.body);

    for (int i = 0; i < stocks.length; i++) {
      try {
        stocks[i].currentPrice =
            double.parse(extractedData[stocks[i].ticker]["price"]);
      } catch (e) {
        failedStocks.add(stocks[i]);
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
        Stock stock = stocksData.findStockById(failedStocks[i].id);
        if (stock != null) {
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
      tickerString += "${stocks[i].ticker}%2C";
    }
    tickerString += "${stocks[stocks.length - 1].ticker}";
    return tickerString;
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
          currentPrice: price,
          portfolioId: stock.portfolioId
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
