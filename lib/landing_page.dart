// import 'package:amicau/screens/registration/onboarding_page.dart';
// import 'package:amicau/utils/constants.dart';
import 'package:amica/utils/colors.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    // Future.delayed(Duration(seconds: 3), () {
    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>OnboardingPage()));
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: cblack,
      body: Center(
        child: Image(
          height: 135,
          width: 240,
          image: AssetImage("assets/images/img1.png"),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
