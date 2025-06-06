import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Example variable to hold the user profile image provider
  // Initialize with null or an actual image provider
  final AssetImage? _userProfileImage = AssetImage('assets/images/farmer1.jpg'); // Example: initially show an image
  // AssetImage? _userProfileImage = null; // Example: initially no image, show icon

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white), // Menu icon
          onPressed: () {
            // TODO: Implement menu functionality
          },
        ),
        title: Text(
          'My Profile', // Title from the image
          style: TextStyle(color: Colors.white), // White text
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 60, // Adjust size as needed
                backgroundImage: _userProfileImage, // Use the state variable
                child: _userProfileImage == null
                    ? Icon(Icons.person, size: 60, color: Colors.grey[600]) // Show icon if no image
                    : null, // Set to null if image is available
              ),
              SizedBox(height: 16),
              // User Name
              Text(
                'Emma Johnson', // Replace with actual user name
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),
              // Profile Options List
              ListView(
                shrinkWrap: true, // Important to wrap content
                physics: NeverScrollableScrollPhysics(), // Disable ListView scrolling as it's in a SingleChildScrollView
                children: [
                  ProfileOptionTile(title: 'My Listings'),
                  ProfileOptionTile(title: 'My Purchases'),
                  ProfileOptionTile(title: 'Order Tracking'),
                  ProfileOptionTile(title: 'Account Settings'),
                  ProfileOptionTile(title: 'Sign Out'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper widget for profile options
class ProfileOptionTile extends StatelessWidget {
  final String title;

  const ProfileOptionTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Spacing
      child: ListTile(
        title: Text(title),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Implement navigation for each option
        },
      ),
    );
  }
} 