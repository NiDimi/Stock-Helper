import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/api_requests.dart';
import '../../screens/stocks/stocks_overview_screen.dart';
import '../revenue_widget.dart';
import '../../providers/portfolios.dart';
import '../../models/portfolio.dart';

import './new_portfolio_widget.dart';

enum MenuOption {
  Edit,
  Delete,
}

class PortfolioItem extends StatefulWidget {
  final Portfolio _portfolio;
  final double _height;

  PortfolioItem(this._portfolio, this._height);

  @override
  _PortfolioItemState createState() => _PortfolioItemState();
}

class _PortfolioItemState extends State<PortfolioItem> {
  Widget portfolioTitle(BuildContext context) {
    return ListTile(
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          widget._portfolio.name,
          style: Theme.of(context).textTheme.headline1,
          textAlign: TextAlign.center,
        ),
      ),
      trailing: PopupMenuButton(
        onSelected: (MenuOption selectedValue) {
          if (selectedValue == MenuOption.Edit) {
            showModalBottomSheet(
              context: context,
              builder: (context) => NewPortfolioWidget(widget._portfolio),
            );
          } else {
            Provider.of<Portfolios>(context, listen: false)
                .removePortfolio(widget._portfolio);
          }
        },
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).accentColor,
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Edit name'),
                Icon(Icons.edit, color: Theme.of(context).primaryColor),
              ],
            ),
            value: MenuOption.Edit,
          ),
          PopupMenuItem(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Delete'),
                Icon(Icons.delete, color: Theme.of(context).primaryColor),
              ],
            ),
            value: MenuOption.Delete,
          )
        ],
      ),
      dense: true,
    );
  }

  //widget to be displayed when we dont have stocks in the portfolio
  Widget emptyStocks(BuildContext context) {
    return Column(
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
    );
  }

  //Widget that display the stock data
  Widget stockDisplay(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: widget._height - 120,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: widget._portfolio.portfolioStocks.stocks.map((stock) {
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        stock.ticker,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        stock.currentPrice.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 15,
                            color: stock.currentPrice > stock.price
                                ? Colors.green
                                : Colors.red),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        RevenueWidget(widget._portfolio.portfolioStocks.getRevenue(),
            MainAxisAlignment.center),
      ],
    );
  }

  //main widget for when the future loads
  Widget mainPortfolioDisplay() {
    return InkWell(
      onTap: () async {
        await Navigator.of(context).pushNamed(StocksOverviewScreen.routeName,
            arguments: widget._portfolio.portfolioStocks);
        setState(() {});
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            portfolioTitle(context),
            Divider(
              color: Theme.of(context).accentColor,
            ),
            widget._portfolio.portfolioStocks.stocks.isEmpty
                ? emptyStocks(context)
                : stockDisplay(context),
          ],
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPricesFuture = Provider.of<ApiRequests>(context, listen: false)
        .fetchCurrentPrices(widget._portfolio.portfolioStocks);
    return widget._portfolio.portfolioStocks.stocks.isEmpty ? mainPortfolioDisplay() : FutureBuilder(
      future: currentPricesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return mainPortfolioDisplay();
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
