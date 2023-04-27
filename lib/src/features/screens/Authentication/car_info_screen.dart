import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:outdrive/src/Global/global.dart';
import 'package:outdrive/src/constants/colors.dart';
import 'package:outdrive/src/constants/image_strings.dart';
import 'package:outdrive/src/constants/sizes.dart';

import '../Splash Screen/splash_screen.dart';
import '../widgets/progress_dialog.dart';

class CarInfoScreen extends StatefulWidget {

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {

  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  List<String> carTypesList = ["uber-x", "uber-go", "bike"];
  String? selectedCarType;

//********************   Authenticate driver car info in database     *****************//

  saveCarInfo(){
    Map driverCarInfoMap =
    {
      "car_color": carColorTextEditingController.text.trim(),
      "car_number": carNumberTextEditingController.text.trim(),
      "car_model": carModelTextEditingController.text.trim(),
      "type": selectedCarType,
    };
    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
    driversRef.child(currentFirebaseUser!.uid).child("car_details").set(driverCarInfoMap);
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (c)=> const SplashScreen()));
  }

//********************   Authenticate driver car info in database     *****************//


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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(logo),
                  height: size.height * 0.1,
                  width: size.width * 0.7,
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  child: Container(
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
                            "Car Details",
                            textAlign: TextAlign.right,
                            style: font_bold_black_lines,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            style: textFieldStyle,
                            controller: carModelTextEditingController,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.car_rental),
                                labelText: "Car Model",
                                labelStyle: labelTextSize,
                                border: OutlineInputBorder()),
                          ), //Car Model

                          const SizedBox(
                            height: 10,
                          ),

                          TextFormField(
                            style: textFieldStyle,
                            controller: carNumberTextEditingController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.numbers),
                              labelText: "Car No.",
                              labelStyle: labelTextSize,
                              border: OutlineInputBorder(),
                            ),
                          ), //Car No.

                          const SizedBox(
                            height: 10,
                          ),

                          TextFormField(
                            style: textFieldStyle,
                            controller: carColorTextEditingController,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.color_lens),
                                labelText: "Car Color",
                                labelStyle: labelTextSize,
                                border: OutlineInputBorder()),
                          ), //Car Color
                          const SizedBox(
                            height: 10,
                          ),

                          Container(
                            width: size.width * 0.75,
                            child: DropdownButton(
                              isExpanded: true,
                              iconSize: 26,
                              dropdownColor: Colors.black,
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              hint: const Text(
                                "Please choose Car Type",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                              value: selectedCarType,
                              onChanged: (newValue)
                              {
                                setState(() {
                                  selectedCarType = newValue.toString();
                                });
                              },
                              items: carTypesList.map((car){
                                return DropdownMenuItem(
                                  child: Text(
                                    car,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  value: car,
                                );
                              }).toList(),
                            ),
                          ), //Dropdown for car selection

                          const SizedBox(
                            height: 10,
                          ),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  if(carModelTextEditingController.text.isNotEmpty
                                      && carNumberTextEditingController.text.isNotEmpty
                                      && carColorTextEditingController.text.isNotEmpty
                                      && selectedCarType != null)
                                  {
                                    saveCarInfo();
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext c)
                                        {
                                          return ProgressDialog(message: "Processing, Please wait...",);
                                        }
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0)),
                                    backgroundColor: bgColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: tButtonSize)),
                                child: Text('register'.toUpperCase(), style: font_medium_white)),
                          ), //Register button

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
                          ), //Have an account?
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
