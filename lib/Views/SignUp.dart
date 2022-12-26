import 'dart:io';

import 'package:chatmate/Model/Users.dart';
import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/Views/SignIn.dart';
import 'package:chatmate/Views/home.dart';
import 'package:chatmate/Widgets/Decorations.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool noProfile = true, _isHidden = true, flag = false;
  var _image;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController numberController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController retypePasswordController = new TextEditingController();
  RoundedLoadingButtonController _roundedLoadingButtonController =
      new RoundedLoadingButtonController();
  afterThen(value) {
    _roundedLoadingButtonController.success();
    Future.delayed(Duration(seconds: 2))
        .then((value) => _roundedLoadingButtonController.reset());
  }

  onErrors(error, stackTrace) {
    print("Error= " + error);
    _roundedLoadingButtonController.error();
    Future.delayed(Duration(seconds: 2))
        .then((value) => _roundedLoadingButtonController.reset());
    //Display toast
  }

  Future signUp() async {
    //FirebaseUser user;
    //AuthResult result;
    final formState = _formKey.currentState;
    var results = await Connectivity().checkConnectivity();
    if (formState!.validate()) {
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
        try {
          Users users = new Users(
              name: usernameController.text,
              number: numberController.text,
              password: passwordController.text,
              email: emailController.text,
              profilePicture: '',
              uId: '');
          await Future.wait([
            FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text),
            FirebaseServices.uploadUserInfo(users)
          ]).then((value) {
            print("Then");
            afterThen(value);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => Home()));
          }).onError((error, stackTrace) {
            print("Error");
            onErrors(error, stackTrace);
          });
          //return user;
        } catch (e) {
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
    } else {
      _roundedLoadingButtonController.reset();
      print("Form invalid");
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  Future getImagefromCamera() async {
    // ignore: invalid_use_of_visible_for_testing_member
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }

  Future getImagefromGallery() async {
    // ignore: invalid_use_of_visible_for_testing_member
    var image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: SizedBox(
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.pink.shade900,
                    child: ClipOval(
                        child: SizedBox(
                            width: 113,
                            height: 113,
                            child: (_image != null)
                                ? Image.file(
                                    _image,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    FontAwesomeIcons.user,
                                    size: 70,
                                    color: Colors.white,
                                  ))),
                  ),
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 6,
                          backgroundColor: Colors
                              .transparent, //File(_imageFileList![index].path)
                          child: _image != null
                              ? Image.file(
                                  _image,
                                  fit: BoxFit.fill,
                                )
                              : Image.asset("Assets/noprofilepic.png"),
                        ),
                        // SpeedDial(
                        //   backgroundColor: Colors.purple,
                        //   activeBackgroundColor: Colors.purpleAccent,
                        //   //animatedIcon: AnimatedIcons.add_event,
                        //   //animatedIconTheme: IconThemeData(size: 22.0),
                        //   child: Icon(Icons.add,size: 25,),
                        //   activeChild: Icon(Icons.close),
                        //   //icon: Icons.add,
                        //   //activeIcon: Icons.close,
                        //   spacing: 3,
                        //   childPadding: EdgeInsets.all(5),
                        //   tooltip: 'Add',
                        //   heroTag: 'Add',
                        //   useRotationAnimation: true,
                        //   //elevation: 8.0,
                        //   isOpenOnStart: false,
                        //   animationSpeed: 200,
                        //   renderOverlay: true,
                        //   overlayColor: Colors.black,
                        //   overlayOpacity: 0.5,
                        //   children: [
                        //     SpeedDialChild(
                        //         child: Icon(Icons.cases),
                        //         backgroundColor: Colors.deepPurple,
                        //         foregroundColor: Colors.white,
                        //         label: 'Gallery',
                        //         onTap: () {
                        //           setState(() {
                        //             getImagefromGallery();
                        //             //_selectedIndex=4;
                        //           });
                        //         }
                        //     ),
                        //     SpeedDialChild(
                        //         child: Icon(Icons.event),
                        //         backgroundColor: Colors.deepPurple,
                        //         foregroundColor: Colors.white,
                        //         label: 'Camera',
                        //         onTap: () {
                        //           setState(() {
                        //             getImagefromCamera();
                        //             //_selectedIndex=4;
                        //           });
                        //         }
                        //     ),
                        //   ],
                        // ),
                        CircleAvatar(
                            radius: MediaQuery.of(context).size.width / 18,
                            backgroundColor: ThemeColors.secondaryColor,
                            child: IconButton(
                              icon: Icon(Icons.camera_alt),
                              color: Colors.white,
                              onPressed: () {
                                getImagefromGallery();
                              },
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      keyboardType: TextInputType.name,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      validator: (input) {
                        if (input!.isEmpty) {
                          return "Kindly enter Display name";
                        }
                        return null;
                      },
                      controller: usernameController,
                      style: TextStyle(color: Colors.white),
                      decoration: Decorations.textBoxDecorations(
                          context, "Display name", "")),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      keyboardType: TextInputType.phone,
                      controller: numberController,
                      validator: (input) {
                        String pattern =
                            "([+]{1}[0-9]{2}[3]{1}|[0]{1}[3]{1})[0-9]{9}";
                        RegExp regExp = new RegExp(pattern);
                        if (input!.length == 0) {
                          return 'Please enter mobile number';
                        } else if (!regExp.hasMatch(input)) {
                          return 'INVALID! Number format: +(2 digit country code) OR 03';
                        }
                        return null;
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: Decorations.textBoxDecorations(
                          context, "Number", "")),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (input) {
                        //String pattern = "^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})\$";
                        //RegExp regExp = new RegExp(pattern);
                        if (input!.isEmpty) {
                          return "Kindly enter Email";
                        } else if (!input.contains("@")) {
                          return "Wrong Email format";
                        } else if (!input.contains(".")) {
                          return "Wrong Email format";
                        }
                        return null;
                      },
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: Decorations.textBoxDecorations(
                          context, "Email", "abc@gmail.com")),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    validator: (input) {
                      if (input!.length < 6) {
                        print("Your password must have at least 6 characters");
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
                                color: ThemeColors.secondaryColor, size: 18),
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
                      focusedErrorBorder: Decorations.textBoxBorders(context),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: retypePasswordController,
                    validator: (input) {
                      if (input != passwordController.text) {
                        return "Your password does not match!";
                      } else {
                        return null;
                      }
                    },
                    obscureText: _isHidden,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Re-enter Password",
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
                      focusedErrorBorder: Decorations.textBoxBorders(context),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RoundedLoadingButton(
                    borderRadius: 10,
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "R E G I S T E R",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: ThemeColors.secondaryColor),
                          ),
                        )),
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    color: ThemeColors.primaryColor,
                    successColor: ThemeColors.secondaryColor,
                    errorColor: Colors.red,
                    onPressed: () {
                      print("Pressed");
                      signUp();
                    },
                    controller: _roundedLoadingButtonController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width / 3,
                          color: ThemeColors.secondaryColor,
                        ),
                      ),
                      Text(
                        "   O R   ",
                        style: TextStyle(color: ThemeColors.secondaryColor),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          width: MediaQuery.of(context).size.width / 3,
                          color: ThemeColors.secondaryColor,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                          minimumSize:
                              Size(MediaQuery.of(context).size.width / 2, 50)),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => SignIn()));
                      },
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                              child: Text(
                            "L O G I N",
                            style: TextStyle(color: ThemeColors.primaryColor),
                          )))),
                ],
              ),
            )),
      ),
    );
  }
}
