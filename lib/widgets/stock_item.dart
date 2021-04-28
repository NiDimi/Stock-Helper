import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_helper/models/stock.dart';
import 'package:stock_helper/providers/stocks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stock_helper/screens/add_stock_screen.dart';

/// Class for a stock item
class StockItem extends StatelessWidget {
  final Stock _stock; //the stock that has the data we want to display

  StockItem(this._stock);

  //builds the way the prices are displayed
  Widget stockPriceDisplay(String percentage, TextStyle style){
    return Container(
      width: 125,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(//text for the current price
            (_stock.currentPrice * _stock.quantity).toStringAsFixed(2),
            style: style,
          ),
          Container(//container for the percentage
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: percentage.contains('+') ? Colors.green : Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            height: 30,
            width: 80,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                percentage,
                style: style,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stocksData = Provider.of<Stocks>(context, listen: false);
    String percentage = stocksData.getPercentage(_stock);
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.15,
      child: ListTile(
        title: Text(
          _stock.ticker,
          style: Theme.of(context).textTheme.headline1,
        ),
        subtitle: Text(
          _stock.name,
          style: Theme.of(context).textTheme.headline2,
        ),
        trailing: stockPriceDisplay(percentage, Theme.of(context).textTheme.bodyText1),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Close',
          color: Colors.green,
          icon: Icons.attach_money,
          onTap: () {
            //it needs functionality for history
          },
        ),
        IconSlideAction(
          caption: 'Edit',
          color: Color.fromARGB(255, 0, 0, 255),
          icon: Icons.edit,
          onTap: () {
            Navigator.of(context).pushNamed(AddStockScreen.routeName, arguments: _stock);
          },
        ),
        IconSlideAction(
          caption: 'Remove',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            stocksData.removeStock(_stock.id);
          },
        )
      ],
    );
  }
}
