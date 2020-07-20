import 'package:blockify_medical/api-packets/login.dart';
import 'package:blockify_medical/api-providers/login-register-provider.dart';
import 'package:blockify_medical/controls/textfield.dart';
import 'package:flutter/material.dart';
import 'package:blockify_medical/controls/controls.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'home.dart';

class SigninScreen extends StatefulWidget {
  static final String route = '/signin';
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: buildBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LogoHero(
                radius: 150,
              ),
              Container(
                height: 5,
              ),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: Column(
                  children: <Widget>[
                    QTextField(
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                    ),
                    QTextField(
                      hintText: 'Password',
                      keyboardType: TextInputType.visiblePassword,
                      obsecureText: true,
                      controller: passwordController,
                    ),
                    LoginButtonWidget(emailController: emailController, passwordController: passwordController)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({
    Key key,
    @required this.emailController,
    @required this.passwordController,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Hero(
        tag: 'login',
        child: QButtton(
          text: 'Login',
          onPressed: () async {
            ProgressDialog pr = ProgressDialog(context,
                type: ProgressDialogType.Normal,
                isDismissible: false);
            await pr.show();
            var user = await AuthProvider.loginUser(
              LoginRequest(
                email: emailController.text,
                password: passwordController.text,
              ),
            );
            await pr.hide();
            if (user == null) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Login Failed'),
                  duration: Duration(seconds: 2)
                ),
              );
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                HomeScreen.route,
                (r) => false,
                arguments: user,
              );
            }
          },
        ),
      ),
    );
  }
}
