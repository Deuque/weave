import 'package:flutter/material.dart';
class ChatClipper extends CustomClipper<Path> {
  bool leftSide;
  bool clip;

  ChatClipper({this.leftSide,this.clip});

  @override
  Path getClip(Size size) {
    double radius = 10;
    final path = Path();

    resolvePath(path, size, clip, leftSide, radius);

    return path;
  }

  @override
  bool shouldReclip(ChatClipper oldClipper) => true;
}

class ChatClipperPainter extends CustomPainter {
  bool leftSide;
  bool clip;
  Color shadowColor;

  ChatClipperPainter({this.leftSide,this.clip,this.shadowColor});
  @override
  void paint(Canvas canvas, Size size) {
    double radius = 10;
    final path = Path();

   resolvePath(path, size, clip, leftSide, radius);
    //canvas.drawShadow(path, shadowColor.withOpacity(.2), 2, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

Path resolvePath(Path path,Size size, clip,leftSide, radius){
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
}