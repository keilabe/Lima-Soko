import 'package:flutter/material.dart';
import '../core/services/supabase_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AssetImage? _userProfileImage = AssetImage('assets/images/farmer1.jpg');
  late final SupabaseService _supabaseService;

  @override
  void initState() {
    super.initState();
    _initializeSupabase();
  }

  Future<void> _initializeSupabase() async {
    _supabaseService = await SupabaseService.getInstance();
  }

  Future<void> _signOut() async {
    try {
      await _supabaseService.client.auth.signOut();
      // Navigation will be handled by the auth state listener in main.dart
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // TODO: Implement menu functionality
          },
        ),
        title: Text(
          'My Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: _userProfileImage,
                child: _userProfileImage == null
                    ? Icon(Icons.person, size: 60, color: Colors.grey[600])
                    : null,
              ),
              SizedBox(height: 16),
              Text(
                'Emma Johnson',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ProfileOptionTile(title: 'My Listings'),
                  ProfileOptionTile(title: 'My Purchases'),
                  ProfileOptionTile(title: 'Order Tracking'),
                  ProfileOptionTile(title: 'Account Settings'),
                  ProfileOptionTile(
                    title: 'Sign Out',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Sign Out'),
                            content: Text('Are you sure you want to sign out?'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Sign Out'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _signOut();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileOptionTile extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const ProfileOptionTile({
    super.key, 
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        title: Text(title),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
} 