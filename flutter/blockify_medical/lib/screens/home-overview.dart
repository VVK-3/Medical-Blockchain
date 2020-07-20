import 'package:blockify_medical/business-objects/user.dart';
import 'package:blockify_medical/controls/inheritedTabController.dart';
import 'package:blockify_medical/screens/all.dart';
import 'package:flutter/material.dart';

class HomeOverviewWidget extends StatelessWidget {
  final TabController tabController;
  final User user;
  const HomeOverviewWidget({this.user, Key key, @required this.tabController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ThemeData parentTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Overview',
          style: TextStyle(color: parentTheme.accentColor),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: ListView.separated(
          itemCount: 3,
          padding: EdgeInsets.only(left: 15, right: 15),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                //profile overview
                return _BuildProfileOverview(user: this.user,);
              case 1:
                return _BuildClosestHospitalOverview();
              case 2:
                return _BuildRecentMedicalRecords();
              default:
                return Container();
            }
          },
          separatorBuilder: (context, index) {
            return LayoutBuilder(
              builder: (context, constraint) {
                return Divider(
                  indent: constraint.maxWidth / 6,
                  endIndent: constraint.maxWidth / 6,
                  color: Color.fromARGB(255, 0x70, 0x70, 0x70),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _BuildRecentMedicalRecords extends StatelessWidget {
  const _BuildRecentMedicalRecords({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        InheritedTabController.of(context).animateTo(2);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            child: Image.asset('assets/images/Home-Screen-Medical-record.jpg'),
            borderRadius: BorderRadius.circular(20),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Your Latest Medical Record',
              style: TextStyle(
                color: Color.fromARGB(255, 0x70, 0x70, 0x70),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildClosestHospitalOverview extends StatelessWidget {
  const _BuildClosestHospitalOverview({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //first lookup nearest hospital using google places api
        Navigator.of(context).pushNamed(MapScreen.route);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            child: Image.asset('assets/images/Home-Screen-Map.jpg'),
            borderRadius: BorderRadius.circular(20),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Closest Hospital :',
              style: TextStyle(
                color: Color.fromARGB(255, 0x70, 0x70, 0x70),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Dar-Elfoad - 7m From Here',
              style: TextStyle(
                color: Color.fromARGB(255, 0x70, 0x70, 0x70),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildProfileOverview extends StatelessWidget {
  final User user;
  const _BuildProfileOverview({
    this.user,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        InheritedTabController.of(context).animateTo(3);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: 'profilePic',
            child: CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/home-screen-profile-pic.jpg'),
              minRadius: 35,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  user.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Id : ${user.id}'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
