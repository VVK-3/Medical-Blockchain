import 'package:blockify_medical/api-packets/login.dart';
import 'package:blockify_medical/api-packets/register-doctor.dart';
import 'package:blockify_medical/api-packets/register-patient.dart';
import 'package:blockify_medical/api-packets/register-user.dart';
import 'package:blockify_medical/api-providers/login-register-provider.dart';
import 'package:blockify_medical/controls/controls.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'home.dart';

class SignupScreen extends StatefulWidget {
  static final String route = '/signup';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static final format = DateFormat("yyyy-MM-dd");

  Country _selectedCountry;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();

  final TextEditingController instNameController = TextEditingController();
  final TextEditingController instPhoneController = TextEditingController();

  List<bool> buttonStates = [true, false];
  List<bool> doctorStates = [true, false];
  @override
  Widget build(BuildContext context) {
    List<Widget> doctorWidgets;
    List<Widget> doctorTypeWidgets;
    if (buttonStates[1]) {
      //build doctor widgets
      doctorTypeWidgets = [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleButtons(
              onPressed: (index) {
                setState(() {
                  for (int indexBtn = 0;
                      indexBtn < doctorStates.length;
                      indexBtn++) {
                    doctorStates[indexBtn] = indexBtn == index;
                  }
                });
              },
              isSelected: doctorStates,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Independant'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Working'),
                )
              ],
            ),
          ),
        ),
      ];

      if (doctorStates[1]) {
        doctorWidgets = [
          FractionallySizedBox(
              widthFactor: 0.8,
              child: QTextField(
                hintText: 'Institution Name',
                keyboardType: TextInputType.text,
                controller: instNameController,
              )),
          FractionallySizedBox(
              widthFactor: 0.8,
              child: QTextField(                
                hintText: 'Institution Phone',
                keyboardType: TextInputType.phone,
                controller: instPhoneController,
              )),
        ];
      }
    }

    var fieldsChildren = <Widget>[
      Center(
        child: LogoHero(
          radius: 150,
        ),
      ),
      Container(
        height: 5,
      ),
      Center(
        child: ToggleButtons(
          onPressed: (index) {
            setState(() {
              for (int indexBtn = 0;
                  indexBtn < buttonStates.length;
                  indexBtn++) {
                buttonStates[indexBtn] = indexBtn == index;
              }
            });
          },
          isSelected: buttonStates,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Patient'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Doctor'),
            )
          ],
        ),
      ),
      ...?doctorTypeWidgets,
      FractionallySizedBox(
        widthFactor: 0.8,
        child: QTextField(
          hintText: 'Full Name',
          keyboardType: TextInputType.text,
          controller: nameController,
        ),
      ),
      FractionallySizedBox(
        widthFactor: 0.8,
        child: QTextField(
          hintText: 'National ID',
          keyboardType: TextInputType.number,
          controller: nationalIdController,
        ),
      ),
      FractionallySizedBox(
          widthFactor: 0.8,
          child: QTextField(
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
          )),
      FractionallySizedBox(
          widthFactor: 0.8,
          child: QTextField(
            hintText: 'Phone Number',
            keyboardType: TextInputType.phone,
            controller: phoneController,
          )),
      FractionallySizedBox(
          widthFactor: 0.8,
          child: QTextField(
            hintText: 'Password',
            keyboardType: TextInputType.visiblePassword,
            obsecureText: true,
            controller: passwordController,
          )),
      FractionallySizedBox(
          widthFactor: 0.8,
          child: QTextField(
            hintText: 'Confirm Password',
            keyboardType: TextInputType.visiblePassword,
            obsecureText: true,
            controller: confirmPasswordController,
          )),
      FractionallySizedBox(
          widthFactor: 0.8,
          child: QTextField(
            hintText: 'Address',
            keyboardType: TextInputType.text,
            controller: addressController,
          )),
      FractionallySizedBox(
          widthFactor: 0.8,
          child: QTextField(
            hintText: 'City',
            keyboardType: TextInputType.text,
            controller: cityController,
          )),
      FractionallySizedBox(
          widthFactor: 0.8,
          child: QTextField(
            hintText: 'Zip Code',
            keyboardType: TextInputType.number,
            controller: zipCodeController,
          )),
      ...?doctorWidgets,
      /*DateTimeField(
                              format: format,
                              textAlign: TextAlign.center,
                              decoration:
                                  InputDecoration(hintText: 'Birth Date'),
                              onShowPicker: (context, time) async {
                                return showDatePicker(
                                    context: context,
                                    initialDate: time ?? DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));
                              },
                            ),*/
      /*Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CountryPicker(
                                onChanged: (Country country) {
                                  setState(() {
                                    _selectedCountry = country;
                                  });
                                },
                                selectedCountry: _selectedCountry ?? Country.EG,
                              ),
                            ),*/
      SignUpButtonWidget(buttonStates: buttonStates, nameController: nameController, addressController: addressController, cityController: cityController, nationalIdController: nationalIdController, confirmPasswordController: confirmPasswordController, phoneController: phoneController, zipCodeController: zipCodeController, emailController: emailController, passwordController: passwordController, doctorStates: doctorStates, instNameController: instNameController, instPhoneController: instPhoneController)
    ];

    return Scaffold(
      body: Container(
        decoration: buildBoxDecoration(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(children: fieldsChildren),
          ),
        ),
      ),
    );
  }
}

