import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/historic_portfolios.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/history/history_item.dart';
import '../../widgets/revenue_widget.dart';

class HistoryScreen extends StatefulWidget {
  static const routeName = '/history';

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var _isLoading = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    final portfolioData =
        Provider.of<HistoricPortfolios>(context, listen: false);
    if (portfolioData.portfolios.isEmpty && _isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<HistoricPortfolios>(context, listen: false)
          .fetchAndSetHistoricData()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : historyData.portfolios.isEmpty
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
