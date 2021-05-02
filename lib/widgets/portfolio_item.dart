import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_helper/models/portfolio.dart';
import 'package:stock_helper/providers/portfolios.dart';
import 'package:stock_helper/screens/stocks_overview_screen.dart';
import 'package:stock_helper/widgets/revenue_widget.dart';

import 'new_portfolio_widget.dart';


enum MenuOption {
  Edit,
  Delete,
}

class PortfolioItem extends StatelessWidget {
  final Portfolio _portfolio;

  PortfolioItem(this._portfolio);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(StocksOverviewScreen.routeName);
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                _portfolio.name,
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
              trailing: PopupMenuButton(
                onSelected: (MenuOption selectedValue) {
                  if(selectedValue == MenuOption.Edit){
                    showModalBottomSheet(context: context, builder: (context) => NewPortfolioWidget(_portfolio),);
                  } else {
                    Provider.of<Portfolios>(context, listen: false).removePortfolio(_portfolio);
                  }
                },
                icon: Icon(Icons.more_vert, color: Theme.of(context).accentColor,),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Text('Edit name'), Icon(Icons.edit, color: Color.fromARGB(255, 0, 0, 255),),],
                    ),
                    value: MenuOption.Edit,
                  ),PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[Text('Delete'), Icon(Icons.delete, color: Colors.red,),],
                    ),
                    value: MenuOption.Delete,
                  )
                ],
              ),
              dense: true,
            ),
            Divider(
              color: Theme.of(context).accentColor,
            ),
            _portfolio.portfolioStocks == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Add some stocks',
                        style: Theme.of(context).textTheme.headline2,
                      )
                    ],
                  )
                : Column(
                    children: <Widget>[
                      Container(
                        height: 80,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                              children:
                                  _portfolio.portfolioStocks.stocks.map((e) {
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    e.ticker,
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(e.price.toString(),
                                      style:
                                          Theme.of(context).textTheme.bodyText1)
                                ],
                              ),
                            );
                          }).toList()),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      RevenueWidget(_portfolio.portfolioStocks.getRevenue(),
                          MainAxisAlignment.center)
                    ],
                  ),
          ],
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
