import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_helper/models/stock.dart';
import 'package:stock_helper/providers/stocks.dart';

class AddStockScreen extends StatefulWidget {
  static const routeName = '/add-stock';

  @override
  _AddStockScreenState createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final _form = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _quantityFocusNode = FocusNode();
  var _stock = Stock(price: 0, quantity: 0, ticker: "");
  var _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _quantityFocusNode.dispose();
  }

  //The decoration used for the inputs
  InputDecoration textInputDecoration(String title) {
    return InputDecoration(
      labelText: title,
      labelStyle: Theme.of(context).textTheme.bodyText1,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            style: BorderStyle.solid, color: Theme.of(context).accentColor),
      ),
    );
  }

  //Function for submitting the from
  Future<void> _submitForm() async {
    final isValid = _form.currentState.validate();//validate the input
    if (!isValid) {
      return;//if it fails return
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;//loading because we need to wait to check if the stock exists
    });
    final stocksData = Provider.of<Stocks>(context, listen: false);
    _stock = await stocksData.checkIfStockExists(_stock);
    if (_stock == null) {//if the stock doesnt exist display a dialog informing the user
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid Ticker'),
          content: Text(
              'You entered a ticker that doesn\'t exist. Please make sure that the ticker exist'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Okay'),
            )
          ],
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
    if (_stock != null) {//if the stock exists add the stock in the list and go back
      stocksData.addStock(_stock);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Your New Stock'),
      ),
      body: _isLoading
          ? Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 10,),
                  Text(
                    'Validating data',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
          )
          : Form(
              key: _form,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: <Widget>[
                  TextFormField(//Text field for the ticker
                    style: TextStyle(color: Theme.of(context).accentColor),
                    keyboardType: TextInputType.name,
                    decoration: textInputDecoration('Ticker'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    validator: (ticker) {
                      if (ticker.isEmpty) {
                        return 'Please provide a ticker';
                      }
                      return null;
                    },
                    onSaved: (ticker) {
                      _stock = Stock(
                          ticker: ticker.toUpperCase(),
                          price: _stock.price,
                          quantity: _stock.quantity);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(//Text field for the price
                    style: TextStyle(color: Theme.of(context).accentColor),
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration('Price'),
                    textInputAction: TextInputAction.next,
                    focusNode: _priceFocusNode,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_quantityFocusNode);
                    },
                    validator: (price) {
                      if (price.isEmpty) {
                        return "PLease enter a price";
                      }
                      if (double.parse(price) == null) {
                        return "Please enter a valid number";
                      }
                      if (double.parse(price) <= 0) {
                        return "Please enter a number greater than zero";
                      }
                      return null;
                    },
                    onSaved: (price) {
                      _stock = Stock(
                          ticker: _stock.ticker,
                          price: double.parse(price),
                          quantity: _stock.quantity);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(//Text field for the quantity
                    style: TextStyle(color: Theme.of(context).accentColor),
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration('Quantity'),
                    textInputAction: TextInputAction.done,
                    focusNode: _quantityFocusNode,
                    onFieldSubmitted: (_) {
                      _submitForm();
                    },
                    validator: (price) {
                      if (price.isEmpty) {
                        return "PLease enter a quantity";
                      }
                      if (double.parse(price) == null) {
                        return "Please enter a valid number";
                      }
                      if (double.parse(price) <= 0) {
                        return "Please enter a number greater than zero";
                      }
                      return null;
                    },
                    onSaved: (quantity) {
                      _stock = Stock(
                          ticker: _stock.ticker,
                          price: _stock.price,
                          quantity: int.parse(quantity));
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
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
    );
  }
}
