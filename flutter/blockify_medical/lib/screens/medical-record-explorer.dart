import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicalRecordScreen extends StatelessWidget {
  static final String route = '/medical-record';
  final List<String> mockConversation = [
    'Patient had 70 bpm heart rate\nBlood Pressure at 120/80 mmHg\nThe eye movement were normal.',
    'Did anything seem unusual ?',
    'The patient had negligable pain where the surgery took place'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Record Viewer'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                String drName =
                    index % 2 == 0 ? 'Dr. Ahmed Fwela' : 'Dr. Mohammed Ashraf';
                String conv = mockConversation[index % mockConversation.length];
                Color avatarColor =
                    index % 2 == 0 ? Colors.greenAccent : Colors.redAccent;
                return _ConversationMessageWidget(
                    drName: drName, conv: conv, avatarColor: avatarColor);
              },
            ),
          )
        ],
      ),
    );
  }
}

class _ConversationMessageWidget extends StatelessWidget {
  const _ConversationMessageWidget({
    Key key,
    @required this.drName,
    @required this.conv,
    @required this.avatarColor,
  }) : super(key: key);

  final String drName;
  final String conv;
  final Color avatarColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 25,
            backgroundColor: avatarColor,
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: FractionallySizedBox(
                widthFactor: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 3, bottom: 3),
                      child: Text(
                        drName,
                        textScaleFactor: 1.3,
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Material(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          child: Text(
                            conv,
                            style: TextStyle(color: Colors.white),
                            textScaleFactor: 1.2,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(DateFormat('dd-MM-yyyy @ HH:mm').format(DateTime.now()) ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
