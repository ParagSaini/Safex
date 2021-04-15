import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safex/constant.dart';
import 'package:safex/models/group_data.dart';

class SideSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/background2.PNG'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, bottom: 15.0, left: 10.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Group Members',
                  textAlign: TextAlign.center,
                  style: kTextFontStyle.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    children: List<Widget>.from(
                        Provider.of<GroupData>(context).getList()),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
