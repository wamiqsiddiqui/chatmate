import 'package:chatmate/Widgets/shareLocation.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:flutter/material.dart';

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key? key}) : super(key: key);

  @override
  State<AnimatedDialog> createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog> {
  double animatedRadius = 0;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      decoration: BoxDecoration(
          color: AppColors.bgGrey,
          borderRadius: BorderRadius.circular(animatedRadius)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Wrap(children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              print('pressed');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((BuildContext context) => ShareLocation())));
            },
            child: Icon(Icons.location_on),
          ),
          CircleAvatar(
            backgroundColor: AppColors.errorColor,
            child: Icon(Icons.camera),
          ),
          CircleAvatar(
            backgroundColor: AppColors.successGreenColor,
            child: Icon(Icons.file_copy),
          ),
          CircleAvatar(
            backgroundColor: AppColors.successGreenColor,
            child: Icon(Icons.person),
          ),
          CircleAvatar(
            backgroundColor: AppColors.successGreenColor,
            child: Icon(Icons.audio_file),
          ),
          CircleAvatar(
            backgroundColor: AppColors.successGreenColor,
            child: Icon(Icons.image),
          )
        ]),
      ),
    );
  }
}
