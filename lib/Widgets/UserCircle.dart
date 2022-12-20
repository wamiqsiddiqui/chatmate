import 'package:chatmate/Services/FirebaseServices.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class UserCircle extends StatelessWidget {
  const UserCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FirebaseServices.signOut();
      },
      child: CircleAvatar(
        // radius: 24,
        backgroundColor: ThemeColors.receiverColor,
        child: Stack(
          children: [
            Align(
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
