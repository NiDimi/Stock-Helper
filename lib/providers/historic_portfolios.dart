import 'package:flutter/material.dart';
import './stocks.dart';
import '../models/portfolio.dart';

class HistoricPortfolios with ChangeNotifier {
  static List<Portfolio> _portfolios = [
    Portfolio(name: 'Past portfolio 1'),
    Portfolio(name: 'Past portfolio 2'),
  ];

  HistoricPortfolios() {
    Stocks stocks = Stocks();
    for (Portfolio portfolio in _portfolios) {
      portfolio.portfolioStocks = stocks;
    }
  }

  List<Portfolio> get portfolios {
    return [..._portfolios];
  }

  void addPortfolio(Portfolio portfolio) {
    _portfolios.add(portfolio);
    notifyListeners();
  }
}
