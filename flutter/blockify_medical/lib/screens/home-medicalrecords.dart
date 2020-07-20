import 'package:blockify_medical/screens/all.dart';
import 'package:flutter/material.dart';

class HomeMedicalRecordsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData parentTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medical Records',
          style: TextStyle(color: parentTheme.accentColor),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
          itemBuilder: (context, index) {            
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child:  _MedicalRecordWidget(index: index,),
            );
          },
          itemCount: 20),
    );
  }
}

class _MedicalRecordWidget extends StatelessWidget {
  final int index;

  const _MedicalRecordWidget({Key key, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, MedicalRecordScreen.route);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Visit to Hospital ${index+1}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0x70, 0x70, 0x70),
                  fontSize: 20,
                ),
              ),
              Text(
                'Authed By Dr. Ahmed Fwela, Wed. 5/2/2020 @ 14:12',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(255, 0x70, 0x70, 0x70),
                  fontSize: 16,
                ),
              ),
              Text(
                'Regular checkup after heart sergery',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
