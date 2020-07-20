import 'package:blockify_medical/business-objects/user.dart';
import 'package:blockify_medical/controls/inheritedTabController.dart';
import 'package:blockify_medical/screens/home-medicalrecords.dart';
import 'package:blockify_medical/screens/home-notifs.dart';
import 'package:blockify_medical/screens/home-overview.dart';
import 'package:flutter/material.dart';

import 'home-profile.dart';
import 'home-settings.dart';

class HomeScreen extends StatefulWidget {
  static final String route = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int index = 0;
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 5);
    tabController.addListener(listener);
  }

  @override
  void dispose() {
    tabController.removeListener(listener);
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User args = ModalRoute.of(context).settings.arguments;
    final List<Widget> pages = <Widget>[
      HomeOverviewWidget(user: args, tabController: tabController),
      HomeNotificationsWidget(),
      HomeMedicalRecordsWidget(),
      HomeProfileWidget(
        user: args,
      ),
      HomeSettingsWidget(),
    ];
    return InheritedTabController(
      controller: tabController,
      child: Scaffold(
        bottomNavigationBar: Theme(
          data: Theme.of(context)
              .copyWith(canvasColor: Theme.of(context).accentColor),
          child: BottomNavigationBar(
            showUnselectedLabels: false,
            type: BottomNavigationBarType.shifting,
            //backgroundColor: parentTheme.accentColor,
            onTap: (i) {
              tabController.animateTo(i);
            },
            currentIndex: index,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                title: Text('Overview'),
                icon: Icon(
                  Icons.home,
                  size: 35,
                ),
              ),
              BottomNavigationBarItem(
                title: Text('Notifications'),
                icon: Icon(
                  Icons.add_alert,
                  size: 35,
                ),
              ),
              BottomNavigationBarItem(
                title: Text('Medical Records'),
                icon: Icon(
                  Icons.assignment,
                  size: 35,
                ),
              ),
              BottomNavigationBarItem(
                title: Text('Profile'),
                icon: Icon(
                  Icons.person,
                  size: 35,
                ),
              ),
              BottomNavigationBarItem(
                title: Text('Settings'),
                icon: Icon(
                  Icons.settings,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: pages,
            controller: tabController,
          ),
        ),
      ),
    );
  }

  void listener() {
    setState(() {
      index = tabController.index;
    });
  }
}
