import 'package:flutter/material.dart';
import 'package:weave/Util/colors.dart';

class DetailItem extends StatelessWidget {
  final Map item;
  final bool down;

  const DetailItem({Key key, this.item, this.down}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        reverse: down,
        shrinkWrap: true,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.05, end: 0.3),
            duration: Duration(milliseconds: 600),
            builder: (_, double scale, child) => Center(
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(50),bottomLeft: Radius.circular(50),bottomRight: Radius.circular(10)),
                child: Image.asset(
                  item['image'],
                  height: size.height * scale,
                  // width: size.height * .4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * .045,
          ),
          Text.rich(
            TextSpan(children: [
              TextSpan(
                text: item['title'] + '\n',
                style: TextStyle(
                  color: primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              WidgetSpan(
                  child: SizedBox(
                height: 20,
              )),
              TextSpan(
                text: item['subtitle'],
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor.withOpacity(.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
