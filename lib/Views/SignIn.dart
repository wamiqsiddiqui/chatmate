import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/Views/home.dart';
import 'package:chatmate/Widgets/Decorations.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isHidden = true, flag = false;
  late String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future signIn() async {
    final _formState = _formKey.currentState;
    var results = await Connectivity().checkConnectivity();

    if (results == ConnectivityResult.none) {
      print("Connectivity None");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Connectivity Issue!"),
              content: Text("No Internet"),
              actions: <Widget>[
                TextButton(
                  child: Text("Try Again!"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    } else {
      setState(() {
        flag = true;
      });
      try {
        print('before logg in');
        User? user = await FirebaseServices.signInWithGoogle();
        print('after');
        if (user != null) {
          FirebaseServices.currentUser = user;
          bool isNewUser = await FirebaseServices.authenticateUser(user);
          print('lll');
          if (isNewUser) {
            print('new user = ${user.email}');
            await FirebaseServices.addUserToDb(user);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => Home()));
          } else {
            print('existing user = ${user.email}');
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => Home()));
          }
        }
        // UserCredential userCredential = await FirebaseAuth.instance
        //     .signInWithEmailAndPassword(email: _email, password: _password);
        // print(userCredential);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ChatRoom()));
        // //return user;
      } /*on FirebaseAuthException*/ catch (e) {
        setState(() {
          flag = false;
        });
        print("This is error: $e");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error!"),
                //An internal error has occurred. [ 7: ]
                content: e == "The email address is badly formatted."
                    ? Text("Remove extra space(s) after your email")
                    : e == "An internal error has occurred. [ 7: ]"
                        ? Text("No Internet")
                        : Text("Invalid email or password"),
                actions: <Widget>[
                  TextButton(
                    child: Text("Try Again!"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        print(e);
      }
    }
  }

  /**
   * decoration: BoxDecoration(
                color: ThemeColors.receiverColor,
                borderRadius: BorderRadius.only(topRight: Radius.circular(200),topLeft: Radius.circular(200))
              ),
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primaryColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
              child: FittedBox(
                child: Text(
                  "C H A T  M A T E",
                  style: TextStyle(
                      //fontSize: 45,
                      color: ThemeColors.secondaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: ThemeColors.receiverColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(52),
                      topLeft: Radius.circular(52))),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 15),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        onSaved: (input) => _email = input!,
                        validator: (input) {
                          if (input!.contains("@")) {
                            return null;
                          } else {
                            return "Invalid Email format";
                          }
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: Decorations.textBoxDecorations(
                            context, "Username", "wamiq123"),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        onSaved: (input) => _password = input!,
                        validator: (input) {
                          if (input!.length < 6) {
                            print(
                                "Your password must have at least 6 characters");
                            return "Your password must have at least 6 characters";
                          } else {
                            return null;
                          }
                        },
                        obscureText: _isHidden,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            child: _isHidden
                                ? Icon(Icons.visibility,
                                    color: ThemeColors.secondaryColor, size: 18)
                                : Icon(Icons.visibility_off,
                                    color: ThemeColors.secondaryColor,
                                    size: 18),
                            onTap: _togglePasswordView,
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ThemeColors.secondaryColor,
                          ),
                          hintText: "6 characters at least",
                          hintStyle: TextStyle(color: Colors.white54),
                          focusedBorder: Decorations.textBoxBorders(context),
                          enabledBorder: Decorations.textBoxBorders(context),
                          errorBorder: Decorations.textBoxBorders(context),
                          disabledBorder: Decorations.textBoxBorders(context),
                          focusedErrorBorder:
                              Decorations.textBoxBorders(context),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              /*RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red)
                              ),*/
                              /*MaterialStateProperty.all<RoundedRectangleBorder>(

                          ),*/
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              primary: ThemeColors.primaryColor,
                              onPrimary: Colors.pink,
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width / 2, 50)),
                          onPressed: () {
                            signIn();
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                  child: Text(
                                "L O G I N",
                                style: TextStyle(
                                    color: ThemeColors.secondaryColor),
                              )))),
                      SizedBox(height: 20),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                        child: FittedBox(
                          child: Text(
                            "Don't have an account?",
                            style: TextStyle(color: ThemeColors.secondaryColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              /*RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red)
                              ),*/
                              /*MaterialStateProperty.all<RoundedRectangleBorder>(

                          ),*/
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              primary: ThemeColors.primaryColor,
                              onPrimary: Colors.pink,
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width / 2, 50)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Home()));
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                  child: Text(
                                "R E G I S T E R",
                                style: TextStyle(
                                    color: ThemeColors.secondaryColor),
                              )))),
                      Visibility(
                        visible: flag,
                        child: Column(
                          children: <Widget>[
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
