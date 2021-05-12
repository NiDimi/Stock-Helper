import 'package:flutter/material.dart';
import '../providers/stocks.dart';

//model class for the stocks
class Portfolio {
  final String id;
  final String name;
  Stocks portfolioStocks;

  Portfolio({@required this.id, @required this.name, this.portfolioStocks}) {
    if (portfolioStocks == null) {
      portfolioStocks = new Stocks(id);
    }
  }
}
