import 'register-user.dart';

abstract class RegisterDoctorRequestBase extends RegisterUserRequestBase {
  final String represents;

  RegisterDoctorRequestBase(
      {this.represents,
      String name,
      String email,
      String nationalId,
      String password,
      String passwordConfirm,
      String address,
      String city,
      String zipCode,
      String phone})
      : super(
          name: name,
          email: email,
          nationalId: nationalId,
          password: password,
          passwordConfirm: passwordConfirm,
          address: address,
          city: city,
          zipCode: zipCode,
          phone: phone,
        );

  @override
  Map<String, dynamic> toJsonMap() {
    var res = super.toJsonMap();
    res['represents'] = represents;
    return res;
  }
}

class RegisterIndependantDoctorRequest extends RegisterDoctorRequestBase {
  RegisterIndependantDoctorRequest(
      {String name,
      String email,
      String nationalId,
      String password,
      String passwordConfirm,
      String address,
      String city,
      String zipCode,
      String phone})
      : super(
          represents: 'doctor',
          name: name,
          email: email,
          nationalId: nationalId,
          password: password,
          passwordConfirm: passwordConfirm,
          address: address,
          city: city,
          zipCode: zipCode,
          phone: phone,
        );
}

class RegisterInstitutionDoctorRequest extends RegisterDoctorRequestBase {
  final String institutionName;
  final String institutionNumber;

  RegisterInstitutionDoctorRequest(
      {this.institutionName,
      this.institutionNumber,
      String name,
      String email,
      String nationalId,
      String password,
      String passwordConfirm,
      String address,
      String city,
      String zipCode,
      String phone})
      : super(
          represents: 'inistitution',
          name: name,
          email: email,
          nationalId: nationalId,
          password: password,
          passwordConfirm: passwordConfirm,
          address: address,
          city: city,
          zipCode: zipCode,
          phone: phone,
        );

  @override
  Map<String, dynamic> toJsonMap() {
    var res = super.toJsonMap();
    res['institution_name'] = institutionName;
    res['institution_number'] = institutionNumber;
    return res;
  }
}

