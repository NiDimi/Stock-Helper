import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_helper/models/portfolio.dart';
import 'package:stock_helper/providers/portfolios.dart';

class NewPortfolioWidget extends StatefulWidget {
  final Portfolio _prevPortfolio;


  NewPortfolioWidget(this._prevPortfolio);

  @override
  _NewPortfolioWidgetState createState() => _NewPortfolioWidgetState();
}

class _NewPortfolioWidgetState extends State<NewPortfolioWidget> {
  final _form = GlobalKey<FormState>();
  String _name;

  @override
  initState(){
    super.initState();
    if(widget._prevPortfolio != null) {
      _name = widget._prevPortfolio.name;
    }
  }

  Future<void> _submitForm() async {
    final isValid = _form.currentState.validate();
    if(!isValid){
      return;
    }
    _form.currentState.save();
    final portfoliosData = Provider.of<Portfolios>(context, listen: false);
    if(widget._prevPortfolio == null){
      portfoliosData.addPortfolio(new Portfolio(name: _name));
    } else {
      portfoliosData.changePortfolioName(widget._prevPortfolio, _name);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _name == null ? "" : _name,
                  decoration: InputDecoration(labelText: 'Portfolio Name'),
                  onFieldSubmitted: (_) {
                    _submitForm();
                  },
                  validator: (value) {
                    if(value.isEmpty){
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _name = newValue,
                ),
                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(_name == null ?'Add new portfolio' : 'Change the name'),
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
      ),
    );
  }
}
