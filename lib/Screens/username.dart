import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';
import 'package:weave/Widgets/my_text_field.dart';

class ChooseUsername extends StatefulWidget {
  final String username;

  const ChooseUsername({Key key, this.username}) : super(key: key);
  @override
  _ChooseUsernameState createState() => _ChooseUsernameState();
}

class _ChooseUsernameState extends State<ChooseUsername> {
  bool loading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController usernameController = new TextEditingController();
  bool textEntered = false;
  bool checkingUsername = false;
  bool usernameExists;
  String username = '';

  @override
  void initState() {
    super.initState();
    usernameController.text=widget.username??'';
    usernameController.addListener(() {
      if (usernameController.text != username && usernameExists != null)
        setState(() {
          usernameExists = null;
        });

      if (usernameController.text.isNotEmpty && !textEntered) {
        setState(() {
          textEntered = true;
        });
      }
      if (usernameController.text.isEmpty && textEntered) {
        setState(() {
          textEntered = false;
        });
      }
    });
  }

  String stripUsername() {
    String text = usernameController.value.text;
    ['!', '@', '#', '\$', '%', '^', '&', '*', '(', ')', '+', '=', '-']
        .forEach((element) {
      text = text.replaceAll(element, '');
    });
    return text;
  }

  performSearch() async {
    if(widget.username!=null && widget.username==stripUsername()){
      showSnackBar(
          key: _scaffoldKey,
          message: 'This is your current username',
          type: SnackBarType.warning);
      return;
    }
    setState(() {
      checkingUsername = true;
    });
    String text = stripUsername();
    usernameExists = await UserController().checkUsername(text);
    username = text;
    if (!usernameExists) {
      showSnackBar(
          key: _scaffoldKey,
          message: '$text is available',
          type: SnackBarType.success);
    }

    setState(() {
      checkingUsername = false;
    });
  }

  onDone() async {
    if (usernameExists == null) {
      performSearch();
    } else if (usernameExists) {
      showSnackBar(
          key: _scaffoldKey,
          message: 'Username is already taken',
          type: SnackBarType.warning);
    } else {
      setState(() {
        loading = true;
      });
      var response =
          await UserController().saveUserData({'username': username});
      if (response['error'] != null) {
        showSnackBar(
            key: _scaffoldKey,
            message: response['error'],
            type: SnackBarType.error);
      } else {
        widget.username!=null? Navigator.pop(context):Navigator.pushNamed(context, 'dash');
      }
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    usernameController.dispose();
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
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: backButton(
            onPressed: () => Navigator.pop(context),
            color: Theme.of(context).secondaryHeaderColor.withOpacity(.8)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * .08, vertical: width * .15),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                'Choose a username,',
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'With this your friends can easily find you,',
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.5),
                  fontSize: 14,
                ),
              ),
              spacer(),
              MyTextField(
                label: 'Username',
                hint: 'johnDoe',
                controller: usernameController,
                onEditComplete: () => performSearch(),
                prefix: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/email.png',
                      height: 14,color: Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                    ),
                  ],
                ),
                suffix: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: checkingUsername
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        )
                      : usernameExists == null
                          ? SizedBox(
                              height: 0,
                            )
                          : !usernameExists
                              ? Image.asset(
                                  'assets/images/check.png',
                                  color: success,
                                  height: 15,
                                )
                              : Text(
                                  'Already taken',
                                  style: TextStyle(fontSize: 13, color: error),
                                ),
                ),
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

// class MyTextFormField extends StatefulWidget {
//   @required
//   String label;
//   @required
//   TextEditingController controller;
//   @required
//   FocusNode focusNode;
//   @required
//   TextInputType inputType;
//   @required
//   Function validator, onSave;
//   bool obsureText;
//   Widget prefix;
//
//   MyTextFormField(
//       {this.label,
//       this.controller,
//       this.focusNode,
//       this.inputType,
//       this.obsureText = false,
//       this.prefix,
//       this.validator,
//       this.onSave});
//
//   @override
//   _MyTextFormFieldState createState() => _MyTextFormFieldState();
// }
//
// class _MyTextFormFieldState extends State<MyTextFormField> {
//   String validateText = '';
//
//   //for passwords only
//   bool obscureText;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//
//     super.initState();
//     obscureText = widget.obsureText;
//     widget.controller.addListener(() {
//       if (mounted) {
//         String text = widget.controller.text;
//         if (text.isNotEmpty) {
//           String returnedText = widget.validator(text.trim());
//           if (validateText != returnedText)
//             setState(() {
//               validateText = returnedText;
//             });
//         } else {
//           if (validateText.isNotEmpty)
//             setState(() {
//               validateText = '';
//             });
//         }
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     InputBorder myBorder = UnderlineInputBorder(
//         borderSide: BorderSide(
//             width: .5,
//             color: Theme.of(context).secondaryHeaderColor.withOpacity(.6)));
//     return TextFormField(
//       focusNode: widget.focusNode,
//       keyboardType: widget.inputType,
//       style: TextStyle(
//         fontSize: 16,
//         color: Theme.of(context).secondaryHeaderColor.withOpacity(.9),
//       ),
//       controller: widget.controller,
//       obscureText: obscureText,
//       validator: (String val) => validateText == 'good' ? null : '',
//       onSaved: widget.onSave,
//       decoration: InputDecoration(
//           border: myBorder,
//           enabledBorder: myBorder,
//           disabledBorder: myBorder,
//           // suffixIcon: Icon(
//           //   Icons.check_circle,
//           // ),
//           errorStyle: TextStyle(fontSize: 1),
//           errorBorder: myBorder,
//           errorMaxLines: 1,
//           prefix: widget.prefix,
//           suffix: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Visibility(
//                   visible: widget.obsureText,
//                   child: InkWell(
//                     onTap: () => setState(() => obscureText = !obscureText),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8.0, vertical: 3),
//                       child: Icon(
//                         obscureText ? Icons.visibility : Icons.visibility_off,
//                         size: 15,
//                         color: Theme.of(context)
//                             .secondaryHeaderColor
//                             .withOpacity(.4),
//                       ),
//                     ),
//                   )),
//               SizedBox(
//                 width: 5,
//               ),
//               (validateText == 'good' && widget.controller.text.isNotEmpty)
//                   ? Icon(
//                       Icons.check_circle,
//                       color: Colors.cyan,
//                       size: 22,
//                     )
//                   : widget.controller.text.isEmpty
//                       ? SizedBox(
//                           height: 0,
//                         )
//                       : Text(
//                           validateText,
//                           style: TextStyle(color: accentColor, fontSize: 13),
//                         )
//             ],
//           ),
//           labelText: widget.label,
//           labelStyle: TextStyle(
//             fontSize: 17,
//             color: Theme.of(context).secondaryHeaderColor.withOpacity(.5),
//           )),
//     );
//   }
// }
