import 'package:chatmate/Model/Users.dart';
import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/Views/ChatsList.dart';
import 'package:chatmate/Views/calls/pickupCalls/pickupLayout.dart';
import 'package:chatmate/Widgets/UserCircle.dart';
import 'package:chatmate/notificationService/localNotificationService.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:chatmate/Views/Search.dart';

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
    tabBarCtrl = TabController(length: 4, vsync: this, initialIndex: 1);

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      //When app is in termination state and notification comes, and user clicks on that, then this
      // method is called waking app from termination state
      if (message != null) {
        print('NEw Notification');
        LocalNotificationService.createAndDisplayNotificationChannel(message);
        FirebaseServices.setDeliveredStatus(
            senderId: message.data['senderId'],
            senderName: message.data['senderName'],
            receiverId: message.data['receiverId'],
            receiverName: message.data['receiverName']);
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        LocalNotificationService.createAndDisplayNotificationChannel(message);
        // FirebaseServices.setDeliveredStatus(
        //     senderId: message.data['senderId'],
        //     receiverId: message.data['receiverId'],
        //     receiverName: message.data['receiverName']);
        FirebaseServices.setDeliveredStatus(
            senderId: message.data['senderId'],
            senderName: message.data['senderName'],
            receiverId: message.data['receiverId'],
            receiverName: message.data['receiverName']);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('FirebaseMessaging.onMessageOpenedApp.listen');
      if (message.notification != null) {
        print('message.notification!.title = ${message.notification!.title}');
        print('message.notification!.body = ${message.notification!.body}');
        print("message.data = ${message.data['_id']}");
        LocalNotificationService.createAndDisplayNotificationChannel(message);
        FirebaseServices.setDeliveredStatus(
            senderId: message.data['senderId'],
            senderName: message.data['senderName'],
            receiverId: message.data['receiverId'],
            receiverName: message.data['receiverName']);
      }
    });
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
      child: PickupLayout(
        scaffoldChild: DefaultTabController(
            length: 4,
            initialIndex: 2,
            child: Scaffold(
              bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blue,
                        ThemeColors.primaryColor,
                      ],
                    ),
                  ),
                  child: TabBar(
                      controller: tabBarCtrl,
                      indicatorColor: ThemeColors.receiverColor,
                      indicatorWeight: 4,
                      indicatorPadding: EdgeInsets.symmetric(vertical: 4),
                      labelPadding:
                          EdgeInsets.symmetric(horizontal: 28, vertical: 4),
                      onTap: onTabChange,
                      tabs: tabs)),
              appBar: !searchPressed
                  ? PreferredSize(
                      preferredSize: Size(double.infinity, kToolbarHeight + 8),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ThemeColors.primaryColor,
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                ThemeColors.primaryColor,
                                Colors.blue.shade600,
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(0))),
                        child: AppBar(
                          elevation: 0,
                          centerTitle: true,
                          backgroundColor: AppColors.transparent,
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
                              child:
                                  Icon(Icons.more_vert, color: AppColors.white),
                            )
                          ],
                          // bottom:
                        ),
                      ),
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
                !searchPressed
                    ? ChatsList()
                    : Search(searchResult: searchResult),
                Center(
                  child: Text('Call Logs'),
                ),
                Center(
                  child: Text('Contacts'),
                )
              ]),
            )),
      ),
    );
  }
}
