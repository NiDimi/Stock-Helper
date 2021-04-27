import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_helper/models/stock.dart';
import 'package:stock_helper/providers/stocks.dart';

/// Class for a stock item
class StockItem extends StatelessWidget {
  final Stock _stock;//the stock that has the data we want to display

  StockItem(this._stock);

  @override
  Widget build(BuildContext context) {
    String percentage =
        Provider.of<Stocks>(context, listen: false).getPercentage(_stock);
    return ListTile(
      title: StockTitle(stock: _stock),
      trailing: StockPrice(stock: _stock, percentage: percentage),
    );
  }
}

//class to set up the stock name
class StockPrice extends StatelessWidget {
  const StockPrice({
    Key key,
    @required Stock stock,
    @required this.percentage,
  }) : _stock = stock, super(key: key);

  final Stock _stock;
  final String percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                (_stock.currentPrice * _stock.quantity).toStringAsFixed(2),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color:
                        percentage.contains("+") ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                height: 30,
                width: 80,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    percentage,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

//class to set up the stock price
class StockTitle extends StatelessWidget {
  const StockTitle({
    Key key,
    @required Stock stock,
  })  : _stock = stock,
        super(key: key);

  final Stock _stock;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          _stock.ticker,
          style: Theme.of(context).textTheme.headline1,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          _stock.name,
          style: Theme.of(context).textTheme.headline2,
        )
      ],
    );
  }
}
