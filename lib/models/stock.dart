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
    this.currentPrice,
  });

  //get the percentage of the increase/decrease for the stock
  String getPercentage() {
    String percentage = "";
    if (currentPrice != null) {
      if (price > currentPrice) {
        percentage += "-";
        double difference = (price - currentPrice) / currentPrice * 100;
        percentage += difference.toStringAsFixed(2);
      } else {
        percentage += "+";
        double difference = (currentPrice - price) / price * 100;
        percentage += difference.toStringAsFixed(2);
      }
      percentage += "%";
      return percentage;
    } else {
      //error
      return "";
    }
  }
}
