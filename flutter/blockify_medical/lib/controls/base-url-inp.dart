import 'package:blockify_medical/api-providers/login-register-provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputBaseUrl extends StatelessWidget {
  const InputBaseUrl({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: AuthProvider.baseUrl,
      onChanged: (String s) async {
        AuthProvider.baseUrl = s;
        var sp = await SharedPreferences.getInstance();
        sp.setString('baseUrl', s);        
      },
      decoration: InputDecoration(
          prefixText: 'Base URL', contentPadding: EdgeInsets.only(left: 10)),
    );
  }
}
