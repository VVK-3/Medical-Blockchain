import 'package:blockify_medical/business-objects/user.dart';
import 'package:blockify_medical/controls/button.dart';
import 'package:flutter/material.dart';

class HomeProfileWidget extends StatelessWidget {
  final User user;

  const HomeProfileWidget({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData parentTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: parentTheme.accentColor),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: <Widget>[
          Hero(
            tag: 'profilePic',
            child: FractionallySizedBox(
              widthFactor: 0.4,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    width: constraints.maxWidth,
                    height: constraints.maxWidth,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                            'assets/images/home-screen-profile-pic.jpg'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          _ProfileDataText(
            text: "${user.name}\n${user.id}",
          ),
          _ProfileDataText(
            text: user.email,
          ),
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.7,
              child: Divider(
                thickness: 2,
              ),
            ),
          ),
          /*_ProfileDataText(
            text: 'Are you a doctor ?',
            textColor: parentTheme.accentColor,
          ),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Image.asset(
                'assets/images/doctor-using-virtual-application.jpg'),
          ),
          FractionallySizedBox(
            widthFactor: 0.5,
            child: QButtton(
              text: 'Get a doctor account',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return _UploadDoctorInfoAlertDialog();
                    });
              },
            ),
          )*/
        ],
      ),
    );
  }
}

class _UploadDoctorInfoAlertDialog extends StatelessWidget {
  const _UploadDoctorInfoAlertDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Please Upload file or photo for your "Doctors Syndicate ID',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: QButtton(
              text: 'Upload Documents',
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                showDialog(
                    context: context,
                    builder: (context) {
                      return _ConfirmDoctorUploadAlertDialog();
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmDoctorUploadAlertDialog extends StatelessWidget {
  const _ConfirmDoctorUploadAlertDialog({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Your account has been confirmed to be a doctor account !',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          QButtton(
            text: 'Ok',
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }
}

class _ProfileDataText extends StatelessWidget {
  final String text;
  final Color textColor;
  const _ProfileDataText({Key key, this.text, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }
}
