import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/historic_portfolios.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/history/history_item.dart';
import '../../widgets/revenue_widget.dart';

class HistoryScreen extends StatelessWidget {
  static const routeName = '/history';

  //container for the historic portfolios
  Widget historyDataContainer(HistoricPortfolios historyData) {
    return Container(
      height: 400, //needs media query,
      child: ListView.builder(
        itemCount: historyData.portfolios.length,
        itemBuilder: (context, index) =>
            HistoryItem(historyData.portfolios[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final historyData = Provider.of<HistoricPortfolios>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Historic Transactions'),
      ),
      drawer: AppDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            historyDataContainer(historyData),
            Expanded(child: Container()),
            Divider(
              color: Colors.white24,
              thickness: 5.0,
            ),
            RevenueWidget(historyData.getRevenue(), MainAxisAlignment.spaceBetween),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
