import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_helper/providers/portfolios.dart';
import 'package:stock_helper/widgets/app_drawer.dart';
import 'package:stock_helper/widgets/history_item.dart';
import 'package:stock_helper/widgets/revenue_widget.dart';

class HistoryScreen extends StatelessWidget {
  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    final portfolioData = Provider.of<Portfolios>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Historic Transactions'),
        ),
        drawer: AppDrawer(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            Container(
              height: 400,//needs media query,
              child: ListView.builder(
                itemCount: portfolioData.portfolios.length,
                itemBuilder: (context, index) =>
                    HistoryItem(portfolioData.portfolios[index]),
              ),
            ),
            Expanded(child: Container()),
            Divider(
              color: Colors.white24,
              thickness: 5.0,
            ),
            RevenueWidget(400, MainAxisAlignment.spaceBetween)
          ],),
        ),);
  }
}
