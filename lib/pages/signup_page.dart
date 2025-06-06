import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});


@override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {

  double? _deviceWidth;
  double? _deviceHeight;
  GlobalKey<FormState>? _formKey;

  _SignupPageState() {
    _formKey = GlobalKey<FormState>();
  }

@override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: _signupPageUI(),
      ),
    );
  }

  Widget _signupPageUI() {
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
          _appLogo(),
          _headerText(),
          _signupForm(),
          _signUpButton(),
          _alreadyMemberGoBackToLogIn(),
        ],
      ),
    );
  }

  Widget _appLogo() {
    return Align(            
      child: Container(        
        height: _deviceHeight! * 0.13,
        width: _deviceWidth! * 0.30,
        decoration: BoxDecoration(          
          borderRadius: BorderRadius.circular(500),
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage('assets/images/logo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _headerText() {
    return Container(      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Lima Soko!",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
          ),
          Text(
            "Join us to buy fresh produce",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
    
  }

  Widget _signupForm() {
    return Form(
      key: _formKey,
      onChanged: () {
        _formKey!.currentState!.save();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _nameTextField(),
          _emailTextField(),
          _passwordTextField(),
        ],
      ),
      );
  }
  
    Widget _nameTextField() {
     return TextFormField(
      autocorrect: false,
      validator: (input) {
        return input?.length != 0 ? null : "Please enter a valid name";
      },
      onSaved: (input) {
        setState(() {});
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Name",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        )
      ),
    );
  }

  Widget _emailTextField(){
     return TextFormField(
      autocorrect: false,
      validator: (input) {
        return input?.length != 0 && input!.contains("@") ? null : "Please enter a valid email";
      },
      onSaved: (input) {
        setState(() {});
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Email Address",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        )
      ),
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      autocorrect: false,
      validator: (input) {
        return input!.length >= 6 ? null : "Enter a password of at least 6 characters";
      },
      onSaved: (input) {
        setState(() {});
      },
      obscureText: true,
      cursorColor: Colors.white,
      decoration: InputDecoration(
          hintText: "Password",
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          )
      ),
    );
  }

    Widget _signUpButton() {
    return SizedBox(
      height: _deviceHeight! * 0.06,
      width: _deviceWidth,
      child: MaterialButton(onPressed: (){
        if(_formKey!.currentState!.validate()){}
      },
        color: Color.fromRGBO(255, 142, 5, 1),
        child: Text(
          'Sign up',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
          ),
      ),
    );
  }

  Widget _alreadyMemberGoBackToLogIn() {
      return GestureDetector(        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Already a member?", 
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
            ),
            SizedBox(width: _deviceWidth! * 0.03),
            Text("Log in",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      );
  }
}

