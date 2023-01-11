import 'package:chatmate/Views/Search.dart';
import 'package:chatmate/themes/AppColors.dart';
import 'package:flutter/material.dart';

class QuietBox extends StatelessWidget {
  const QuietBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          color: AppColors.dividerGrey,
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'This is where all the contacts are listed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Search for your friends and family to start calling or chatting with them',
                  textAlign: TextAlign.center,
                  style: TextStyle(letterSpacing: 1.2, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Search(searchResult: [])));
                },
                child: Text('Start searching...'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
