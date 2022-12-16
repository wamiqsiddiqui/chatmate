import 'package:chatmate/Model/Users.dart';
import 'package:chatmate/Utilities/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices{

  static User? getCurrentUser(){
  final FirebaseAuth? _auth = FirebaseAuth.instance;
    // User? currentUser = _auth?.currentUser;
    return _auth?.currentUser;
  }

  static Future<User?> signInWithGoogle()async{
    GoogleSignIn googleSignIn = GoogleSignIn();
    print('google signin instantiated');
    GoogleSignInAccount? signInAccount = await googleSignIn.signIn();
    print('wait for user');
    GoogleSignInAuthentication signInAuthentication = await signInAccount!.authentication;
    print('clicked?');
    final AuthCredential credential = GoogleAuthProvider.credential(accessToken: signInAuthentication.accessToken,idToken: signInAuthentication.idToken);
  print('credential taken = ${credential.token}');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserCredential userCredential = await _auth.signInWithCredential(credential);
  User? user = userCredential.user!;
  return user;
  }

  static Future<bool> authenticateUser(User user) async{
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where('email',isEqualTo: user.email).get();
    final List<DocumentSnapshot> docs = querySnapshot.docs;
    return docs.length == 0? true : false;
  }

  static addUserToDb(User user)async{
    CAUser caUser= CAUser(uid: user.uid, name: user.displayName!, email: user.email!, profilePhoto: user.photoURL,username: Utils.getUsername(user.email!));
    FirebaseFirestore.instance.collection('users').doc(user.uid).set(caUser.toMap());
  }

  static Future<void> signOut() async{
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  final FirebaseAuth _auth = FirebaseAuth.instance;
    return await _auth.signOut();
  }
  static Future<List<Users>> getUsersBySearch(name) async {
    print("Reading Users...");
    List<Users> newUsersList=[];
    QuerySnapshot result = await FirebaseFirestore.instance.collection("Users").where("name",isEqualTo: name).get();
    List<DocumentSnapshot>documents = result.docs;
    documents.forEach((DocumentSnapshot doc) {
      Users searchedUsers=Users.fromJson(doc);
      newUsersList.add(searchedUsers);
      print(searchedUsers.name);
    });
    return newUsersList;
  }
  static Future<String> uploadUserInfo(Users users) async{
    final docUser = FirebaseFirestore.instance.collection("Users").doc();
    await docUser.set(users.toJson());
    return docUser.id;
  }
}