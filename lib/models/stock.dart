import 'package:flutter/material.dart';

class Stock {
  String name;
  final String ticker;
  final double price;
  final int quantity;
  double currentPrice;

  Stock({
    @required this.ticker,
    @required this.price,
    @required this.quantity,
  });
}