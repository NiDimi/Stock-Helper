import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../../providers/historic_portfolios.dart';
import '../../models/stock.dart';

//Class for the stock item
class StockItem extends StatefulWidget {
  final Stock _stock;
  final Function _removeStock;

  const StockItem(this._stock, this._removeStock, {Key key}) : super(key: key);

  @override
  _StockItemState createState() => _StockItemState();
}

class _StockItemState extends State<StockItem> {
  Stock _stock; // we may edit the certain stock
  final slideActionColor = Color.fromARGB(255, 40, 40, 40);

  @override
  void initState() {
    super.initState();
    _stock = widget._stock;
  }

  Widget stockPriceDisplay(TextStyle style) {
    String percentage = widget._stock.getPercentage();
    return Container(
      width: 125,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            //text for the current price
            (widget._stock.currentPrice * widget._stock.quantity)
                .toStringAsFixed(2),
            style: style,
          ),
          Container(
            //container for the percentage
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                color: percentage.contains('+') ? Colors.green : Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            height: 30,
            width: 80,
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  percentage,
                  style: style,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget stockListTile(BuildContext context) {
    return ListTile(
      title: Text(
        widget._stock.ticker,
        style: Theme.of(context).textTheme.headline1,
      ),
      subtitle: Text(
        widget._stock.name,
        style: Theme.of(context).textTheme.headline2,
      ),
      trailing: stockPriceDisplay(Theme.of(context).textTheme.bodyText1),
    );
  }

  Widget closeSlideAction() {
    return IconSlideAction(
      iconWidget: slideActionContainer(Icons.attach_money, 'Buy'),
      color: slideActionColor,
      onTap: () {
        //it needs functionality for history
      },
    );
  }

  Widget editSlideAction() {
    return IconSlideAction(
      iconWidget: slideActionContainer(Icons.edit, 'Close'),
      color: slideActionColor,
      onTap: () {
        Provider.of<HistoricPortfolios>(context, listen: false)
            .addHistoricTransaction(_stock);
        widget._removeStock(widget._stock.id);
      },
    );
  }

  Widget removeSlideAction() {
    return IconSlideAction(
      iconWidget: slideActionContainer(Icons.delete, 'Remove'),
      color: slideActionColor,
      onTap: () {
        widget._removeStock(widget._stock.id);
      },
    );
  }

  Widget slideActionContainer(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      height: 50,
      width: 50,
      child: Align(
        alignment: Alignment.center,
        child: Wrap(
          spacing: 2,
          direction: Axis.vertical,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.15,
      child: stockListTile(context),
      secondaryActions: <Widget>[
        closeSlideAction(),
        editSlideAction(),
        removeSlideAction(),
      ],
    );
  }
}
