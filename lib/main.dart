import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/Utilities/keys.dart';
import 'package:chatmate/Views/SplashScreen.dart';
import 'package:chatmate/notificationService/localNotificationService.dart';
import 'package:chatmate/router/router.dart';
import 'package:chatmate/themes/AppTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print('background handler = ${message.data.toString()}');
  print('background handler title = ${message.notification!.title}');
  LocalNotificationService.createAndDisplayNotificationChannel(message);
  print('background handler called@@@@@@@@@2');
  FirebaseServices.setDeliveredStatus(
      senderId: message.data['senderId'],
      senderName: message.data['senderName'],
      receiverId: message.data['receiverId'],
      receiverName: message.data['receiverName']);
}

_initializeHive() async {
  final appDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter('${appDir.path}/cache');
  await Hive.openBox(BoxKeys.token);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LocalNotificationService.initialize();

  FirebaseApp firebaseApp = await Firebase.initializeApp().whenComplete(() {
    print('completee');
  });
  print('firebase app = ${firebaseApp.name} ${firebaseApp.options.projectId}');
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  _initializeHive();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //exposed properties
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme().loadTheme(true),
      onGenerateRoute: MainRouter.generateRoute,
      darkTheme: AppTheme().loadTheme(true),
      home: SplashScreen(),
    );
  }
}
