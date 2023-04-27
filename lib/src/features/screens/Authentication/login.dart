import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:outdrive/src/features/screens/Splash%20Screen/splash_screen.dart';
import '../../../Global/global.dart';
import '../../../constants/colors.dart';
import '../../../constants/image_strings.dart';
import '../../../constants/sizes.dart';
import '../widgets/progress_dialog.dart';
import 'forgot_password_screen.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _passwordVisible = false;
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      MotionToast.warning(
        title: const Text('Email warning',
            style: TextStyle(fontWeight: FontWeight.bold)),
        description: const Text("Email address is not Valid.",
            style: TextStyle(fontSize: 12)),
        layoutOrientation: ToastOrientation.ltr,
        animationType: AnimationType.fromBottom,
        dismissable: true,
        animationDuration: const Duration(milliseconds: 1300),
        toastDuration: const Duration(seconds: 3),
        animationCurve: Curves.easeInOut,
      ); //email warning
    } else if (passwordTextEditingController.text.isEmpty) {
      MotionToast.warning(
        height: 20,
        title: const Text('Password warning',
            style: TextStyle(fontWeight: FontWeight.bold)),
        description:
            const Text("Password is invalid.", style: TextStyle(fontSize: 10)),
        layoutOrientation: ToastOrientation.ltr,
        animationType: AnimationType.fromBottom,
        dismissable: true,
        animationDuration: const Duration(milliseconds: 1300),
        toastDuration: const Duration(seconds: 3),
        animationCurve: Curves.easeInOut,
      ); //password warning
    } else {
      loginInfoNow();
    }
  }

  loginInfoNow() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    //********************   Authenticate User in database     *****************//

    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text.trim(),
                password: passwordTextEditingController.text.trim())
            .catchError((msg) {
      Navigator.pop(context);
      MotionToast.warning(
        height: 100,
        title: const Text('', style: TextStyle(fontWeight: FontWeight.bold)),
        description:
            Text("Error: " + msg.toString(), style: TextStyle(fontSize: 10)),
        layoutOrientation: ToastOrientation.ltr,
        animationType: AnimationType.fromBottom,
        dismissable: true,
        animationDuration: const Duration(milliseconds: 1300),
        toastDuration: const Duration(seconds: 3),
        animationCurve: Curves.easeInOut,
      ).show(context); //error authentication msg
    }))
        .user;

    if (firebaseUser != null) {
      currentFirebaseUser = firebaseUser;
      MotionToast.success(
        title: const Text('Successfully',
            style: TextStyle(fontWeight: FontWeight.bold)),
        description:
            const Text("Login Successfully.", style: TextStyle(fontSize: 12)),
        layoutOrientation: ToastOrientation.ltr,
        animationType: AnimationType.fromBottom,
        dismissable: true,
        animationDuration: const Duration(milliseconds: 1300),
        toastDuration: const Duration(seconds: 3),
        animationCurve: Curves.easeInOut,
      ); //Show dialog when driver Login successfully
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => const SplashScreen()));
    } else {
      Navigator.pop(context);
      MotionToast.error(
        title: const Text('Not Successfully',
            style: TextStyle(fontWeight: FontWeight.bold)),
        description: const Text("Error occurred during Login.",
            style: TextStyle(fontSize: 12)),
        layoutOrientation: ToastOrientation.ltr,
        animationType: AnimationType.fromBottom,
        dismissable: true,
        animationDuration: const Duration(milliseconds: 1300),
        toastDuration: const Duration(seconds: 3),
        animationCurve: Curves.easeInOut,
      ); //Show dialog when driver are not Login successfully
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            child: Padding(
              padding: EdgeInsets.all(tDefaultSize),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                    width: size.width * 0.6,
                    child: Image(
                      image: AssetImage(logo),
                      fit: BoxFit.contain,
                    ),
                  ), //image size box
                  SizedBox(height: size.height * 0.05),
                  Container(
                    height: size.height * 0.65,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(tDefaultSize),
                      child: Column(
                        children: [
                          const Text(
                            "Login as a Driver",
                            textAlign: TextAlign.right,
                            style: font_bold_black_lines,
                          ),
                          SizedBox(height: size.height * 0.05),
                          TextFormField(
                            style: textFieldStyle,
                            controller: emailTextEditingController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              labelText: "Email",
                              labelStyle: labelTextSize,
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          TextFormField(
                            style: textFieldStyle,
                            controller: passwordTextEditingController,
                            keyboardType: TextInputType.text,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.fingerprint),
                              labelText: "Password",
                              labelStyle: labelTextSize,
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible =
                                        !_passwordVisible; // toggle visibility
                                  });
                                },
                                icon: Icon(_passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.05),
                          SizedBox(
                            width: size.width * 0.8,
                            child: ElevatedButton(
                                onPressed: () {
                                  validateForm();
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    backgroundColor: bgColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: tButtonSize)),
                                child: Text('login'.toUpperCase(), style: font_medium_white)),
                          ),

                          TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen())),
                            child: Text('Forgot Password?', style: TextStyle(color: Colors.blue)),
                          ),


                          SizedBox(height: size.height * 0.02),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, '/signup'),
                                child: const Text.rich(
                                  TextSpan(
                                    text: "Do not have an account?",
                                    style: font_color_black,
                                    children: [
                                      TextSpan(
                                          text: " Sign up",
                                          style: TextStyle(color: Colors.blueAccent))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
