import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/portfolios.dart';
import '../../models/portfolio.dart';

//widget for changing the name or adding new portfolios
class NewPortfolioWidget extends StatefulWidget {
  final Portfolio _prevPortfolio;

  NewPortfolioWidget(this._prevPortfolio);

  @override
  _NewPortfolioWidgetState createState() => _NewPortfolioWidgetState();
}

class _NewPortfolioWidgetState extends State<NewPortfolioWidget> {
  final _form = GlobalKey<FormState>();
  String _name;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget._prevPortfolio != null) {
      _name = widget._prevPortfolio.name;
    }
  }

  //method for submitting the form
  Future<void> _submitForm() async {
    //first we need to validate the form for correct data
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    final portfoliosData = Provider.of<Portfolios>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    if (widget._prevPortfolio == null) {
      await portfoliosData
          .addPortfolio(new Portfolio(name: _name, id: Uuid().v1()));
    } else {
      await portfoliosData.changePortfolioName(widget._prevPortfolio, _name);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Card(
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _name == null ? '' : _name,
                        decoration:
                            InputDecoration(labelText: 'Portfolio Name'),
                        onFieldSubmitted: (_) {
                          _submitForm();
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        onSaved: (newValue) => _name = newValue,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text(_name == null
                            ? 'Add new portfolio'
                            : 'Change the name'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor),
                            foregroundColor: MaterialStateProperty.all(
                                Theme.of(context).accentColor)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
