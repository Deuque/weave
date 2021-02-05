
import 'package:flutter/material.dart';
import 'package:weave/Util/colors.dart';

class DetailItem extends StatelessWidget {
  final Map item;

  const DetailItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: 8.0, horizontal: size.width * .08),
      child: Column(
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.35, end: 0.45),
            duration: Duration(milliseconds: 600),
            builder: (_, double scale, child) => Image.asset(
              item['image'],
              height: size.height * scale,
              // width: size.height * .4,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: size.height * .045,
          ),
          Text(
            item['title'],
            style: TextStyle(
                color: primary, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            item['subtitle'],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor.withOpacity(.6),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
