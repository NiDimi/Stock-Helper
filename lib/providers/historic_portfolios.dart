import 'package:flutter/material.dart';
import '../providers/portfolios.dart';
import '../models/portfolio.dart';
import '../models/stock.dart';
import 'package:uuid/uuid.dart';
import './stocks.dart';
import '../models/portfolio.dart';

class HistoricPortfolios with ChangeNotifier {
  // static List<Portfolio> _portfolios = [
  //   Portfolio(name: 'Past portfolio 1', id: Uuid().v1()),
  //   Portfolio(name: 'Past portfolio 2', id: Uuid().v1()),
  // ];

  static List<Portfolio> _portfolios = [];

  // HistoricPortfolios() {
  //   for (Portfolio portfolio in _portfolios) {
  //     Stocks stocks = Stocks(portfolio.id);
  //     portfolio.portfolioStocks = stocks;
  //   }
  // }

  List<Portfolio> get portfolios {
    return [..._portfolios];
  }

  // //add new portfolio to the historic ones
  // void addPortfolio(Portfolio portfolio) {
  //   _portfolios.add(portfolio);
  //   notifyListeners();
  // }

  //close a stock and added into the historic data
  void addHistoricTransaction(Stock stock){
    //first we need to check if we already have a portfolio that the stock belongs too
    final doesExist = _portfolios.indexWhere((portfolio) => portfolio.id == stock.portfolioId);
    if(doesExist > -1){
      _portfolios[doesExist].portfolioStocks.addStock(stock);
      return;
    }

    String name = Portfolios().portfolios.firstWhere((portfolio) => portfolio.id == stock.portfolioId).name;
    _portfolios.add(Portfolio(id: stock.portfolioId, name: name));
    _portfolios[_portfolios.length - 1].portfolioStocks.addStock(stock);
  }

  double getRevenue(){
    double total = 0;
    for (Portfolio portfolio in _portfolios){
      total += portfolio.portfolioStocks.getRevenue();
    }
    return total;
  }
}
