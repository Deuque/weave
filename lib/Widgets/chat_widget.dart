import 'package:flutter/material.dart';
import 'package:weave/Models/message.dart';
import 'package:weave/Util/colors.dart';

class ChatLayout extends StatefulWidget {
  final Message message;
  final bool previousIsSameSender;

  const ChatLayout({Key key, this.message, this.previousIsSameSender}) : super(key: key);

  @override
  _ChatLayoutState createState() => _ChatLayoutState();
}

class _ChatLayoutState extends State<ChatLayout> {
  bool userIsSender;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userIsSender = widget.message.userIsSender;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width*.7,
      alignment: userIsSender?Alignment.centerRight:Alignment.centerLeft,
      margin: EdgeInsets.only(top: widget.previousIsSameSender?0:10,bottom: 2, left: 10,right: 10),
      child: ClipPath(
          clipper: ChatClipper(leftSide: !userIsSender,clip: !widget.previousIsSameSender),
          child: Container(
            color: userIsSender
                ? primary.withOpacity(.8)
                : lightGrey.withOpacity(.15),
            padding: EdgeInsets.only(top: 7,bottom: 10,right: userIsSender?23:10,left: userIsSender?10:23),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: userIsSender
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.time,
                  style:
                      TextStyle(fontSize: 11, color: Theme.of(context)
                          .secondaryHeaderColor.withOpacity(.4)),
                ),
                SizedBox(height: 4,),
                Text(
                  widget.message.message,
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context)
                          .secondaryHeaderColor
                          .withOpacity(.78)),
                ),
              ],
            ),
          )),
    );
  }
}

class ChatClipper extends CustomClipper<Path> {
  bool leftSide;
  bool clip;

  ChatClipper({this.leftSide,this.clip});

  @override
  Path getClip(Size size) {
    double radius = 10;
    final path = Path();

    if(!clip){
      if(leftSide){
        path.moveTo(13+radius, size.height);
        path.arcToPoint(Offset(13, size.height-radius),
            radius: Radius.circular(radius));

        path.lineTo(13, radius);
        path.arcToPoint(Offset((13) + radius, 0),
            radius: Radius.circular(radius));

        path.lineTo(size.width - radius, 0);
        path.arcToPoint(Offset(size.width, radius),
            radius: Radius.circular(radius));
        path.lineTo(size.width, size.height - radius);
        path.arcToPoint(Offset(size.width - radius, size.height),
            radius: Radius.circular(radius));
        path.lineTo((13) + radius, size.height);
        path.close();
      }else{

        path.moveTo(radius, size.height);
        path.arcToPoint(Offset(0, size.height-radius),
            radius: Radius.circular(radius));

        path.lineTo(0, radius);
        path.arcToPoint(Offset(radius, 0),
            radius: Radius.circular(radius));

        path.lineTo(size.width - (13+radius), 0);
        path.arcToPoint(Offset(size.width-13, radius),
            radius: Radius.circular(radius));
        path.lineTo(size.width-13, size.height - radius);
        path.arcToPoint(Offset(size.width - (13+radius), size.height),
            radius: Radius.circular(radius));
        path.lineTo(radius, size.height);
        path.close();
      }
    }
    else if (leftSide) {
      path.moveTo(0.0, 0.0);

      path.lineTo(size.width - radius, 0);
      path.arcToPoint(Offset(size.width, radius),
          radius: Radius.circular(radius));
      path.lineTo(size.width, size.height - radius);
      path.arcToPoint(Offset(size.width - radius, size.height),
          radius: Radius.circular(radius));
      path.lineTo((13+radius), size.height);
      path.arcToPoint(Offset(14, size.height-radius),
          radius: Radius.circular(radius));
      path.lineTo(13, 13);
      path.quadraticBezierTo(10, 3,
          0, 0);

      path.close();
    } else {
      path.moveTo(size.width-13, size.height-radius);

      path.lineTo((size.width-13), 13);
      path.quadraticBezierTo(size.width-10, 3,
          size.width, 0);

      path.lineTo(radius, 0);
      path.arcToPoint(Offset(0, radius),
          radius: Radius.circular(radius),clockwise: false);
      path.lineTo(0, size.height - radius);

      path.arcToPoint(Offset( radius, size.height),
          radius: Radius.circular(radius),clockwise: false);

      path.lineTo(size.width - (13 + radius), size.height);
      path.arcToPoint(Offset(size.width-13,size.height-radius),
          radius: Radius.circular(radius),clockwise: false);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(ChatClipper oldClipper) => true;
}
