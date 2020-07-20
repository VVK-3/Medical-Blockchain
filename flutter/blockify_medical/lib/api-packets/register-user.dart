import 'package:flutter/material.dart';

abstract class RegisterUserRequestBase {
  final String name;
  final String email;
  final String nationalId;
  final String password;
  final String passwordConfirm;
  final String address;
  final String city;
  final String zipCode;
  final String phone;

  RegisterUserRequestBase(
      {this.name,
      this.email,
      this.nationalId,
      this.password,
      this.passwordConfirm,
      this.address,
      this.city,
      this.zipCode,
      this.phone});

  Map<String, dynamic> toJsonMap() => {
        'name': name,
        'email': email,
        'national_id': nationalId,
        'password': password,
        'password_confirmation': passwordConfirm,
        'address': address,
        'city': city,
        'zip_code': zipCode,
        'phone': phone
      };
}

class RegisterUserResponse {
  final RegisterUserRequestBase request;

  final bool success;

  final String passwordHash;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String id;
  final String type;

  RegisterUserResponse._(
      {@required this.request,
      this.passwordHash,
      this.createdAt,
      this.updatedAt,
      this.id,
      this.type,
      this.success});

  factory RegisterUserResponse.fromJsonMap(Map<String, dynamic> jsonMap,
      {@required String type, @required RegisterUserRequestBase request}) {
    if (!jsonMap.containsKey('success') ||
        jsonMap['success'] == false ||
        jsonMap['res']['success'] == false) {
      return RegisterUserResponse._(success: false, request: request);
    }

    var res = jsonMap['res'];
    var typeSpecific = res[type];
    return RegisterUserResponse._(
        request: request,
        success: true,
        id: typeSpecific['id'],
        passwordHash: typeSpecific['password'],
        createdAt: DateTime.parse(typeSpecific['created_at']),
        updatedAt: DateTime.parse(typeSpecific['updated_at']));
  }
}
