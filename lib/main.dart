import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_helper/providers/stocks.dart';
import 'package:stock_helper/screens/add_stock_screen.dart';
import 'package:stock_helper/screens/stocks_overview_screen.dart';

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
          create: (_) => Stocks(),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Color.fromARGB(255, 43, 43, 42),
              accentColor: Colors.white,
              canvasColor: Colors.black,
              fontFamily: 'Lato',
              textTheme: ThemeData
                  .light()
                  .textTheme
                  .copyWith(
                  headline1: TextStyle(//for the ticker
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  headline2: TextStyle(//for the name
                      fontSize: 18,
                      color: Colors.grey),
                  headline3: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                  headline4: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                  bodyText1: TextStyle(color: Colors.white, fontSize: 15))),
      home: StocksOverviewScreen(),
      routes: {
        AddStockScreen.routeName: (_) => AddStockScreen(),
      },
    ),);
  }
}
