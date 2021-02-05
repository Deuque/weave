
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider =
StateNotifierProvider<DeviceTheme>((ref) => DeviceTheme());

class DeviceTheme extends StateNotifier<bool> {
  DeviceTheme([bool darkMode]) : super(darkMode ?? false);

  bool darkMode()=>state;

  void toggle(){
    state = !state;
    setCurrentStatusNavigationBarColor();
    saveDarkModeState();
  }

  setCurrentStatusNavigationBarColor() {
    if (!state) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        //statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFFFFFFF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        //statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF090A1E),
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
  }

  Future<void> getDarkModeState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('darkMode') ?? false;
  }

  saveDarkModeState() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', state);
  }
}
