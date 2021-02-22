import 'package:flutter/material.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';

class AddPhone extends StatefulWidget {
  @override
  _AddPhoneState createState() => _AddPhoneState();
}

class _AddPhoneState extends State<AddPhone> {
  bool loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController phoneController = new TextEditingController();
  bool textEntered = false;
  bool checkingUsername = false;
  bool usernameExists;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(() {
      if (phoneController.text.isNotEmpty && !textEntered) {
        setState(() {
          textEntered = true;
        });
      }
      if (phoneController.text.isEmpty && textEntered) {
        setState(() {
          textEntered = false;
        });
      }
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    spacer() => SizedBox(
          height: height * .05,
        );
    spacer2() => SizedBox(
          height: height * .03,
        );

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * .08, vertical: width * .15),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'Add a phone number,',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Help your contacts see you',
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.5),
                  fontSize: 14,
                ),
              ),
              spacer(),
              MyTextField(
                label: 'Phone number',
                hint: '',
                controller: phoneController,
              ),
              spacer2(),
              actionButton('CONTINUE', textEntered,
                  ()=>Navigator.pop(context), context),
            ],
          ),
        ),
      ),
    );
  }
}

