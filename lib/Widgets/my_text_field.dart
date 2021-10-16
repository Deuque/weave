import 'package:flutter/material.dart';
import 'package:weave/Util/helper_functions.dart';
class MyTextField extends StatefulWidget {
  final String label, hint;
  final ValueChanged<String> onSaved;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isPassword;
  final Widget prefix, suffix;
  final Function onEditComplete;

  const MyTextField({Key key,
    this.label,
    this.hint,
    this.onSaved,
    this.controller,
    this.focusNode,
    this.onEditComplete,
    this.isPassword = false,
    this.suffix,
    this.prefix})
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
              color: Theme
                  .of(context)
                  .secondaryHeaderColor, fontSize: 14),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(20),
              border: InputBorder.none,
              prefixIcon: widget.prefix,
              suffixIcon: widget.isPassword
                  ? InkWell(
                onTap: () =>
                    setState(() {
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
                  color: Theme
                      .of(context)
                      .secondaryHeaderColor
                      .withOpacity(.35),
                  fontSize: 14),
              hintText: widget.hint),
        ),
        label: widget.label,
        context: context);
  }
}