class SignUpButtonWidget extends StatelessWidget {
  const SignUpButtonWidget({
    Key key,
    @required this.buttonStates,
    @required this.nameController,
    @required this.addressController,
    @required this.cityController,
    @required this.nationalIdController,
    @required this.confirmPasswordController,
    @required this.phoneController,
    @required this.zipCodeController,
    @required this.emailController,
    @required this.passwordController,
    @required this.doctorStates,
    @required this.instNameController,
    @required this.instPhoneController,
  }) : super(key: key);

  final List<bool> buttonStates;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController nationalIdController;
  final TextEditingController confirmPasswordController;
  final TextEditingController phoneController;
  final TextEditingController zipCodeController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final List<bool> doctorStates;
  final TextEditingController instNameController;
  final TextEditingController instPhoneController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Hero(
        tag: 'signup',
        child: QButtton(
          text: 'Submit',
          onPressed: () async {
            ProgressDialog pr = ProgressDialog(context,
                type: ProgressDialogType.Normal, isDismissible: false);
            await pr.show();
            RegisterUserRequestBase req;
            if (buttonStates[0]) {
              //patient
              req = RegisterPatientRequest(
                name: nameController.text,
                address: addressController.text,
                city: cityController.text,
                nationalId: nationalIdController.text,
                passwordConfirm: confirmPasswordController.text,
                phone: phoneController.text,
                zipCode: zipCodeController.text,
                email: emailController.text,
                password: passwordController.text,
              );
            } else {
              //doctor
              if (doctorStates[0]) {
                //indep
                req = RegisterIndependantDoctorRequest(
                  name: nameController.text,
                  address: addressController.text,
                  city: cityController.text,
                  nationalId: nationalIdController.text,
                  passwordConfirm: confirmPasswordController.text,
                  phone: phoneController.text,
                  zipCode: zipCodeController.text,
                  email: emailController.text,
                  password: passwordController.text,
                );
              } else {
                //working
                req = RegisterInstitutionDoctorRequest(
                  name: nameController.text,
                  address: addressController.text,
                  city: cityController.text,
                  nationalId: nationalIdController.text,
                  passwordConfirm: confirmPasswordController.text,
                  phone: phoneController.text,
                  zipCode: zipCodeController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  institutionName: instNameController.text,
                  institutionNumber: instPhoneController.text,
                );
              }
            }
            var user = await AuthProvider.registerUser(req);
            await pr.hide();
            if (user == null) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Register Failed'),
                  duration: Duration(seconds: 2),
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
