import 'package:cloud_firestore/cloud_firestore.dart';

class Users{
  String uId,name,number,profilePicture,email,password;
  Users({required this.uId,required this.name,required this.number,required this.profilePicture,required this.email,required this.password});

  factory Users.fromJson(DocumentSnapshot json)=>Users(
    uId:json['uId'],
    name:json['name'],
    number: json['number'],
    profilePicture: json['profilePicture'],
    email: json['email'],
    password: json['password']
  );

  Map<String,dynamic> toJson()=>{
    'uId':uId,
    'name':name,
    'number':number,
    'profilePicture':profilePicture,
    'email':email,
    'password':password,
  };

}

class CAUser{

  String uid;
  String name;
  String email;
  String username;
  String? status;
  int? state;
  String? profilePhoto;

  CAUser({required this.uid, required this.name,required this.email, this.profilePhoto, this.state, this.status, required this.username});
   factory CAUser.fromJson(Map<String,dynamic> json)=>CAUser(
    uid:json['uid'],
    name:json['name'],
    email: json['email'],
    profilePhoto: json['profilePhoto'],
    username: json['username'],
    state: json['state'],
    status: json['status']
  );

  Map<String,dynamic> toMap()=>{
  'uid':uid,
  'name':name,
  'email':email,
  'username':username,
  'status':status,
  'state':state,
  'profilePhoto':profilePhoto
  };

}