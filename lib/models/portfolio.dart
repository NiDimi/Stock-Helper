import 'package:flutter/material.dart';
import 'package:stock_helper/models/stock.dart';
import 'package:stock_helper/providers/stocks.dart';

//model class for the stocks
class Portfolio {
  final String name;
  int revenue;
  Stocks portfolioStocks;

  Portfolio({
    @required this.name,
    this.portfolioStocks,
  });
}
