import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/portfolio.dart';
import 'package:http/http.dart' as http;

class Portfolios with ChangeNotifier {
  // list with all the portfolios

  static List<Portfolio> _portfolios = [];

  //getter for the portfolio list
  List<Portfolio> get portfolios {
    return [..._portfolios];
  }

  //method to add a new portfolio
  Future<void> addPortfolio(Portfolio portfolio) async {
    var response = await http.post(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/portfolios.json'),
      body: json.encode(
        {
          'name': portfolio.name,
        },
      ),
    );
    if (response.statusCode >= 400) {
      return;
    }
    _portfolios.add(Portfolio(
        id: json.decode(response.body)['name'], name: portfolio.name));
    notifyListeners();
  }

  //method to remove a portfolio
  Future<void> removePortfolio(Portfolio portfolio) async {
    //first remove so the user wont have the delay in the remove
    _portfolios.remove(portfolio);
    notifyListeners();
    var response = await http.delete(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/portfolios/${portfolio.id}.json'),
    );
    if (response.statusCode >= 400) {
      _portfolios.add(portfolio);//if we failed removing add it back in
    }
  }

  //method to change a portfolios name
  Future<void> changePortfolioName(Portfolio oldPortfolio, String newName) async {
    // we get the index of the portfolio we want to change its name,
    // remove it from the list and add a new one with the same data but with the new name in each place
    int portfolioIndex =
        _portfolios.indexWhere((element) => element == oldPortfolio);
    var response = await http.patch(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/portfolios/${oldPortfolio.id}.json'),
      body: json.encode(
        {'name': newName},
      ),
    );
    if (response.statusCode >= 400) {
      return;
    }

    _portfolios[portfolioIndex] = new Portfolio(
        id: oldPortfolio.id,
        name: newName,
        portfolioStocks: oldPortfolio.portfolioStocks);

    notifyListeners();
  }

  //find a portfolio in the list using its id
  Portfolio findStockById(String id) {
    return _portfolios.firstWhere((portfolio) => portfolio.id == id);
  }

  //fetches and sets the portfolios from firebase
  Future<void> fetchAndSetPortfolios() async {
    var response = await http.get(
      Uri.parse(
          'https://stockity-4ae33-default-rtdb.firebaseio.com/portfolios.json'),
    );
    if (response.statusCode >= 400) {
      return;
    }

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData != null) {
      extractedData.forEach((portfolioId, portfolioData) {
        _portfolios
            .add(Portfolio(id: portfolioId, name: portfolioData['name']));
      });
    }
  }
}
