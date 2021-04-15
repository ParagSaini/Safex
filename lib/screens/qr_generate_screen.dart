import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:safex/components/my_appbar.dart';
import 'package:safex/constant.dart';

class QrGenerateScreen extends StatelessWidget {
  static const String id = 'qr_generate_screen';

  QrGenerateScreen({@required this.groupId});
  final groupId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/background1.PNG'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              MyAppBar(title: 'Qr Code'),
              SizedBox(
                height: 10.0,
              ),
              Container(
                color: Colors.white24,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Scan the below Qr code to join the group ',
                    style: kTextFontStyle.copyWith(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.7,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: QrImage(
                      backgroundColor: Colors.white,
                      data: groupId,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
