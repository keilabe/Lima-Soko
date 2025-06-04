import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';

// import '../providers/auth_provider.dart';

// import '../services/snackbar_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double ?_deviceHeight;
  double ?_deviceWidth;

  // AuthProvider ?_auth;

  String ?_email;
  String ?_password;

  GlobalKey <FormState> _formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    _deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Align(
        child: _loginPageUI(),
      ),
    );
  }

  Widget _loginPageUI() {
    return Builder(builder: (BuildContext _context){
      // SnackbarService.instance.buildContext = _context;
      // _auth = Provider.of<AuthProvider>(_context);    
      return Container(      
      padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.10),
      height: _deviceHeight! * 0.60,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerText(),
          _loginForm(),
          _loginButton(),
          _registerButton(),
        ],
      )
    );
    }
    );
  }

  Widget _headerText() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome back!",
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
          ),
          Text(
            "Please login to your account",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
          ),
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _formKey,
      onChanged: (){
        _formKey.currentState?.save();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _emailTextField(),
        _passwordTextField(),
      ],
      ),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      autocorrect: false,
      validator: (_input) {
        return _input?.length != 0 && _input!.contains("@") ? null : "Please enter a valid email";
      },
      onSaved: (_input) {
        setState(() {
          _email = _input;
        });
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
      validator: (_input) {
        return _input!.length >= 6 ? null : "Enter a password of at least 6 characters";
      },
      onSaved: (_input) {
        setState(() {
          _password = _input;
        });
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

  Widget _loginButton() {
    return Container(
      height: _deviceHeight! * 0.06,
      width: _deviceWidth,
      child: MaterialButton(onPressed: (){
        if(_formKey!.currentState!.validate()){
          print("Email: $_email");
          print("Password: $_password");  
          // _auth!.loginWithEmailAndPassword(_email!, _password!);
        }
      },
        color: Color.fromRGBO(255, 142, 5, 1),
        child: Text(
          'LOGIN',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
          ),
      ),
    );
  }

  Widget _registerButton() {
    return GestureDetector(
      onTap: (){},
        child: Container(
      height: _deviceHeight! * 0.06,
      width: _deviceWidth,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,          
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
            "REGISTER",
                textAlign: TextAlign.center,
                style: TextStyle(
            fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.green,
        ),
        ),
      ),
        ),
    );
  }
}