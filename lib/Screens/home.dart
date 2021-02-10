import 'package:flutter/material.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/Util/helper_functions.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        leadingWidth: 150,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: logo(size: 30),
          ),
        ),
        actions: [
          Center(
              child: IconButton(
                  icon: Image.asset('assets/images/search.png',height: 17,),
                  onPressed: () {},))
        ],
      ),
    );
  }
}
