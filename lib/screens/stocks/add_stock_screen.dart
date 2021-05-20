import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/api_requests.dart';
import '../../models/stock.dart';

class AddStockScreen extends StatefulWidget {
  static const routeName = '/add-stock';

  @override
  _AddStockScreenState createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final _form = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _quantityFocusNode = FocusNode();
  var _stock = Stock(price: 0, quantity: 0, ticker: '');
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

  //function for submitting the form
  Future<void> _submitForm() async {
    final isValid = _form.currentState.validate(); // first validate the input
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      //loading because we need to wait to check if the stock exists
      _isLoading = true;
    });
    final apiRequests = Provider.of<ApiRequests>(context, listen: false);
    _stock = await apiRequests.checkIfStockExists(_stock);
    if (_stock == null) {
      _stock = Stock(price: 0, quantity: 0, ticker: ''); //reset it to the start
      //if the stock doesnt exist display a dialog informing the user
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid Ticker'),
          content: Text(
              'You entered a ticker that doesn\'t exist. Please make sure that the ticker exist'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = false;
                });

                Navigator.of(context).pop();
              },
              child: Text('Okay'),
            )
          ],
        ),
      );
    } else {
      final portfolioId = ModalRoute.of(context).settings.arguments
          as String; //the portfolio id passed
      if (portfolioId == null) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error!!!'),
            content: Text(
                'Something went wrong while trying to add the stock. Please try again'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              )
            ],
          ),
        );
      }
      _stock.portfolioId = portfolioId;
      if (_stock != null) {
        //if the stock exists send it back
        Navigator.of(context).pop(_stock);
      }
    }
  }

  //Text field for the ticker
  Widget tickerTextField() {
    return TextFormField(
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
            id: _stock.id,
            name: _stock.name,
            ticker: ticker.toUpperCase(),
            price: _stock.price,
            quantity: _stock.quantity);
      },
    );
  }

  //Text field for the price
  Widget priceTextField() {
    return TextFormField(
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
          return 'PLease enter a price';
        }
        if (double.parse(price) == null) {
          return 'Please enter a valid number';
        }
        if (double.parse(price) <= 0) {
          return 'Please enter a number greater than zero';
        }
        return null;
      },
      onSaved: (price) {
        _stock = Stock(
            id: _stock.id,
            name: _stock.name,
            ticker: _stock.ticker,
            price: double.parse(price),
            quantity: _stock.quantity);
      },
    );
  }

  //Text field for the quantity
  Widget quantityTextField() {
    return TextFormField(
      style: TextStyle(color: Theme.of(context).accentColor),
      keyboardType: TextInputType.number,
      decoration: textInputDecoration('Quantity'),
      textInputAction: TextInputAction.done,
      focusNode: _quantityFocusNode,
      onFieldSubmitted: (_) {
        _submitForm();
      },
      validator: (quantity) {
        if (quantity.isEmpty) {
          return 'PLease enter a quantity';
        }
        if (quantity.contains('.')) {
          return 'Please enter an integer';
        }
        if (int.parse(quantity) == null) {
          return 'Please enter a valid number';
        }
        if (int.parse(quantity) <= 0) {
          return 'Please enter a number greater than zero';
        }
        return null;
      },
      onSaved: (quantity) {
        _stock = Stock(
            id: _stock.id,
            name: _stock.name,
            ticker: _stock.ticker,
            price: _stock.price,
            quantity: int.parse(quantity));
      },
    );
  }

  //widget to show while we are validating the input
  Widget validatingDisplay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text(
            'Validating data',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  //widget to display the form
  Widget formDisplay() {
    return Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: <Widget>[
          tickerTextField(),
          SizedBox(
            height: 20,
          ),
          priceTextField(),
          SizedBox(
            height: 20,
          ),
          quantityTextField(),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Submit'),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
                foregroundColor:
                    MaterialStateProperty.all(Theme.of(context).accentColor)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Your New Stock'),
      ),
      body: _isLoading ? validatingDisplay() : formDisplay(),
    );
  }
}
