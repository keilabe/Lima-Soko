import 'package:flutter/material.dart';
import '../core/services/supabase_service.dart';
import 'dart:developer' as developer;
import 'dart:async'; // Import for Future.delayed

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

@override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  double? _deviceWidth;
  double? _deviceHeight;
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;
  String _selectedRole = 'buyer';
  bool _isLoading = false;
  String? _error;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      developer.log('Starting signup process for email: $_email');
      final supabaseService = await SupabaseService.getInstance();
      
      // Sign up the user
      developer.log('Attempting to create user account...');
      final newUser = await supabaseService.signUp(
        _email!,
        _password!,
        {'full_name': _name, 'role': _selectedRole},
      );
      developer.log('User account created successfully');
      developer.log('Supabase user ID after signup: ${newUser.id}');

      // Remove the explicit session refresh as profile creation is now handled by a database trigger
      // developer.log('Refreshing Supabase session...');
      // await supabaseService.client.auth.refreshSession();
      // developer.log('Supabase session refreshed.');

      // Remove the delay as it's no longer needed
      // await Future.delayed(const Duration(seconds: 1)); 
      developer.log('Attempting to create user profile via database trigger (client-side insert removed).');

      // Profile creation is now handled by the 'handle_new_user' trigger in Supabase.
      // No client-side insert is needed here.
      // developer.log('Creating user profile with role: $_selectedRole');
      // final profileData = {
      //   'id': newUser.id, // Use the ID from the returned user object
      //   'email': _email,
      //   'full_name': _name,
      //   'role': _selectedRole,
      // };
      // developer.log('Profile data: $profileData');

      // try {
      //   await supabaseService.insert<Map<String, dynamic>>(
      //     table: 'profiles',
      //     data: profileData,
      //   );
      //   developer.log('User profile created successfully');
      // } catch (profileError) {
      //   developer.log('Error creating profile: $profileError', error: profileError);
      //   // If profile creation fails, we should clean up the auth user
      //   try {
      //     await supabaseService.signOut();
      //     developer.log('Cleaned up auth user after profile creation failure');
      //   } catch (cleanupError) {
      //     developer.log('Error during cleanup: $cleanupError', error: cleanupError);
      //   }
      //   throw Exception('Failed to create user profile. Please try again.');
      // }

      if (mounted) {
        developer.log('Navigating to appropriate home page based on role: $_selectedRole');
        // Navigate to appropriate home page based on role
        if (_selectedRole == 'farmer') {
          Navigator.pushReplacementNamed(context, '/farmer-home');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      developer.log('Error during signup process: $e', error: e);
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
          image: const DecorationImage(
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
        _formKey.currentState!.save();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _nameTextField(),
          _emailTextField(),
          _passwordTextField(),
          _roleDropdown(),
        ],
      ),
      );
  }
  
    Widget _nameTextField() {
     return TextFormField(
      autocorrect: false,
      validator: (_input) {
        return _input?.length != 0 ? null : "Please enter a valid name";
      },
      onSaved: (_input) {
        setState(() {
          _name = _input;
        });
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: "Name",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
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

  Widget _roleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      decoration: InputDecoration(
        hintText: "Select Role",
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      items: const [
        DropdownMenuItem(
          value: 'buyer',
          child: Text('Buyer'),
        ),
        DropdownMenuItem(
          value: 'farmer',
          child: Text('Farmer'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedRole = value;
          });
        }
      },
    );
  }

    Widget _signUpButton() {
    return Container(
      height: _deviceHeight! * 0.06,
      width: _deviceWidth,
      child: MaterialButton(
        onPressed: _isLoading ? null : _signUp,
        color: Color.fromRGBO(255, 142, 5, 1),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
          'Sign up',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),
          ),
      ),
    );
  }

  Widget _alreadyMemberGoBackToLogIn() {
      return GestureDetector(        
      onTap: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            "Already a member?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
            ),
            SizedBox(width: _deviceWidth! * 0.03),
          Text(
            "Log in",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      );
  }
}

