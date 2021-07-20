import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminder_app/provider%20Services/contactProvider.dart';
import 'package:reminder_app/provider%20Services/requestProvider.dart';
import 'package:reminder_app/widgetPages/chatPage.dart';
import 'package:reminder_app/widgetPages/homePage.dart';
import 'package:reminder_app/widgetPages/newRequest.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      // DevicePreview(
      //   enabled: !kReleaseMode,
      //   builder: (context) => MyApp(),
      // ),

      MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ContactProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RequestProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme:
        //     ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
        darkTheme: ThemeData(
            brightness:
                MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
                    .platformBrightness),
        home: HomePage(),
      ),
    );
  }
}
