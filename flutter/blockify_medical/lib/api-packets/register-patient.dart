import 'register-user.dart';

class RegisterPatientRequest extends RegisterUserRequestBase {
  RegisterPatientRequest(
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
            name: name,
            email: email,
            nationalId: nationalId,
            password: password,
            passwordConfirm: passwordConfirm,
            address: address,
            city: city,
            zipCode: zipCode,
            phone: phone);
}
