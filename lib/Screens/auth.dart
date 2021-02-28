import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/all.dart';
import 'package:riverpod/riverpod.dart';
import 'package:weave/Controllers/user_controller.dart';
import 'package:weave/Controllers/current_user_controller.dart';
import 'package:weave/Models/user.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  TextEditingController passController, emailController;
  FocusNode enode, pnode;
  bool isLogin = true;
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String email, password;

  @override
  void initState() {
    super.initState();
    passController = new TextEditingController();
    emailController = new TextEditingController();
    enode = new FocusNode();
    pnode = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    clearFocus() {
      enode.unfocus();
      pnode.unfocus();
    }

    clearFields() {
      emailController.clear();
      passController.clear();
    }

    checkForm() async {
      if (loading) return;
      email = emailController.value.text;
      password = passController.value.text;
      if (email.isNotEmpty && password.isNotEmpty) {

        setState(() {
          loading = true;
        });

       Map<String,dynamic> response = {};


        if (isLogin) {
          // FocusScope.of(context).requestFocus(FocusNode());
          // response = await AuthFunction.login(
          //     emailOrUsername: emailOrUsername.trim(), password: password);
          response = await UserController().loginUser(
              email: email, password: password);
        } else {

          response = await UserController().registerUser(
              email: email, password: password);

          if(response['error']==null){
            response = await UserController().saveUserData({'email': email});
          }
        }



        if (response['error']==null) {
          User user = await context.read(userProvider).getInitialUserData();

          if(user.username.isEmpty){
            Navigator.pushReplacementNamed(context, 'username');
          }else{
            context.read(userProvider).startCurrentUserStream();
            Navigator.pushReplacementNamed(context, 'dash');
          }

        } else {
          showSnackBar(
              key: _scaffoldKey,
              message: response['error'],
              type: SnackBarType.error);
        }

        setState(() {
          loading = false;
        });

      } else {
        showSnackBar(
            key: _scaffoldKey,
            message: 'Please fill the fields correctly',
            type: SnackBarType.warning);
      }
    }

    spacer() => SizedBox(
          height: height * .05,
        );
    spacer2() => SizedBox(
          height: height * .03,
        );
    Widget actionButton(String label, bool active, bool loading, Function onClick) =>
        Expanded(
          flex: active ? 3 : 2,
          child: GestureDetector(
            onTap: onClick,
            child: Container(
              decoration: BoxDecoration(
                  color: active ? primary : lightGrey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    if (active)
                      BoxShadow(
                          offset: Offset(0, 3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          color: Theme.of(context).backgroundColor)
                  ]),
              padding: EdgeInsets.all(20),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                        color: active ? white.withOpacity(.8) : lightGrey,
                        fontSize: 13),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  if (active)
                    loading ? SizedBox(height:15,width: 15,child: CircularProgressIndicator(strokeWidth: 1.5,valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(.8)),)):
                    Icon(
                      Icons.chevron_right_outlined,
                      color: Colors.white.withOpacity(.8),
                      size: 16,
                    )
                ],
              ),
            ),
          ),
        );
    return GestureDetector(
      onTap: clearFocus,
      child: Scaffold(
        key: _scaffoldKey,
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * .08, vertical: width * .15),
          child: Form(
            key: _formKey,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    'Hello there,',
                    style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  spacer(),
                  MyTextField(
                    label: 'Email',
                    hint: 'johnDoe@gmail.com',
                    controller: emailController,
                  ),
                  spacer2(),
                  MyTextField(
                    label: 'Password',
                    hint: '........',
                    isPassword: true,
                    controller: passController,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot password',
                        style: TextStyle(
                            color: Theme.of(context)
                                .secondaryHeaderColor
                                .withOpacity(.7),
                            fontSize: 15),
                      ),
                    ),
                  ),
                  spacer2(),
                  Row(
                    children: [
                      actionButton(
                        'LOGIN',
                        isLogin,
                        loading,
                        () {
                          if (!isLogin) {
                            setState(() {
                              isLogin = true;
                            });
                          } else {
                            checkForm();
                          }
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      actionButton(
                        'REGISTER',
                        !isLogin,
                        loading,
                        () {
                          if (isLogin)
                            setState(() {
                              isLogin = false;
                            });
                          else
                            checkForm();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
