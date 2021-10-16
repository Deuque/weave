import 'package:flutter/material.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';
import 'package:weave/Widgets/my_text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailController = new TextEditingController();
  bool textEntered = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      if (emailController.text.isNotEmpty && !textEntered) {
        setState(() {
          textEntered = true;
        });
      }
      if (emailController.text.isEmpty && textEntered) {
        setState(() {
          textEntered = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
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

    onDone() async {
      String text = emailController.value.text;
      if (text.isEmpty) {
        return;
      } else {
        setState(() {
          loading = true;
        });
        await UserController().forgotPassword(text).then((value) {
          showSnackBar(
              key: _scaffoldKey,
              message: 'A password reset mail has been sent',
              type: SnackBarType.success);
          Future.delayed(Duration(milliseconds: 1500), () => Navigator.pop(context));
        }).catchError((e) => showSnackBar(
            key: _scaffoldKey,
            message: e.toString(),
            type: SnackBarType.error));

        setState(() {
          loading = false;
        });
      }
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
            left: width * .08, right: width * .08, bottom: width * .15),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'Reset Password,',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Enter the email address of your account',
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.5),
                  fontSize: 14,
                ),
              ),
              spacer(),
              MyTextField(
                label: 'Email Address',
                hint: '',
                controller: emailController,
              ),
              spacer2(),
              actionButton('CONTINUE', textEntered, loading, onDone, context),
            ],
          ),
        ),
      ),
    );
  }
}
