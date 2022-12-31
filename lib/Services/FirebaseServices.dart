import 'package:chatmate/Model/Message.dart';
import 'package:chatmate/Model/Users.dart';
import 'package:chatmate/Utilities/keys.dart';
import 'package:chatmate/Utilities/utils.dart';
import 'package:chatmate/notificationService/localNotificationService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';

class FirebaseServices {
  static User? currentUser;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static Future<bool> getCurrentUser() async {
    try {
      currentUser = _auth.currentUser!;
      DocumentSnapshot doc = await _firestore
          .collection(CollectionKeys.users)
          .doc(currentUser!.uid)
          .get();
      CAUser fieldValue = CAUser.fromJson(doc);
      print('field = ${fieldValue.fcmToken}');
      Box box = Hive.box(BoxKeys.token);
      if (fieldValue.fcmToken != box.get(CacheKeys.fcmToken)!) {
        print("Logged in else where so loggin out here");
        signOut(removeFcmToken: false);
        return false;
      }
      return true;
    } catch (e) {
      print('Error getting Current User = $e');
      return false;
    }
  }

  static Stream<QuerySnapshot> receiveMessage(

      /// When receive api is called, the message is delivered
      String receiverId,
      String receiverName) {
    print('listening');
    return _firestore
        .collection(CollectionKeys.messages)
        .doc(currentUser!.displayName! + currentUser!.uid)
        .collection(receiverName + receiverId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  static sendMessage(
      String message, String receiverId, String receiverName) async {
    await _firestore
        .collection(CollectionKeys.messages)
        .doc(currentUser!.displayName! + currentUser!.uid)
        .collection(receiverName + receiverId)
        .doc()
        .set(Message(
                id: currentUser!.uid + receiverId,
                receiverId: receiverId,
                senderId: currentUser!.uid,
                text: message,
                type: 'text',
                timestamp: Timestamp.now())
            .toMap());
    await _firestore
        .collection(CollectionKeys.messages)
        .doc(receiverName + receiverId)
        .collection(currentUser!.displayName! + currentUser!.uid)
        .doc()
        .set(Message(
                id: currentUser!.uid + receiverId,
                receiverId: receiverId,
                senderId: currentUser!.uid,
                text: message,
                type: 'text',
                timestamp: Timestamp.now())
            .toMap());
  }

  static Future<User?> signInWithGoogle() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    print('google signin instantiated');
    GoogleSignInAccount? signInAccount = await googleSignIn.signIn();
    print('wait for user');
    GoogleSignInAuthentication signInAuthentication =
        await signInAccount!.authentication;
    print('clicked?');
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: signInAuthentication.accessToken,
        idToken: signInAuthentication.idToken);
    print('credential taken = ${credential.token}');
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    User? user = userCredential.user!;
    return user;
  }

  static Future<bool> isUserRegistered(User user) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(CollectionKeys.users)
        .where('email', isEqualTo: user.email)
        .get();
    final List<DocumentSnapshot> docs = querySnapshot.docs;
    if (docs.length == 0) {
      return true;
    } else {
      updateUserToken(
          token: await LocalNotificationService
              .getDeviceTokenToSendNotification());
      return false;
    }
  }

  static registerUser(User user) async {
    String deviceTokenToSendPushNotification =
        await LocalNotificationService.getDeviceTokenToSendNotification();
    Box box = Hive.box(BoxKeys.token);
    box.put(CacheKeys.fcmToken, deviceTokenToSendPushNotification);

    CAUser caUser = CAUser(
        uid: user.uid,
        name: user.displayName!,
        email: user.email!,
        profilePhoto: user.photoURL,
        username: Utils.getUsername(user.email!),
        fcmToken: deviceTokenToSendPushNotification);
    FirebaseFirestore.instance
        .collection(CollectionKeys.users)
        .doc(user.uid)
        .set(caUser.toMap());
  }

  static updateUserToken({token = ''}) {
    _firestore
        .collection(CollectionKeys.users)
        .doc(currentUser!.uid)
        .update({'fcmToken': token});
  }

  static Future<void> signOut({bool removeFcmToken = true}) async {
    if (removeFcmToken) updateUserToken();
    currentUser = null;
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    return await _auth.signOut();
  }

  static Future<List<CAUser>> fetchAllUsers(User currentUser) async {
    List<CAUser> userList = [];
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(CollectionKeys.users).get();
    for (DocumentSnapshot x in querySnapshot.docs) {
      if (x.id != currentUser.uid) {
        userList.add(CAUser.fromJson(x));
      }
    }
    return userList;
  }

  static Future<List<Users>> getUsersBySearch(name) async {
    print("Reading Users...");
    List<Users> newUsersList = [];
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection(CollectionKeys.users)
        .where("name", isEqualTo: name)
        .get();
    List<DocumentSnapshot> documents = result.docs;
    documents.forEach((DocumentSnapshot doc) {
      Users searchedUsers = Users.fromJson(doc);
      newUsersList.add(searchedUsers);
      print(searchedUsers.name);
    });
    return newUsersList;
  }

  static Future<String> uploadUserInfo(Users users) async {
    final docUser =
        FirebaseFirestore.instance.collection(CollectionKeys.users).doc();
    await docUser.set(users.toJson());
    return docUser.id;
  }
}
