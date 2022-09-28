import 'package:dairyfarmapp/screens/login/login.dart';
import 'package:dairyfarmapp/util/constents.dart';
import 'package:flutter/material.dart';
import 'package:introduction_slider/introduction_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late SharedPreferences pref;

  someInitMethod() async {
    pref = await SharedPreferences.getInstance();
    pref.setBool("seen", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionSlider(
        selectedDotColor: Colors.black,
        skip: const Text(
          "Skip",
          style: TextStyle(color: Colors.black),
        ),
        done: const Text(
          "Done",
          style: TextStyle(color: Colors.black),
        ),
        next: const Text(
          "Next",
          style: TextStyle(color: Colors.black),
        ),
        onDone: onDonePress(),
        items: const [
          IntroductionSliderItem(
            backgroundColor: slider1BackColor,
            image: Image(image: AssetImage("assets/images/slider1.jpg")),
            title: "WELCOME!",
            description: "Dairy Farm to bring ease in your life",
          ),
          IntroductionSliderItem(
            image: Image(image: AssetImage("assets/images/slider2.jpg")),
            title: "BILL",
            description: "Get your bill on Monthly or Daily Basis",
          ),
          IntroductionSliderItem(
            backgroundColor: slider3BackColor,
            image: Image(image: AssetImage("assets/images/slider3.png")),
            title: "Fresh",
            description: "Get 100% Fresh and Healthy",
          ),
        ],
      ),
    );
  }

  Widget onDonePress() {
    someInitMethod();
    return LoginScreen();
  }
}
