import 'dart:async';
import 'dart:math';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:outdrive/src/constants/colors.dart';
import 'package:outdrive/src/constants/image_strings.dart';
import 'package:outdrive/src/constants/sizes.dart';
import 'package:motion_toast/motion_toast.dart';
import '../../../Global/global.dart';
import '../widgets/progress_dialog.dart';
import 'car_info_screen.dart';
import 'package:mailer/mailer.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _passwordVisible = false;
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController otpTextEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _generatedOtp = '';
  bool _otpSent = false;
  bool _otpVerified = false;

  Future<void> _generateOtp() async {
    int randomNumber = Random().nextInt(900000) + 100000;
    final randomNumberString = randomNumber.toString();
    _generatedOtp = randomNumberString;
    print('Generated OTP: $_generatedOtp');

    // Create a SMTP client configuration:
    final smtpServer =
        gmail('laraibkhan200200200@gmail.com', 'hhktskgqiwisuglb');

    // Create a message:
    final message = Message()
      ..from = Address('laraibkhan200200200@gmail.com', 'Outdrive')
      ..recipients
          .add(emailTextEditingController.text.trim()) // recipient email
      ..subject = 'OTP for registration' // email subject
      ..text =
          'Your OTP for registration is $_generatedOtp. Enter this in the app and get verify'; // email body

    try {
      // Send the message:
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
      // handle the exception
    }
  }

  void _verifyOtp() {
    if (_generatedOtp == otpTextEditingController.text.trim()) {
      _otpVerified = true;
      saveDriverInfoNow();
    } else {
      _otpVerified = false;
      MotionToast.error(
        title: const Text('OTP Error',
            style: TextStyle(fontWeight: FontWeight.bold)),
        description: const Text("Invalid OTP. Please try again.",
            style: TextStyle(fontSize: 12)),
        layoutOrientation: ToastOrientation.ltr,
        animationType: AnimationType.fromBottom,
        dismissable: true,
        animationDuration: const Duration(milliseconds: 1300),
        toastDuration: const Duration(seconds: 3),
        animationCurve: Curves.easeInOut,
      ).show(context);
    }
  }
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text("Enter OTP"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("An OTP has been sent to your email."),
              SizedBox(height: 20),
              TextFormField(
                controller: otpTextEditingController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: "Enter OTP",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _verifyOtp();
                if (_otpVerified) {
                  Navigator.of(context).pop();
                }
              },
              child: Text("Verify"),
            ),
          ],
        );
      },
    );
  }


  validateForm() async {
    if (_formKey.currentState!.validate()) {
      _otpSent = true;
      await _generateOtp(); // wait for OTP to be generated
      _showAlertDialog(context);
    }
  }

  saveDriverInfoNow() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext c) {
        return ProgressDialog(message: "Processing, Please wait...");
      },
    );

    final User? firebaseUser = (await fAuth
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      MotionToast.warning(
        title: const Text('', style: TextStyle(fontWeight: FontWeight.bold)),
        description:
            Text("Error: " + msg.toString(), style: TextStyle(fontSize: 12)),
        layoutOrientation: ToastOrientation.ltr,
        animationType: AnimationType.fromBottom,
        dismissable: true,
        animationDuration: const Duration(milliseconds: 1300),
        toastDuration: const Duration(seconds: 3),
        animationCurve: Curves.easeInOut,
      ).show(context);
    }))
        .user;

    if (firebaseUser != null) {
      Map driverMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).set(driverMap);

      currentFirebaseUser = firebaseUser;
      MotionToast.success(
        title: const Text('Successfully',
            style: TextStyle(fontWeight: FontWeight.bold)),
        description: const Text("Account has been Created.",
            style: TextStyle(fontSize: 12)),
        layoutOrientation: ToastOrientation.ltr,
        animationType: AnimationType.fromBottom,
        dismissable: true,
        animationDuration: const Duration(milliseconds: 1300),
        toastDuration: const Duration(seconds: 3),
        animationCurve: Curves.easeInOut,
      ).show(context);
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => CarInfoScreen()));
    } else {
      Navigator.pop(context);
      MotionToast.error(
        title: const Text('Not Successfully',
            style: TextStyle(fontWeight: FontWeight.bold)),
        description: const Text("Account has not been Created.",
            style: TextStyle(fontSize: 12)),
        layoutOrientation: ToastOrientation.ltr,
        animationType: AnimationType.fromBottom,
        dismissable: true,
        animationDuration: const Duration(milliseconds: 1300),
        toastDuration: const Duration(seconds: 3),
        animationCurve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: SingleChildScrollView(
          child: Container(
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
                SizedBox(height: size.height * 0.02),
                Form(
                  key: _formKey,
                  child: Container(
                    height: size.height * 0.70,
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
                            "Register as a Driver",
                            textAlign: TextAlign.right,
                            style: font_bold_black_lines,
                          ),
                          SizedBox(height: size.height * 0.02),
                          TextFormField(
                            style: textFieldStyle,
                            controller: nameTextEditingController,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person_outline_outlined,),
                                labelText: "Full Name",
                                labelStyle: labelTextSize,
                                border: OutlineInputBorder()),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Name can't be empty";
                              } else if (val.length < 3) {
                                return "Name must be at least 3 characters long";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: size.height * 0.02),

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
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Email can't be empty";
                              } else if (!EmailValidator.validate(val)) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                          ), //Email

                          SizedBox(height: size.height * 0.02),

                          TextFormField(
                            style: textFieldStyle,
                            controller: phoneTextEditingController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.numbers_outlined),
                                labelText: "Phone No.",
                                labelStyle: labelTextSize,
                                border: OutlineInputBorder()),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Phone number can't be empty";
                              }
                              return null;
                            },
                          ), //Phone No

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
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Password can't be empty";
                              } else if (val.length < 6) {
                                return "Password must be at least 6 characters long";
                              }
                              return null;
                            },
                          ), //Password

                          const SizedBox(
                            height: 20,
                          ),

                          SizedBox(
                            width: double.infinity,
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
                              child: Text('register'.toUpperCase(), style: font_medium_white),
                            ),
                          ), //register button

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, '/login'),
                                child: const Text.rich(
                                  TextSpan(
                                    text: "Have an account?",
                                    style: font_color_black,
                                    children: [
                                      TextSpan(
                                          text: " Login",
                                          style:
                                              TextStyle(color: tPrimaryColor))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ), //Sign up
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
