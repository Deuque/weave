
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weave/Controllers/theme_controller.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(
      ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    context.read(themeProvider).getDarkModeState();

    return Consumer(
        builder: (context, watch, _) {
          bool snapshot = watch(themeProvider.state);
          return MaterialApp(
            title: 'Weave',
            debugShowCheckedModeBanner: false,
            themeMode: snapshot != null && snapshot
                ? ThemeMode.dark
                : ThemeMode.system,
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              secondaryHeaderColor: white,
              backgroundColor: Colors.black.withOpacity(.2),
              primaryColor: primary,
              accentColor: accentColor,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: GoogleFonts.rubikTextTheme(
                  // Theme.of(context).textTheme,
                  ),
              appBarTheme: Theme.of(context).appBarTheme.copyWith(
                  textTheme: GoogleFonts.rubikTextTheme(),
                  color: dark,
                  iconTheme: IconThemeData(color: white)),
              scaffoldBackgroundColor: dark,
              cardColor: dark,
              dividerColor: lightGrey.withOpacity(.2),
              bottomAppBarColor: dark,
              bottomSheetTheme:
                  BottomSheetThemeData(backgroundColor: dark),
              primaryTextTheme: GoogleFonts.rubikTextTheme(
                  // Theme.of(context).textTheme,
                  ),

            ),
            theme: ThemeData(
              brightness: Brightness.light,
              secondaryHeaderColor: dark,
              backgroundColor: lightGrey.withOpacity(.3),
              primaryColor: primary,
              accentColor: accentColor,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: GoogleFonts.rubikTextTheme(
                  // Theme.of(context).textTheme,
                  ),
              appBarTheme: Theme.of(context).appBarTheme.copyWith(
                  textTheme: GoogleFonts.rubikTextTheme(),
                  color: white,
                  iconTheme: IconThemeData(color: dark)),
              scaffoldBackgroundColor: white,
              cardColor: white,
              dividerColor: lightGrey.withOpacity(.5),
              bottomAppBarColor: white,
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: white,
              ),
              primaryTextTheme: GoogleFonts.rubikTextTheme(
                  //Theme.of(context).textTheme,
                  ),
            ),
            // home: Scaffold(body: ClockWidget(
            //   colorOfCircle: Colors.orange,
            //   size:300,
            //   items: List.generate(12, (index) => Container(height: 10,width: 10,decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.cyan),)),
            // ),),
            initialRoute: 'splash',
            onGenerateRoute: Routes.getRoute,
          );
        });
  }
}


