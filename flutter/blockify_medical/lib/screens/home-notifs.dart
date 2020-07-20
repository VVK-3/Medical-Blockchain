import 'package:flutter/material.dart';

class HomeNotificationsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData parentTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(color: parentTheme.accentColor),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => _BuildNotificationWidget(
          index: index,
        ),
      ),
    );
  }
}

class _BuildNotificationWidget extends StatelessWidget {
  final int index;

  const _BuildNotificationWidget({Key key, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(      
      leading: CircleAvatar(
        backgroundImage:
            AssetImage('assets/images/home-screen-profile-pic.jpg'),
      ),
      isThreeLine: false,      
      title: Text('Dr. Jack requested to access your profile.'),
      subtitle: Text('Mon. 8/8/2019 @ 19:00'),
      onTap: () {
        //open Dr. Jack's profile info
      },
    );
  }
}
