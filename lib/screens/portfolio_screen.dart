import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_helper/providers/portfolios.dart';
import 'package:stock_helper/widgets/app_drawer.dart';
import 'package:stock_helper/widgets/new_portfolio_widget.dart';
import 'package:stock_helper/widgets/portfolio_item.dart';

class PortfolioScreen extends StatelessWidget {
  static const routeName = '/portfolios';

  @override
  Widget build(BuildContext context) {
    final portfolioData = Provider.of<Portfolios>(context);
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.grey,
        title: const Text('Your Portfolios'),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.add), onPressed: () {
            showModalBottomSheet(context: context, builder: (context) => NewPortfolioWidget(null),);
          })
        ],
      ),
      drawer: AppDrawer(),
      body: GridView(
        children:
            portfolioData.portfolios.map((e) => PortfolioItem(e)).toList(),
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          childAspectRatio: 7 / 4,
          crossAxisSpacing: 100,
          mainAxisSpacing: 20,
        ),
      ),
    );
  }
}
