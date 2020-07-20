import 'package:blockify_medical/controls/controls.dart';
import 'package:blockify_medical/screens/all.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeSettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData parentTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(color: parentTheme.accentColor),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: <Widget>[
          InputBaseUrl(),
          QButtton(
            text: 'Sign Out',
            onPressed: () async {
              var sp = await SharedPreferences.getInstance();
              sp.remove('userInfo');
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(SplashScreen.route, (r) => false);
            },
          )
        ],
      ),
    );
  }
}
