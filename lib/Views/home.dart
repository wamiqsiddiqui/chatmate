import 'package:chatmate/Model/Users.dart';
import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/Views/ChatsList.dart';
import 'package:chatmate/Widgets/UserCircle.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatmate/Views/Search.dart';
import 'package:flutter/src/scheduler/ticker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool searchPressed = false, searching = false;
  int selectedTab = 1;
  late TabController tabBarCtrl;
  List<CAUser> userList = [];
  List<CAUser> searchResult = [];

  TextEditingController searchTextEditingController =
      new TextEditingController();
  searchOnPressed() {
    setState(() {
      searchPressed = !searchPressed;
      searching = false;
    });
  }

  onTabChange(int index) {
    selectedTab = index;
    tabBarCtrl.animateTo(index);
    setState(() {});
  }

  List<Tab> tabs = [
    Tab(
        iconMargin: EdgeInsets.zero,
        icon: Icon(Icons.person, color: AppColors.white)),
    Tab(
        /*text: 'Chats',*/ icon: Icon(
      Icons.chat,
      color: AppColors.white,
    )),
    Tab(/*text: 'Calls',*/ icon: Icon(Icons.call, color: AppColors.white)),
    Tab(
        /*text: 'Contacts',*/ icon:
            Icon(Icons.contacts_rounded, color: AppColors.white))
  ];
  @override
  void initState() {
    super.initState();
    tabBarCtrl = TabController(length: 4, vsync: this);
    print('getting user');
    FirebaseServices.fetchAllUsers(FirebaseServices.currentUser!)
        .then((List<CAUser> users) {
      setState(() {
        userList = users;
        searchResult = users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
          length: 4,
          initialIndex: 2,
          child: Scaffold(
            backgroundColor: ThemeColors.primaryColor,
            bottomNavigationBar: TabBar(
                controller: tabBarCtrl,
                indicatorColor: ThemeColors.receiverColor,
                indicatorWeight: 4,
                indicatorPadding: EdgeInsets.symmetric(vertical: 4),
                labelPadding: EdgeInsets.symmetric(horizontal: 28, vertical: 4),
                onTap: onTabChange,
                tabs: tabs),
            appBar: !searchPressed
                ? AppBar(
                    elevation: 0,
                    centerTitle: true,
                    title: UserCircle(),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(Icons.search),
                          color: AppColors.white,
                          onPressed: () {
                            searchOnPressed();
                            //Navigator.pushNamed(context, '/search');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.more_vert, color: AppColors.white),
                      )
                    ],
                    // bottom:
                  )
                : AppBar(
                    leading: IconButton(
                      icon: new Icon(Icons.arrow_back),
                      onPressed: () {
                        searchOnPressed();
                      },
                    ),
                    title: TextField(
                      controller: searchTextEditingController,
                      decoration: InputDecoration(hintText: "Search"),
                      onChanged: (value) {
                        print(value);
                        searchResult = value.isEmpty
                            ? userList
                            : userList.where((CAUser user) {
                                bool matchesUsername = user.username
                                    .toLowerCase()
                                    .contains(value.toLowerCase());
                                bool matchesName = user.name
                                    .toLowerCase()
                                    .contains(value.toLowerCase());
                                return matchesUsername || matchesName;
                              }).toList();
                        setState(() {});
                      },
                      onSubmitted: (input) {
                        // myFuture = FirebaseServices.getUsersBySearch(input)
                        //     .then((value) {
                        //   print("Value= " + value.toString());
                        //   setState(() {
                        //     searching = true;
                        //   });
                        // });
                      },
                    ),
                    actions: <Widget>[
                      new IconButton(
                        icon: new Icon(Icons.close),
                        onPressed: () {
                          searchOnPressed();
                          //widget.onChanged();
                        },
                      ),
                    ],
                  ),
            body: TabBarView(controller: tabBarCtrl, children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                    color: ThemeColors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32))),
                child: Center(child: Text('Personal Chat Room')),
              ),
              !searchPressed ? ChatsList() : Search(searchResult: searchResult),
              Center(
                child: Text('Call Logs'),
              ),
              Center(
                child: Text('Contacts'),
              )
            ]),
          )),
    );
  }
}