import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class UserCircle extends StatelessWidget {
  final String? userProfile;
  const UserCircle({Key? key, this.userProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FirebaseServices.signOut();
      },
      child: CircleAvatar(
        backgroundColor: Color.fromARGB(255, 146, 161, 165),
        child: Stack(
          children: [
            userProfile != null
                ? ClipRRect(child: Image.network(userProfile!))
                : Align(
                    alignment: Alignment.center,
                    child: Text(
                      'MW',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
            Align(
                alignment: Alignment.bottomRight,
                child: Badge(
                  borderRadius: BorderRadius.circular(12),
                  badgeColor: AppColors.successGreenColor,
                ))
          ],
        ),
      ),
    );
  }
}
