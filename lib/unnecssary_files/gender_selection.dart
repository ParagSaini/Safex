import 'package:flutter/material.dart';
import 'package:safex/constant.dart';

class GenderSelection extends StatefulWidget {
  GenderSelection({this.getGender});
  final Function getGender;
  @override
  _GenderSelectionState createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  int group = 1;
  void onChanged(dynamic val) {
    group = val;
    widget.getGender(group);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.drive_file_rename_outline,
              size: 30.0,
              color: Color(0xFFDBC9B4),
            ),
            SizedBox(
              width: 25,
            ),
            Text(
              '*Gender',
              style: kTextFontStyle.copyWith(
                fontSize: 20.0,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Options(
              val: 1,
              title: 'Male',
              group: group,
              onChanged: onChanged,
            ),
            Options(
              val: 2,
              title: 'Female',
              group: group,
              onChanged: onChanged,
            ),
            Options(
              val: 3,
              title: 'Other',
              group: group,
              onChanged: onChanged,
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}

class Options extends StatelessWidget {
  Options({this.val, @required this.title, this.group, this.onChanged});
  final val, title, group;
  final Function onChanged;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio(
          activeColor: Color(0xFFDBC9B4),
          value: val,
          groupValue: group,
          onChanged: onChanged,
        ),
        Text(
          title,
          style: kTextFontStyle.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}
