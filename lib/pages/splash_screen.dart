import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  double? _deviceWidth;
  double? _deviceHeight;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: _screenPlashPageUI(),
        )
      ),
    );
  }
  

  Widget _screenPlashPageUI() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.10),
      alignment: Alignment.center,
      height: _deviceHeight! * 0.75,
      width: _deviceWidth! * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _introTextAndImage(),
          _shopNowButton(),
        ],
      ),
    );
  }

  Widget _introTextAndImage() {
    return Container(
      width: _deviceWidth! * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _introImage(),
          SizedBox(height: 20),
          _introText(),
        ],
      ),
    );
  }

  Widget _introImage() {
    return Container(
      height: _deviceHeight! * 0.30,
      width: _deviceWidth! * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(500),
        color: Colors.transparent,
        image: DecorationImage(
          image: AssetImage('assets/images/farmer.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _introText() {
    return Container(
      width: _deviceWidth! * 0.8,
      child: Column(
        children: [
          _appName(),
          SizedBox(height: 8),
          _appSlogan(),
        ],
      ),
    );
  }

  Widget _appName() {
    return Text(
      'Lima Soko',
      style: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _appSlogan() {
    return Text(
      'Connect with local farmers',
      style: TextStyle(
        fontSize: 24,
      ),
    );
  }

  Widget _shopNowButton() {
    return Container(
      width: _deviceWidth,
      height: _deviceHeight! * 0.06,
      child: ElevatedButton(
        onPressed: () {},        
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(255, 142, 5, 1),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),          
        ),
        child: Text(
          'Shop Now',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
