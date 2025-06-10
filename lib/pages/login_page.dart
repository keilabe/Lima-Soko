import 'package:flutter/material.dart';
import '../core/services/supabase_service.dart';
import 'dart:developer' as developer;

// import 'package:provider/provider.dart';

// import '../providers/auth_provider.dart';

// import '../services/snackbar_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double? _deviceHeight;
  double? _deviceWidth;
  String? _email;
  String? _password;
  bool _isLoading = false;
  String? _error;
  final _formKey = GlobalKey<FormState>();

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      developer.log('Starting login process for email: $_email');
      final supabaseService = await SupabaseService.getInstance();
      
      // Sign in the user
      developer.log('Attempting to sign in...');
      await supabaseService.signIn(_email!, _password!);
      developer.log('User signed in successfully');

      // Get user profile to check role
      developer.log('Fetching user profile...');
      final userProfile = await supabaseService.querySingle<Map<String, dynamic>>(
        table: 'profiles',
        column: 'id',
        operator: 'eq',
        value: supabaseService.userId,
      );

      if (userProfile == null) {
        developer.log('User profile not found');
        throw Exception('User profile not found');
      }

      developer.log('User profile found with role: ${userProfile['role']}');

      if (mounted) {
        // Navigate based on role
        if (userProfile['role'] == 'farmer') {
          developer.log('Navigating to farmer home page');
          Navigator.pushReplacementNamed(context, '/farmer-home');
        } else {
          developer.log('Navigating to buyer home page');
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      developer.log('Error during login process: $e', error: e);
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Align(
        child: _loginPageUI(),
      ),
    );
  }

  Widget _loginPageUI() {
    return Builder(
      builder: (BuildContext _context) {
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
          ),
        );
      },
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
      onChanged: () {
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
        return _input?.length != 0 && _input!.contains("@")
            ? null
            : "Please enter a valid email";
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
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      autocorrect: false,
      validator: (_input) {
        return _input!.length >= 6
            ? null
            : "Enter a password of at least 6 characters";
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
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      height: _deviceHeight! * 0.06,
      width: _deviceWidth,
      child: MaterialButton(
        onPressed: _isLoading ? null : _signIn,
        color: Color.fromRGBO(255, 142, 5, 1),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'LOGIN',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
              ),
      ),
    );
  }

  Widget _registerButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/signup');
      },
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