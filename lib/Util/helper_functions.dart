// import 'package:flipp/Screens/Dashboard/welcome.dart';
// import 'package:flipp/Screens/Funds/bank_transfer_details.dart';
// import 'package:flipp/Screens/Funds/fund_wallet_options.dart';
// import 'package:flipp/Screens/Funds/payment_options.dart';
// import 'package:flutter/material.dart';
//

import 'package:flutter/material.dart';
import 'package:weave/Util/colors.dart';

//custom logo
Widget logo({double size, double spacing}) {
  return Text.rich(TextSpan(
      children: [
        TextSpan(
            text: 'Wea',
            style: TextStyle(
              color: primary,
            )),
        TextSpan(
            text: 've',
            style: TextStyle(
              color: accentColor,
            ))
      ],
      style: TextStyle(
          letterSpacing: spacing ?? 3,
          fontWeight: FontWeight.bold,
          fontSize: size)));
}

// custom field identifier
Widget customFieldIdentifier(
        {@required child, @required label, @required BuildContext context}) =>
    Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor.withOpacity(.1),
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.only(top: 8),
          child: child,
        ),
        Positioned(
            top: 0,
            left: 4,
            child: Material(
              color: primary,
              borderRadius: BorderRadius.circular(8),
              child: Material(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(.9),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 11.0),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      color: primary,
                    ),
                  ),
                ),
              ),
            ))
      ],
    );

// custom textfield
class MyTextField extends StatefulWidget {
  final String label, hint;
  final ValueChanged<String> onSaved;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isPassword;
  final Widget prefix,suffix;
  final Function onEditComplete;

  const MyTextField(
      {Key key,
      this.label,
      this.hint,
      this.onSaved,
      this.controller,
      this.focusNode,
      this.onEditComplete,
      this.isPassword = false,
      this.suffix = const SizedBox(
        height: 0,
      ),
      this.prefix = const SizedBox(
        height: 0,
      )})
      : super(key: key);

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<MyTextField> {
  bool obscureText = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return customFieldIdentifier(
        child: TextFormField(
          controller: widget.controller,
          obscureText: obscureText,
          onEditingComplete: widget.onEditComplete,
          style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor, fontSize: 14),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(20),
              border: InputBorder.none,
              prefixIcon: widget.prefix,
              suffixIcon: widget.isPassword
                  ? InkWell(
                      onTap: () => setState(() {
                        obscureText = !obscureText;
                      }),
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                          size: 14,
                        ),
                      ),
                    )
                  : widget.suffix,
              hintStyle: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.5),
                  fontSize: 14),
              hintText: widget.hint),
        ),
        label: widget.label,
        context: context);
  }
}

// custom button
Widget actionButton(String label, bool active, bool loading, Function onClick, context) =>
    GestureDetector(
      onTap: active?onClick:(){},
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
    );

Widget gameTypeWidget({int type, double size, context}) => Row(
  crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          type == 1
              ? 'assets/images/anagram.png'
              : 'assets/images/tictactoe.png',
          height: size,
          width: size,
        ),
        SizedBox(
          width: 4,
        ),
        Text(
          type == 1 ? 'Anagram' : 'Tic-Tac-Toe',
          style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor.withOpacity(.6),
              fontWeight: FontWeight.w100,
              fontSize: size),
        )
      ],
    );

Widget emptyWidget({String image, size}) {
  return Center(
    child: Image.asset(
      image,
      height: size,
      color: lightGrey.withOpacity(.2),
    ),
  );
}

Widget backButton({Function onPressed, Color color})=>IconButton(
  icon: Image.asset('assets/images/back.png',height: 15,color: color,),
  onPressed: onPressed,
);

enum SnackBarType {
  error,success,warning
}
void showSnackBar({@required GlobalKey<ScaffoldState> key,@required SnackBarType type, @required String message, String action, Function onAction}) {
  final snackBar = SnackBar(
    content: Text(message,style: TextStyle(color: Colors.white.withOpacity(.78))),
    backgroundColor: type==SnackBarType.error?Colors.red:type==SnackBarType.success?Colors.green:Colors.orangeAccent,
    behavior: SnackBarBehavior.fixed,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
    elevation: 1.6,
    duration: const Duration(seconds: 3),
    action: action==null?null:SnackBarAction(
        label: action,
        textColor: Colors.white,
        onPressed: onAction),
  );

  key.currentState.showSnackBar(snackBar);
}