
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weave/Controllers/theme_controller.dart';
import 'package:weave/Screens/Onboarding/onboarding.dart';
import 'package:weave/Util/colors.dart';
import 'package:weave/routes.dart';

void main() {
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
              dividerColor: lightGrey.withOpacity(.35),
              bottomAppBarColor: white,
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: white,
              ),
              primaryTextTheme: GoogleFonts.rubikTextTheme(
                  //Theme.of(context).textTheme,
                  ),
            ),
            initialRoute: 'splash',
            onGenerateRoute: Routes.getRoute,
          );
        });
  }
}

