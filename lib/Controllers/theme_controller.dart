
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weave/Util/colors.dart';

final themeProvider =
StateNotifierProvider<DeviceTheme>((ref) => DeviceTheme());

class DeviceTheme extends StateNotifier<bool> {
  DeviceTheme([bool darkMode]) : super(darkMode ?? true);

  bool darkMode()=>state;

  void toggle(){
    state = !state;
    //setCurrentStatusNavigationBarColor();
    saveDarkModeState();
  }

  setCurrentStatusNavigationBarColor() {
    if (!state) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        //statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        //statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: dark,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
  }

  Future<void> getDarkModeState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('darkMode') ?? true;
   // setCurrentStatusNavigationBarColor();
  }

  saveDarkModeState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', state);
  }
}
