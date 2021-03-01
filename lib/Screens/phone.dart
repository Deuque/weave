import 'package:flutter/material.dart';
import 'package:weave/Controllers/user_controller.dart';
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
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;

    spacer() =>
        SizedBox(
          height: height * .05,
        );
    spacer2() =>
        SizedBox(
          height: height * .03,
        );

    String stripNumber() {
      String text = phoneController.value.text;
      if(text.length<10){
        showSnackBar(
            key: _scaffoldKey,
            message: 'Enter a valid number',
            type: SnackBarType.warning);
        return '';
      }
      return '+234'+text;
    }

    onDone() async{
      if(stripNumber().isEmpty){
        return;
      }else{
        setState(() {
          loading = true;
        });
        var response = await UserController()
            .saveUserData({'phone': stripNumber()});
        if (response['error'] != null) {
          showSnackBar(
              key: _scaffoldKey,
              message: response['error'],
              type: SnackBarType.error);
        } else {
          Navigator.pop(context);
        }
        setState(() {
          loading = false;
        });
      }
      print(stripNumber());
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: backButton(
            onPressed: () => Navigator.pop(context),
            color: Theme.of(context).secondaryHeaderColor.withOpacity(.8)),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: width * .08, right:width * .08,bottom: width * .15),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'Add a phone number,',
                style: TextStyle(
                    color: Theme
                        .of(context)
                        .secondaryHeaderColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Help your contacts see you',
                style: TextStyle(
                  color: Theme
                      .of(context)
                      .secondaryHeaderColor
                      .withOpacity(.5),
                  fontSize: 14,
                ),
              ),
              spacer(),
              MyTextField(
                label: 'Phone number',
                prefix: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('+234', style: TextStyle(
                          color: Theme
                              .of(context)
                              .secondaryHeaderColor, fontSize: 14),),
                    ],
                  ),
                ),
                hint: '8000000000',
                controller: phoneController,
              ),
              spacer2(),
              actionButton('CONTINUE', textEntered, loading,
                      onDone, context),
            ],
          ),
        ),
      ),
    );
  }
}

