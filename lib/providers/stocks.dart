import 'package:uuid/uuid.dart';

import '../models/stock.dart';

class Stocks {
  DateTime _nextRequestTimer;
  final portfolioId;


  Stocks(this.portfolioId);

  // List<Stock> _stocks = [
  //   Stock(
  //     id: Uuid().v1(),
  //     name: 'Google',
  //     ticker: 'GOOG',
  //     price: 2224.63,
  //     quantity: 1,
  //     portfolioId: Uuid().v1(),
  //   ),
  //   Stock(
  //     id: Uuid().v1(),
  //     name: 'Microsoft',
  //     ticker: 'MSFT',
  //     price: 258.24,
  //     quantity: 2,
  //     portfolioId: Uuid().v1(),
  //   ),
  //   Stock(
  //     id: Uuid().v1(),
  //     name: 'Facebook',
  //     ticker: 'FB',
  //     price: 301.55,
  //     quantity: 1,
  //     portfolioId: Uuid().v1(),
  //   ),
  //   Stock(
  //     id: Uuid().v1(),
  //     name: 'Apple',
  //     ticker: 'AAPl',
  //     price: 130.2,
  //     quantity: 1,
  //     portfolioId: Uuid().v1(),
  //   ),
  // ];

  List<Stock> _stocks = [];

  //getter for the stocks
  List<Stock> get stocks {
    return [..._stocks];
  }

  //get the total revenue from the stocks
  double getRevenue() {
    double total = 0;
    _stocks.forEach((stock) {
      total += (stock.currentPrice - stock.price) * stock.quantity;
    });
    return total;
  }

  //find a stock in the list using its id
  Stock findStockById(String id) {
    return _stocks.firstWhere((prod) => prod.id == id);
  }

  //add a stock in the list
  void addStock(Stock stock) {
    _stocks.add(stock);
  }

  //removes a stock
  void removeStock(String id) {
    int stockIndex = _stocks.indexWhere((stock) => stock.id == id);
    _stocks.removeAt(stockIndex);
  }

  //method so we can do request for the prices with a delay
  bool readyForRequest() {
    if(_nextRequestTimer == null){
      _nextRequestTimer = DateTime.now().add(Duration(minutes: 10));
      return true;
    }
    if(_nextRequestTimer.isBefore(DateTime.now())){
      _nextRequestTimer = DateTime.now().add(Duration(minutes: 10));
      return true;
    }
    return false;
  }
}
