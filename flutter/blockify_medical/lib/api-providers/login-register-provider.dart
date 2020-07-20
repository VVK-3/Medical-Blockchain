import 'dart:convert';

import 'package:blockify_medical/api-packets/login.dart';
import 'package:blockify_medical/api-packets/register-doctor.dart';
import 'package:blockify_medical/api-packets/register-patient.dart';
import 'package:blockify_medical/api-packets/register-user.dart';
import 'package:blockify_medical/business-objects/user.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  static String baseUrl = 'http://192.168.1.100:8081';

  static Future<User> registerUser(RegisterUserRequestBase request) async {
    String reqUrl;
    String type;
    if (request is RegisterDoctorRequestBase) {
      reqUrl = '/register-doctor';
      type = 'doctor';
    } else {
      reqUrl = '/register';
      type = 'patient';
    }
    try {
      Response<Map<String, dynamic>> jsonRes = await Dio().post(
        reqUrl,
        data: request.toJsonMap(),
        options: RequestOptions(
            baseUrl: baseUrl,
            contentType: Headers.formUrlEncodedContentType,
            receiveTimeout: 4000),
      );

      if (jsonRes.statusCode >= 200 && jsonRes.statusCode < 300) {
        var registerResult = RegisterUserResponse.fromJsonMap(jsonRes.data,
            type: type, request: request);
        return registerResult.success
            ? await loginUser(
                LoginRequest(email: request.email, password: request.password))
            : null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<User> loginUser(LoginRequest request) async {
    final String reqUrl = '/login';

    try {
      Response<Map<String, dynamic>> jsonRes = await Dio().post(
        reqUrl,
        data: request.toJsonMap(),
        options: RequestOptions(
            baseUrl: baseUrl,
            contentType: Headers.formUrlEncodedContentType,
            receiveTimeout: 4000),
      );
      if (jsonRes.statusCode >= 200 && jsonRes.statusCode < 300) {
        var user = User.fromResponseJsonMap(jsonRes.data);
        var sp = await SharedPreferences.getInstance();
        sp.setString('userInfo', jsonEncode(jsonRes.data));
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
