import 'package:flutter/material.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(

        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.1, end: 1),
          duration: Duration(seconds: 1),
          builder: (_, double opacity, child) => Opacity(
            opacity: opacity,
            child: Center(
              heightFactor: size.height * .4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  logo(size: size.width * .1, spacing: 3),
                  Text(
                    'Play games together',
                    style: TextStyle(color: lightGrey, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          onEnd: ()=>Future.delayed(Duration(milliseconds: 600),()=>Navigator.pushReplacementNamed(context, 'initial')),
        ),
      ),
    );
  }
}
