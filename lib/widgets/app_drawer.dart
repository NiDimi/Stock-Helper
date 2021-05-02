import 'package:flutter/material.dart';
import 'package:stock_helper/screens/history_screen.dart';
import 'package:stock_helper/screens/portfolio_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    final dividerColor = Colors.white38;
    final iconColor = Color.fromARGB(255, 210, 210, 210);
    return Drawer(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('Name of the app'),
              automaticallyImplyLeading: false,
            ),
            Divider(
              color: dividerColor,
            ),
            ListTile(
              leading: Icon(
                Icons.account_balance_wallet,
                color: iconColor,
              ),
              title: Text(
                'Portfolios',
                style: textStyle,
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(PortfolioScreen.routeName);
              },
            ),
            Divider(
              color: dividerColor,
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined , color: iconColor),
              title: Text(
                'Historic Data',
                style: textStyle,
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(HistoryScreen.routeName);
              },
            ),
            Expanded(child: Container()),Divider(
              color: dividerColor,
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app, color: iconColor),
              title: Text(
                'Logout',
                style: textStyle,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
