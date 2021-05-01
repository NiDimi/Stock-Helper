import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_helper/providers/stocks.dart';
import 'package:stock_helper/screens/add_stock_screen.dart';
import 'package:stock_helper/widgets/revenue_widget.dart';
import 'package:stock_helper/widgets/stock_item.dart';

//class that shows all the stocks
class StocksOverviewScreen extends StatefulWidget {
  static const routeName = '/stock-overview';

  @override
  _StocksOverviewScreenState createState() => _StocksOverviewScreenState();
}

class _StocksOverviewScreenState extends State<StocksOverviewScreen> {
  Future<void> _stocksFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stocksFuture = Provider.of<Stocks>(context, listen: false).fetchCurrentPrices();
  }

  //function to re-fetch the stocks
  Future<void> _refreshStocks(BuildContext context) async {
    setState(() {
      _stocksFuture = Provider.of<Stocks>(context, listen: false).fetchCurrentPrices();
    });
  }

  //display all the stocks
  Widget stocksDisplay (Stocks stocksData){
    return Container(
      padding: EdgeInsets.only(top: 10),
      height: 550, //use the screen size
      child: ListView.builder(
        shrinkWrap: true,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final stocksData = Provider.of<Stocks>(context);
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.grey,
        title: const Text('Your Stocks'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AddStockScreen.routeName);
              })
        ],
      ),
      body: FutureBuilder(
        future: _stocksFuture,
        builder: (context, snapshot) {
          if ((snapshot.connectionState == ConnectionState.done)) {
            return RefreshIndicator(
              backgroundColor: Colors.white,
              color: Colors.black,
              onRefresh: () => _refreshStocks(context),
              child: Column(children: [
                stocksDisplay(stocksData),
                Divider(
                  color: Colors.white24,
                  thickness: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: RevenueWidget(stocksData.getRevenue(), MainAxisAlignment.spaceBetween),
                )
              ]),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }


}
