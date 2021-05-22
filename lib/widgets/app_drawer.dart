import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_helper/providers/auth.dart';
import 'package:stock_helper/screens/auth/auth_screen.dart';
import '../screens/portfolios/portfolio_screen.dart';
import '../screens/history/history_screen.dart';

class AppDrawer extends StatelessWidget {

  //tile for the portfolios screen
  Widget portfoliosTile(){}

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
              title: Image.asset(
                'assets/images/logo.png',
                height: 180,
              ),
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
              onTap: () {
                Navigator.of(context).pop();
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
