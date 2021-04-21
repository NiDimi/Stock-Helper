import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_helper/models/stock.dart';
import 'package:stock_helper/providers/stocks.dart';

class StockItem extends StatelessWidget {
  final Stock _stock;

  StockItem(this._stock);

  @override
  Widget build(BuildContext context) {
    String percentage = Provider.of<Stocks>(context, listen: false).getPercentage(_stock);
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            _stock.ticker,
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(height: 5,),
          Text(
            _stock.name,
            style: Theme.of(context).textTheme.headline2,
          )
        ],
      ),
      trailing: Container(
          width: 125,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    (_stock.currentPrice * _stock.quantity).toString(),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: percentage.contains("+") ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    height: 30,
                    width: 70,
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
          )),
    );
  }
}
