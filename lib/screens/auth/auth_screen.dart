import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_helper/providers/auth.dart';
import 'package:stock_helper/providers/portfolios.dart';
import 'package:stock_helper/widgets/auth/auth_card.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  var _isLoading = true;
  var _isInit = true;

  @override
  void initState() {
    super.initState();
    if(_isInit) {
      Provider.of<Auth>(context, listen: false).quickSignIn().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
    }

  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: _isLoading ? Center(child: CircularProgressIndicator(),) :Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.5),
                  Colors.grey.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            color: Colors.white.withOpacity(0.2),
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Stockity',
                        style: TextStyle(
                          color:
                              Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
