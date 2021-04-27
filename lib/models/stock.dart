import 'package:flutter/material.dart';

//model class for the stocks
class Stock {
  final String id;
  final String name;
  final String ticker;
  final double price;
  final int quantity;
  double currentPrice;

  Stock({
    this.id,
    this.name,
    @required this.ticker,
    @required this.price,
    @required this.quantity,
  });
}
