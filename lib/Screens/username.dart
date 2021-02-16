import 'package:flutter/material.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';

class ChooseUsername extends StatefulWidget {
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
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(() {
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

  performSearch(String text) {
    if (text.isEmpty) {
      setState(() {
        checkingUsername = false;
        usernameExists = null;
      });
      return;
    }
    if (checkingUsername) return;

    setState(() {
      checkingUsername = true;
    });
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        checkingUsername = false;
        usernameExists = true;
      });
    });
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
                hint: '@johnDoe',
                controller: usernameController,
                onEditComplete: () => performSearch(usernameController.text),
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
                          : usernameExists
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
              actionButton('CONTINUE', textEntered,
                  () => Navigator.pushNamed(context, 'dash'), context),
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
