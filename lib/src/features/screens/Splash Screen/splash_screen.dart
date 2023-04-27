import 'dart:async';
import 'package:flutter/material.dart';
import 'package:outdrive/src/constants/image_strings.dart';
import 'package:outdrive/src/features/screens/Authentication/login.dart';
import 'package:outdrive/src/features/screens/On%20Boarding%20Screens/on_boarding_screen.dart';
import 'package:outdrive/src/features/screens/welcome.dart';
import '../../../Global/global.dart';
import '../../../constants/colors.dart';
import '../Authentication/car_info_screen.dart';
import '../Main Screens/main_screen.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer()
  {
    Timer(const Duration(milliseconds: 2500), () async
    {
      if(await fAuth.currentUser != null)
      {
        currentFirebaseUser = fAuth.currentUser;
        Navigator.push(context, MaterialPageRoute(builder: (c)=> MainScreen()));
      }
      else
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> Login()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(logo, height: 300, width: 300,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//
//   bool animate = false;
//   @override
//   void initState() {
//     startAnimation();
//     // super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: bgColor,
//       body: Stack(children: [
//         AnimatedPositioned(
//             duration: const Duration(milliseconds: 900),
//             top: 30,
//             right: animate ? 65 : -200,
//             child: AnimatedOpacity(
//               child: Image(image: AssetImage(logo), height: 300, width: 300,),
//               duration: const Duration(milliseconds: 800),
//               opacity: animate ? 1 : 0,
//             )),
//       ]),
//     );
//   }
//
//   Future startAnimation() async {
//     await Future.delayed(const Duration(milliseconds: 200));
//     setState(() => animate = true);
//     await Future.delayed(const Duration(milliseconds: 2000));
//     Navigator.pushReplacementNamed(context, '/on_board');
//   }
// }
