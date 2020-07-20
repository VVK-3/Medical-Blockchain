import 'package:blockify_medical/controls/button.dart';
import 'package:blockify_medical/controls/controls.dart';
import 'package:blockify_medical/controls/logo.dart';
import 'package:blockify_medical/screens/signin.dart';
import 'package:blockify_medical/screens/signup.dart';
import 'package:flutter/material.dart';

class LandingNoLogin extends StatelessWidget {
  static final String route = '/landing-no-login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/landing-no-login-bg.jpg'),
              fit: BoxFit.fitHeight,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop)),
        ),
        child: Center(
          child: ListView(
            children: <Widget>[
              Container(
                height: 50,
              ),
              Center(child: LogoHero()),
              Container(
                height: 50,
              ),
              FractionallySizedBox(
                child: InputBaseUrl(),
                widthFactor: 0.7,
              ),
              Container(
                height: 50,
              ),
              Container(
                height: 48,
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Hero(
                    tag: 'signup',
                    child: QButtton(
                      text: 'Signup',
                      onPressed: () {
                        Navigator.pushNamed(context, SignupScreen.route);
                      },
                    ),
                  ),
                ),
              ),
              Container(
                height: 1,
              ),
              Container(
                height: 48,
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Hero(
                    tag: 'login',
                    child: QButtton(
                      text: 'Login',
                      onPressed: () {
                        Navigator.pushNamed(context, SigninScreen.route);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
