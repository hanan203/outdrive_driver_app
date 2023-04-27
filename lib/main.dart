import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:outdrive/src/features/screens/Authentication/car_info_screen.dart';
import 'package:outdrive/src/features/screens/Authentication/login.dart';
import 'package:outdrive/src/features/screens/Main%20Screens/main_screen.dart';
import 'package:outdrive/src/features/screens/Authentication/signup.dart';
import 'package:outdrive/src/features/screens/welcome.dart';
import 'package:outdrive/src/features/screens/On%20Boarding%20Screens/on_boarding_screen.dart';
import 'package:outdrive/src/features/screens/Splash%20Screen/splash_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/on_board': (context) => OnBoardingScreen(),
        '/welcome': (context) => Welcome(),
        // '/otpscreen': (context) => OTPScreen('+923156624170'),
        '/signup': (context) => SignUp(),
        '/mainscreen': (context) => MainScreen(),
        '/car_info_screen': (context) => CarInfoScreen(),
        '/login': (context) => Login(),
        // '/phonenumberscreen': (context) => PhoneNumberScreen(),
        // other routes
      },
    ),
  ));
}

class MyApp extends StatefulWidget {
  final Widget? child;

  MyApp({this.child});

  static void restartApp (BuildContext context)
  {
  context.findAncestorStateOfType<_MyAppState>()!.restartApp();
}
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Key key = UniqueKey();
  void restartApp()
  {
    setState (() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree (
      key: key,
      child: widget.child!,
    );
  }
}
