import 'package:blockify_medical/business-objects/doctor-info.dart';

/*
{
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZGRyZXNzIjp7ImFkZHJlc3MiOiJkYWthZG9zIHNhYWQgemFnaGxvdWwgc3QiLCJjaXR5IjoiIG1pdCBnaGFtciIsInppcF9jb2RlIjoiMzU2MTEifSwiY3JlYXRlZF9hdCI6IjIwMjAtMDItMTdUMTU6MjA6NTAuNjc0WiIsImVtYWlsIjoiZXNsYW0uZWxoYWttZXkzcGF0QGdtYWlsLmNvbSIsImlkIjoiNWU0YWFmNTJlNmQ2OGQyY2I0ZDlkMGE2IiwibmFtZSI6IkVzbGFtIiwibmF0aW9uYWxfaWQiOiIwMTIzNDU2Nzg5IiwicGhvbmUiOiIwMTAxODIxMTk0NiIsInR5cGUiOiJwYXRpZW50IiwidXBkYXRlZF9hdCI6IjIwMjAtMDItMTdUMTU6MjA6NTAuNjc0WiIsImlhdCI6MTU4MTk4NDM0NywiZXhwIjoxNTgxOTg3OTQ3fQ.9wFoen6RlHYiNJgguHGEXJMLZmzOmgjFS21II03v3wM",
    "user": {
        "address": {
            "address": "dakados saad zaghloul st",
            "city": " mit ghamr",
            "zip_code": "35611"
        },
        "created_at": "2020-02-17T15:20:50.674Z",
        "email": "eslam.elhakmey3pat@gmail.com",
        "id": "5e4aaf52e6d68d2cb4d9d0a6",
        "name": "Eslam",
        "national_id": "0123456789",
        "phone": "01018211946",
        "type": "patient",
        "updated_at": "2020-02-17T15:20:50.674Z"
    }
}
*/
class User {
  final String id;
  final String token;
  final String name;
  final String email;
  final String nationalId;
  final String phone;
  final String type;
  //DateTime birthDate;
  final String profilePicBytes; //base 64 encoded image
  final DoctorInfo doctorInfo;
  final UserAddress address;
  final DateTime createdAt;
  final DateTime lastUpdated;
  User(
      {this.address,
      this.id,
      this.token,
      this.name,
      this.profilePicBytes,
      this.doctorInfo,
      this.createdAt,
      this.lastUpdated,
      this.nationalId,
      this.email,
      this.phone,
      this.type});

  factory User.fromResponseJsonMap(Map<String, dynamic> jsonMap) {
    if (jsonMap.containsKey('token')) {
      //successful
      var token = jsonMap['token'];
      Map<String, dynamic> user = jsonMap['user'];
      var address = user['address'];

      DoctorInfo docInfo;
      if (user.containsKey('institution')) {
        docInfo = DoctorInfo(
            institutionName: user['institution']['name'],
            institutionNumber: user['institution']['number']);
      }
      return User(
          token: token,
          id: user['id'],
          name: user['name'],
          email: user['email'],
          address: UserAddress(
            desc: address['address'],
            city: address['city'],
            zipCode: address['zipCode'],
          ),
          createdAt: DateTime.parse(user['created_at']),
          lastUpdated: DateTime.parse(user['updated_at']),
          phone: user['phone'],
          nationalId: user['national_id'],
          type: user['type'],
          doctorInfo: docInfo);
    } else {
      return null;
    }
  }
}

class UserAddress {
  final String desc;
  final String city;
  final String zipCode;

  UserAddress({this.desc, this.city, this.zipCode});
}
