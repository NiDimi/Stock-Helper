import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_helper/models/stock.dart';
import 'package:stock_helper/providers/stocks.dart';
import 'package:stock_helper/screens/add_stock_screen.dart';
import 'package:stock_helper/widgets/stock_item.dart';

class StocksOverviewScreen extends StatefulWidget {
  @override
  _StocksOverviewScreenState createState() => _StocksOverviewScreenState();
}

class _StocksOverviewScreenState extends State<StocksOverviewScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Stocks>(context, listen: false)
          .fetchCurrentPrices()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  Future<void> _refreshStocks(BuildContext context) async {
    await Provider.of<Stocks>(context, listen: false).fetchCurrentPrices();
  }

  @override
  Widget build(BuildContext context) {
    final stocksData = Provider.of<Stocks>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        shadowColor: Colors.grey,
        title: const Text('Your Stocks'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _isInit = true;//reset to re-fetch the prices
                Navigator.of(context).pushNamed(AddStockScreen.routeName);
              })
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              backgroundColor: Colors.white,
              color: Colors.black,
              onRefresh: () => _refreshStocks(context),
              child: Column(children: [
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: 550, //use the screen size
                  child: ListView.builder(
                    itemBuilder: (_, index) => Column(
                      children: [
                        StockItem(stocksData.stocks[index]),
                        if (index != stocksData.stocks.length - 1)
                          Divider(
                            color: Colors.white24,
                          )
                      ],
                    ),
                    itemCount: stocksData.stocks.length,
                  ),
                ),
                Divider(
                  color: Colors.white24,
                  thickness: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stocksData.getRevenue() > 0 ? "Revenue:" : "Lost:",
                        style: stocksData.getRevenue() > 0
                            ? Theme.of(context).textTheme.headline3
                            : Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        stocksData.getRevenue() > 0
                            ? "+${stocksData.getRevenue().toStringAsFixed(0)}"
                            : stocksData.getRevenue().toStringAsFixed(0),
                        style: stocksData.getRevenue() > 0
                            ? Theme.of(context).textTheme.headline3
                            : Theme.of(context).textTheme.headline4,
                      )
                    ],
                  ),
                )
              ]),
            ),
    );
  }
}
