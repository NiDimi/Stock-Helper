import 'package:flutter/material.dart';
import '../providers/stocks.dart';

//model class for the stocks
class Portfolio {
  final String id;
  final String name;
  Stocks portfolioStocks;

  Portfolio({@required this.id, @required this.name, this.portfolioStocks}) {
    if (portfolioStocks == null) {
      //if we dont pass the stocks create a new stock list which will be empty
      portfolioStocks = new Stocks(id);
    }
  }
}
