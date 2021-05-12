import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/portfolios/new_portfolio_widget.dart';
import '../../widgets/portfolios/portfolio_item.dart';
import '../../providers/portfolios.dart';

//main screen that shows the portfolios
class PortfolioScreen extends StatelessWidget {
  static const routeName = '/portfolios';

  @override
  Widget build(BuildContext context) {
    final portfolioData = Provider.of<Portfolios>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Portfolios'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => NewPortfolioWidget(null),
                );
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
