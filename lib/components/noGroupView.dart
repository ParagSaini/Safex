import 'package:flutter/material.dart';
import 'package:safex/constant.dart';

class NoGroupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            "You haven't joined any Groups. Create or Join Group by using below buttons.",
            style: kTextFontStyle.copyWith(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Center(
              child: Icon(
                Icons.group_rounded,
                size: 150,
                color: Color(0xFFDBC9B4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
