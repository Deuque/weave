
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/all.dart';
import 'package:riverpod/riverpod.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  TextEditingController passController,
      emailController,
      nameController,
      usernameController;
  FocusNode enode, nnode, pnode, unode;
  bool isLogin = true;
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String emailOrUsername, email, username, name, password;

  @override
  void initState() {
    super.initState();
    passController = new TextEditingController();
    nameController = new TextEditingController();
    emailController = new TextEditingController();
    usernameController = new TextEditingController();
    enode = new FocusNode();
    nnode = new FocusNode();
    pnode = new FocusNode();
    unode = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    clearFocus() {
      enode.unfocus();
      pnode.unfocus();
      nnode.unfocus();
      unode.unfocus();
    }

    clearFields() {
      emailController.clear();
      passController.clear();
      nameController.clear();
      usernameController.clear();
    }

    // checkForm() async {
    //   if (loading) return;
    //   if (_formKey.currentState.validate()) {
    //     _formKey.currentState.save();
    //
    //     setState(() {
    //       loading = true;
    //     });
    //
    //     ApiResponse response;
    //     if (isLogin) {
    //       FocusScope.of(context).requestFocus(FocusNode());
    //       response = await AuthFunction.login(
    //           emailOrUsername: emailOrUsername.trim(), password: password);
    //     } else {
    //       FocusScope.of(context).requestFocus(FocusNode());
    //       response = await AuthFunction.register(
    //           email: email, name: name, username: username, password: password);
    //     }
    //
    //     setState(() {
    //       loading = false;
    //     });
    //
    //     if (response.success) {
    //       User user = User.fromMap(response.data['user'])
    //         ..token = response.data['token'];
    //       context.read(currentUserProvider).setUser(user);
    //       user.phoneNumberConfirmed
    //           ? Navigator.pushNamed(context, 'dash')
    //           : Navigator.pushNamed(context, 'sendOtp');
    //     } else {
    //       showSnackBar(
    //           key: _scaffoldKey,
    //           message: response.errors.isEmpty
    //               ? response.message
    //               : response.errors[0]['description'] ?? response.message,
    //           type: SnackBarType.error);
    //     }
    //   } else {
    //     showSnackBar(
    //         key: _scaffoldKey,
    //         message: 'Please fill the fields correctly',
    //         type: SnackBarType.error);
    //   }
    // }

    return  GestureDetector(
      onTap: clearFocus,
      child: Scaffold(
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
