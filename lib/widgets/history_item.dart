import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stock_helper/models/portfolio.dart';
import 'package:stock_helper/widgets/revenue_widget.dart';

class HistoryItem extends StatefulWidget {
  final Portfolio _portfolio;

  HistoryItem(this._portfolio);

  @override
  _HistoryItemState createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Theme.of(context).primaryColor,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            ListTile(
              tileColor: Theme.of(context).primaryColor,
              title: Text(
                widget._portfolio.name,
                style: Theme.of(context).textTheme.headline1,
              ),
              subtitle: RevenueWidget(
                  widget._portfolio.portfolioStocks.getRevenue(),
                  MainAxisAlignment.start),
              trailing: IconButton(
                color: Colors.white,
                icon: Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
              Container(
                height: 150,
                child: ListView(
                  children: widget._portfolio.portfolioStocks.stocks
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(e.name),
                              Text(e.price.toString())
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
