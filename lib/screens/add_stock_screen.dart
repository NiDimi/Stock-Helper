import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_helper/providers/stocks.dart';

class AddStockScreen extends StatefulWidget {
  static const routeName = '/add-stock';
  @override
  _AddStockScreenState createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Your New Stock'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              StockFormField(
                title: 'Stock\'s Ticker',
                type: TextInputType.name,
              ),
              StockFormField(
                title: 'Stock\'s Price Bought',
                type: TextInputType.number,
              ),
              StockFormField(
                  title: 'Stock\'s Quantity Bought',
                  type: TextInputType.number),
              ElevatedButton(
                onPressed: () {},
                child: Text('Submit'),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).accentColor)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class StockFormField extends StatelessWidget {
  final String title;
  final TextInputType type;

  const StockFormField({
    Key key,
    @required this.title,
    @required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextFormField(
        keyboardType: type,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: Theme.of(context).textTheme.bodyText1,
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(style: BorderStyle.solid, color: Theme.of(context).accentColor),
          ),
        ),
      ),
      Divider(
        height: 20,
      )
    ]);
  }
}
