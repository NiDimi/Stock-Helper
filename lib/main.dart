import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/historic_portfolios.dart';
import './screens/history/history_screen.dart';
import './screens/stocks/add_stock_screen.dart';
import './providers/api_requests.dart';
import './providers/portfolios.dart';
import './screens/portfolios/portfolio_screen.dart';
import './screens/stocks/stocks_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Portfolios(),
        ),
        ChangeNotifierProvider(
          create: (_) => ApiRequests(),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoricPortfolios(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 80, 80, 80),
          accentColor: Colors.white,
          canvasColor: Colors.black,
          appBarTheme: AppBarTheme(
            color: Color.fromARGB(255, 43, 43, 42),
            shadowColor: Colors.grey,
            elevation: 5.0,
          ),
          fontFamily: 'Lato',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline1: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                headline2: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
                headline3: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                headline4: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                bodyText1: TextStyle(color: Colors.white, fontSize: 15),
                bodyText2: TextStyle(
                    color: Color.fromARGB(255, 210, 210, 210), fontSize: 18),
              ),
        ),
        home: PortfolioScreen(),
        routes: {
          PortfolioScreen.routeName: (_) => PortfolioScreen(),
          StocksOverviewScreen.routeName: (_) => StocksOverviewScreen(),
          AddStockScreen.routeName: (_) => AddStockScreen(),
          HistoryScreen.routeName: (_) => HistoryScreen(),
        },
      ),
    );
  }
}
