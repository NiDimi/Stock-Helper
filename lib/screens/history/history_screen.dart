import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/historic_portfolios.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/history/history_item.dart';
import '../../widgets/revenue_widget.dart';

class HistoryScreen extends StatelessWidget {
  static const routeName = '/history';

  //container for the historic portfolios
  Widget historyDataContainer(double height, HistoricPortfolios historyData) {
    return Container(
      height: height - 150,
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
      body: historyData.portfolios.isEmpty
          ? Center(
              child: Text('You haven\'t closed any stocks yet'),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  historyDataContainer(
                      MediaQuery.of(context).size.height, historyData),
                  Expanded(child: Container()),
                  Divider(
                    color: Colors.white24,
                    thickness: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: RevenueWidget(historyData.getRevenue(),
                        MainAxisAlignment.spaceBetween),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
    );
  }
}
