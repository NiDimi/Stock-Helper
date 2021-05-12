import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/portfolio.dart';

class Portfolios with ChangeNotifier {
  //list with all the portfolios
  // static List<Portfolio> _portfolios = [
  //   Portfolio(name: 'Technology Stocks', id: Uuid().v1()),
  //   Portfolio(name: 'Fashion Stocks', id: Uuid().v1()),
  // ];

  static List<Portfolio> _portfolios = [];

  //getter for the portfolio list
  List<Portfolio> get portfolios {
    return [..._portfolios];
  }

  //method to add a new portfolio
  void addPortfolio(Portfolio portfolio) {
    _portfolios.add(portfolio);
    notifyListeners();
  }

  //method to remove a portfolio
  void removePortfolio(Portfolio portfolio) {
    _portfolios.remove(portfolio);
    notifyListeners();
  }

  //method to change a portfolios name
  void changePortfolioName(Portfolio portfolio, String newName) {
    // we get the index of the portfolio we want to change its name,
    // remove it from the list and add a new one with the same data but with the new name in each place
    int portfolioIndex =
        _portfolios.indexWhere((element) => element == portfolio);
    _portfolios.removeAt(portfolioIndex);
    _portfolios.insert(
        portfolioIndex,
        new Portfolio(
            id: Uuid().v1(),
            name: newName,
            portfolioStocks: portfolio.portfolioStocks));
    notifyListeners();
  }

  //find a portfolio in the list using its id
  Portfolio findStockById(String id) {
    return _portfolios.firstWhere((portfolio) => portfolio.id == id);
  }
}
