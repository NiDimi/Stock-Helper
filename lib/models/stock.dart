import 'package:flutter/material.dart';

class Stock {
  String _name;
  final String ticker;
  final double price;
  final int quantity;
  double _currentPrice;

  Stock({
    @required this.ticker,
    @required this.price,
    @required this.quantity,
  });

  double get currentPrice => _currentPrice;

  set currentPrice(double value) {
    _currentPrice = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}
