import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/portfolios/new_portfolio_widget.dart';
import '../../widgets/portfolios/portfolio_item.dart';
import '../../providers/portfolios.dart';

//main screen that shows the portfolios
class PortfolioScreen extends StatefulWidget {
  static const routeName = '/portfolios';

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    final portfolioData = Provider.of<Portfolios>(context, listen: false);
    if (portfolioData.portfolios.isEmpty && _isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Portfolios>(context, listen: false).fetchAndSetPortfolios().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final portfolioData = Provider.of<Portfolios>(context);
    final gridItemHeight = MediaQuery.of(context).size.height / 3.5;
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : portfolioData.portfolios.isEmpty
              ? Center(
                  child: Text(
                    'You have no portfolios\nClick the "+" and start adding portfolios',
                    textAlign: TextAlign.center,
                  ),
                )
              : GridView(
                  children: portfolioData.portfolios
                      .map((portfolio) =>
                          PortfolioItem(portfolio, gridItemHeight))
                      .toList(),
                  padding: const EdgeInsets.all(20),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery.of(context).size.width,
                    mainAxisExtent: gridItemHeight,
                    mainAxisSpacing: 20,
                  ),
                ),
    );
  }
}
