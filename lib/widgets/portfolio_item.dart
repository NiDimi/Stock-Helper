import 'package:flutter/material.dart';
import 'package:stock_helper/models/portfolio.dart';
import 'package:stock_helper/screens/stocks_overview_screen.dart';
import 'package:stock_helper/widgets/revenue_widget.dart';

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
            Text(
              _portfolio.name,
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
            Divider(
              color: Theme.of(context).accentColor,
            ),
            _portfolio.portfolioStocks == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[SizedBox(height: 50,),Text('Add some stocks', style: Theme.of(context).textTheme.headline2,)],
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
            color: Color.fromARGB(255, 80, 80, 80),
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
