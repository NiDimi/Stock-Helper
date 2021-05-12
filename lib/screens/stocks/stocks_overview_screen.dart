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
        //error
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
  Widget stocksDisplay() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: 550, //use the screen size
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (_, index) => Column(
          children: <Widget>[
            StockItem(_stocksData.stocks[index], _removeStock),
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
  Widget mainStockDisplay() {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: Colors.black,
      onRefresh: () => _refreshStocks(context),
      child: Column(children: [
        stocksDisplay(),
        Divider(
          color: Colors.white24,
          thickness: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: RevenueWidget(
              _stocksData.getRevenue(), MainAxisAlignment.spaceBetween),
        )
      ]),
    );
  }

  Widget _addStockButton() {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () async {
        var stock =
            await Navigator.of(context).pushNamed(AddStockScreen.routeName, arguments: _stocksData.portfolioId);
        if(stock != null) {
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
        title: Text(Provider.of<Portfolios>(context).findStockById(_stocksData.portfolioId).name),
        actions: <Widget>[
          _addStockButton(),
        ],
      ),
      body: _stocksData.stocks.isEmpty
          ? Center(
              child: Text('Start adding stocks'),
            )
          : FutureBuilder(
              future: _stockPriceRequestFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return mainStockDisplay();
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
    );
  }
}
