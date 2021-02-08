// import 'package:flipp/Screens/Dashboard/welcome.dart';
// import 'package:flipp/Screens/Funds/bank_transfer_details.dart';
// import 'package:flipp/Screens/Funds/fund_wallet_options.dart';
// import 'package:flipp/Screens/Funds/payment_options.dart';
// import 'package:flutter/material.dart';
//

import 'package:flutter/material.dart';
import 'package:weave/Util/colors.dart';

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
          letterSpacing: spacing,
          fontWeight: FontWeight.bold,
          fontSize: size)));
}

class MyTextField extends StatefulWidget {
  final String label, hint;
  final ValueChanged<String> onSaved;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isPassword;
  final Widget suffix;
  final Function onEditComplete;

  const MyTextField(
      {Key key,
      this.label,
      this.hint,
      this.onSaved,
      this.controller,
      this.focusNode,
        this.onEditComplete,
      this.isPassword = false,this.suffix=const SizedBox(height: 0,)})
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
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor.withOpacity(.1),
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.only(top: 8),
          child: TextFormField(
            controller: widget.controller,
            obscureText: obscureText,
            onEditingComplete: widget.onEditComplete,
            style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor, fontSize: 14),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                border: InputBorder.none,
                suffixIcon: widget.isPassword
                    ? InkWell(
                        onTap: () => setState(() {
                          obscureText = !obscureText;
                        }),
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 14,
                          ),
                        ),
                      )
                    : widget.suffix,
                hintStyle: TextStyle(
                    color:
                        Theme.of(context).secondaryHeaderColor.withOpacity(.8),
                    fontSize: 14),
                hintText: widget.hint),
          ),
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
                    widget.label,
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
  }
}

// void showWelcome(context){
//   showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(15))
//       ),
//       builder: (builder){
//         return Welcome();
//       }
//   ).then((value){
//     if(value!=null && value) showFundWalletOptions(context);
//   });
// }
// void showFundWalletOptions(context){
//   showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(15))
//       ),
//       builder: (builder){
//         return FundWalletOptions();
//       }
//   ).then((value){
//     if(value!=null && value=='bank') showBankTransferDetails(context);
//
//   });
// }
// void showPaymentOptions(context){
//   showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(15))
//       ),
//       builder: (builder){
//         return PaymentOptions();
//       }
//   ).then((value){
//
//   });
// }
// void showBankTransferDetails(context){
//   showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(15))
//       ),
//       builder: (builder){
//         return BankTransferDetails();
//       }
//   ).then((value){
//     if(value!=null && value=='back') showFundWalletOptions(context);
//
//   });
// }
//
// String formatAmount(String num) {
//   num = num.replaceAll(',', '');
//   String newNum = '';
//   if (num.length < 4) return num;
//   if (num.length > 6) {
//     num = num.substring(0, 6);
//   }
//   int backCount = 0;
//   for (int i = num.length - 1; i >= 0; i--) {
//     backCount++;
//     if (backCount % 3 == 0 && i != 0) {
//       newNum = ',' + num.characters.characterAt(i).toString() + newNum;
//     } else {
//       newNum = num.characters.characterAt(i).toString() + newNum;
//     }
//   }
//
//   return newNum;
// }
//
// enum SnackBarType {
//   error,success,warning
// }
// void showSnackBar({@required GlobalKey<ScaffoldState> key,@required SnackBarType type, @required String message, String action, Function onAction}) {
//   final snackBar = SnackBar(
//     content: Text(message,style: TextStyle(color: Colors.white.withOpacity(.78))),
//     backgroundColor: type==SnackBarType.error?Colors.red:type==SnackBarType.success?Colors.green:Colors.orangeAccent,
//     behavior: SnackBarBehavior.fixed,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
//     elevation: 1.6,
//     duration: const Duration(seconds: 3),
//     action: action==null?null:SnackBarAction(
//         label: action,
//         textColor: Colors.white,
//         onPressed: onAction),
//   );
//
//   key.currentState.showSnackBar(snackBar);
// }
