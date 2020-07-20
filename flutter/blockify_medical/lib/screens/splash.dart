import 'dart:async';
import 'dart:convert';

import 'package:blockify_medical/api-providers/login-register-provider.dart';
import 'package:blockify_medical/business-objects/user.dart';
import 'package:blockify_medical/controls/logo.dart';
import 'package:blockify_medical/screens/landing-no-login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class SplashScreen extends StatefulWidget {
  static final String route = '/';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      sharedPreferences = sp;
      var userInfoString = sp.getString('userInfo');
      if (sp.containsKey('baseUrl')) {
        AuthProvider.baseUrl = sp.getString('baseUrl');
      }

      Timer(Duration(seconds: 2), () {
        if (userInfoString == null) {
          Navigator.pushReplacementNamed(context, LandingNoLogin.route);
        } else {
          var user = User.fromResponseJsonMap(jsonDecode(userInfoString));
          Navigator.pushReplacementNamed(context, HomeScreen.route,
              arguments: user);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          child: LogoWidget(),
          tag: "logo",
        ),
      ),
    );
  }
}
