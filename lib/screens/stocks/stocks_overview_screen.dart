import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/portfolios.dart';
import '../../widgets/revenue_widget.dart';
import '../../widgets/stocks/stock_item.dart';
import '../../providers/api_requests.dart';
import '../../providers/stocks.dart';
import './add_stock_screen.dart';

class StocksOverviewScreen extends StatefulWidget {
  static const routeName = '/stock-overview';

  @override
  _StocksOverviewScreenState createState() => _StocksOverviewScreenState();
}

class _StocksOverviewScreenState extends State<StocksOverviewScreen> {
  Future<void> _stockPriceRequestFuture;
  bool _isInit = true;
  Stocks _stocksData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _stocksData = ModalRoute.of(context).settings.arguments as Stocks;
      if (_stocksData == null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error!!!'),
            content: Text(
                'Something went wrong while trying to fetch the stocks. Please try again'),
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
      _stockPriceRequestFuture =
          Provider.of<ApiRequests>(context, listen: false)
              .fetchCurrentPrices(_stocksData);
      _isInit = false;
    }
  }

  //function to re-fetch the stocks
  Future<void> _refreshStocks(BuildContext context) async {
    setState(() {
      _stockPriceRequestFuture =
          Provider.of<ApiRequests>(context, listen: false)
              .fetchCurrentPrices(_stocksData);
    });
  }

  void _removeStock(String id) {
    setState(() {
      _stocksData.removeStock(id);
    });
  }

  //widget to display all the stocks
  Widget stocksDisplay(double screenHeight) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: screenHeight - 150, //use the screen size
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (_, index) => Column(
          children: <Widget>[
            StockItem(
              _stocksData.stocks[index],
              _removeStock,
              key: Key(_stocksData.stocks[index].id),
            ),
            if (index != _stocksData.stocks.length - 1)
              Divider(
                color: Colors.white24,
              ),
          ],
        ),
        itemCount: _stocksData.stocks.length,
      ),
    );
  }

  //main widget for when the future loads
  Widget mainStockDisplay(double screenHeight) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: Colors.black,
      onRefresh: () => _refreshStocks(context),
      child: Column(children: [
        stocksDisplay(screenHeight),
        Expanded(child: Container()),
        Divider(
          color: Colors.white24,
          thickness: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Expanded(
                child: RevenueWidget(
                    _stocksData.getRevenue(), MainAxisAlignment.spaceBetween),
              ),
              SizedBox(
                width: 5,
              ),
              _revenuePercentageText(),
            ],
          ),
        ),
        SizedBox(height: 10),
      ]),
    );
  }

  Widget _revenuePercentageText() {
    return Text(
      '(${(_stocksData.getRevenue() / _stocksData.getTotalSpent() * 100).toStringAsFixed(2)}%)',
      style: _stocksData.getRevenue() >= 0
          ? Theme.of(context).textTheme.headline3
          : Theme.of(context).textTheme.headline4,
    );
  }

  Widget _addStockButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () async {
        var stock = await Navigator.of(context).pushNamed(
            AddStockScreen.routeName,
            arguments: _stocksData.portfolioId);
        if (stock != null) {
          setState(
            () {
              _stocksData.addStock(stock);
              // _refreshStocks(context);
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<Portfolios>(context)
            .findStockById(_stocksData.portfolioId)
            .name),
        actions: <Widget>[
          _addStockButton(),
        ],
      ),
      body: _stocksData.stocks.isEmpty
          ? Center(
              child: Text(
                'This portfolio is still empty \nPress the "+" to start adding stocks',
                textAlign: TextAlign.center,
              ),
            )
          : FutureBuilder(
              future: _stockPriceRequestFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return mainStockDisplay(MediaQuery.of(context).size.height);
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
    );
  }
}
