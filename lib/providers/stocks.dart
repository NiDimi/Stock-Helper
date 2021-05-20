import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/stock.dart';

class Stocks {
  DateTime _nextRequestTimer;
  final portfolioId;

  Stocks(this.portfolioId);

  List<Stock> _stocks = [];

  //getter for the stocks
  List<Stock> get stocks {
    return [..._stocks];
  }

  set stocks(List<Stock> value) {
    _stocks = value;
  }

  //get the total revenue from the stocks
  double getRevenue() {
    double total = 0;
    _stocks.forEach((stock) {
      total += (stock.currentPrice - stock.price) * stock.quantity;
    });
    return total;
  }

  //gets the total spent amount
  double getTotalSpent() {
    double total = 0;
    _stocks.forEach((stock) {
      total += stock.price;
    });
    return total;
  }

  //find a stock in the list using its id
  Stock findStockById(String id) {
    return _stocks.firstWhere((prod) => prod.id == id);
  }

  //add a stock in the list
  Future<void> addStock(Stock stock) async {
    _stocks.add(stock);
    final response = await http.patch(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/portfolios/$portfolioId/stocks/${_stocks.length - 1}.json'),
      body: json.encode(
        {
          'id': stock.id,
          'name': stock.name,
          'ticker': stock.ticker,
          'price': stock.price,
          'quantity': stock.quantity,
          'portfolioId': stock.portfolioId,
        },
      ),
    );
    if (response.statusCode >= 400) {
      _stocks.remove(stock); //means the add failed so remove it
    }
  }

  //removes a stock
  Future<void> removeStock(String id) async {
    int stockIndex = _stocks.indexWhere((stock) => stock.id == id);
    Stock stock = _stocks.removeAt(stockIndex);
    var response = await http.delete(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/portfolios/$portfolioId/stocks/$stockIndex.json'),
    );
    if (response.statusCode >= 400) {
      _stocks.insert(stockIndex, stock); //add it back in if it failed
    }
    response = await http.patch(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/portfolios/$portfolioId.json'),
      body: json.encode({
        'stocks': _stocks
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
  }

  //method so we can do request for the prices with a delay
  bool readyForRequest() {
    if (_nextRequestTimer == null) {
      _nextRequestTimer = DateTime.now().add(Duration(minutes: 10));
      return true;
    }
    if (_nextRequestTimer.isBefore(DateTime.now())) {
      _nextRequestTimer = DateTime.now().add(Duration(minutes: 10));
      return true;
    }
    return false;
  }
}
