import 'package:chatmate/Model/Message.dart';
import 'package:chatmate/Model/Users.dart';
import 'package:chatmate/Model/contacts.dart';
import 'package:chatmate/Utilities/keys.dart';
import 'package:chatmate/Utilities/utils.dart';
import 'package:chatmate/notificationService/localNotificationService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/adapters.dart';

class FirebaseServices {
  static User? currentUser;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static Future<bool> getCurrentUser() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      currentUser = _auth.currentUser!;
      DocumentSnapshot doc = await _firestore
          .collection(CollectionKeys.users)
          .doc(currentUser!.uid)
          .get();
      CAUser fieldValue = CAUser.fromJson(doc);
      print('field = ${fieldValue.fcmToken}');
      Box box = Hive.box(BoxKeys.token);
      // print('box.keys = ${box.keys}');
      // print('box.get(CacheKeys.fcmToken) = ${box.get(CacheKeys.fcmToken)}');
      if (fieldValue.fcmToken != box.get(CacheKeys.fcmToken)) {
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

  static Future<CAUser?> getUserDetailsById(String id) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection(CollectionKeys.users).doc(id).get();
      return CAUser.fromJson(documentSnapshot);
    } catch (e) {
      print('Error getting user details by id = $e');
      return null;
    }
  }

  static addToContacts(
      {required String senderId, required String receiverId}) async {
    Timestamp currentTime = Timestamp.now();
    await addToSendersContact(senderId, receiverId, currentTime);
    await addToReceiversContact(senderId, receiverId, currentTime);
  }

  static Stream<QuerySnapshot> fetchContacts({required String userId}) =>
      _firestore
          .collection(CollectionKeys.users)
          .doc(userId)
          .collection(CollectionKeys.contacts)
          .snapshots();

  static Stream<QuerySnapshot> fetchLastMessageBetween(
      {required String senderId,
      required String receiverId,
      required String receiverName}) {
    var x = _firestore
        .collection(CollectionKeys.messages)
        .doc(currentUser!.displayName! + senderId)
        .collection(receiverName + receiverId)
        .orderBy('timestamp')
        .snapshots();
    setDeliveredStatus(
        senderId: senderId,
        senderName: currentUser!.displayName!,
        receiverId: receiverId,
        receiverName: receiverName);
    return x;
  }

  static setDeliveredStatus(
      {required String senderId,
      required String senderName,
      required String receiverId,
      required String receiverName}) async {
    print('${senderName} + ${senderId}=====>${receiverName + receiverId}');
    // print('');
    await Firebase.initializeApp();
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection(CollectionKeys.messages)
        .doc(senderName + senderId)
        .collection(receiverName + receiverId)
        .where('status', isEqualTo: describeEnum(MessageStatus.sent))
        .get();
    print('setDeliveredStatus query.docs = ${query.docs.length}');
    query.docs.forEach((doc) async {
      await doc.reference
          .update({'status': describeEnum(MessageStatus.delivered)});
    });
  }

  static DocumentReference getContactsDocument(
          {required String of, required String forContact}) =>
      _firestore
          .collection(CollectionKeys.users)
          .doc(of)
          .collection(CollectionKeys.contacts)
          .doc(forContact);

  static Future<void> addToSendersContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot senderSnapshot =
        await getContactsDocument(of: senderId, forContact: receiverId).get();

    if (!senderSnapshot.exists) {
      Contact receiverContact = Contact(uid: receiverId, addedOn: currentTime);
      await getContactsDocument(of: senderId, forContact: receiverId)
          .set(Contact.toMap(receiverContact));
    }
  }

  static Future<void> addToReceiversContact(
      String senderId, String receiverId, currentTime) async {
    DocumentSnapshot receiverSnapshot =
        await getContactsDocument(of: receiverId, forContact: senderId).get();

    if (!receiverSnapshot.exists) {
      Contact senderContact = Contact(uid: senderId, addedOn: currentTime);
      await getContactsDocument(of: receiverId, forContact: senderId)
          .set(Contact.toMap(senderContact));
    }
  }

  static Stream<QuerySnapshot> receiveMessage(

      /// When receive api is called, the message is delivered
      String receiverId,
      String receiverName) {
    print('listening');
    setDeliveredStatus(
        senderId: currentUser!.uid,
        senderName: currentUser!.displayName!,
        receiverId: receiverId,
        receiverName: receiverName);
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
                status: describeEnum(MessageStatus.sent),
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
                status: describeEnum(MessageStatus.received),
                timestamp: Timestamp.now())
            .toMap());
    print(
        'FieldValue.serverTimestamp() = ${FieldValue.serverTimestamp().toString()}');
    await addToContacts(senderId: currentUser!.uid, receiverId: receiverId);
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
    final FirebaseAuth _auth = FirebaseAuth.instance;
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
    final FirebaseAuth _auth = FirebaseAuth.instance;
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
