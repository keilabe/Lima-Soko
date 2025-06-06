import 'package:flutter/material.dart';

class FarmerProfilePage extends StatelessWidget {
  const FarmerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar is handled by FarmerHomePage
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
            children: [
              // Profile Picture Placeholder
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
              ),
              SizedBox(height: 16),

              // Farmer Name Placeholder
              Text(
                'Farmer Name', // Replace with actual farmer name
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Location or other info Placeholder
              Text(
                'Location: Farmville, USA', // Replace with actual location
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              SizedBox(height: 24),

              // Placeholder for Stats/Summary (optional)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Uploads', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('15', style: TextStyle(fontSize: 18)), // Placeholder count
                    ],
                  ),
                   Column(
                    children: [
                      Text('Reviews', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('4.8/5', style: TextStyle(fontSize: 18)), // Placeholder rating
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Action Buttons Placeholder
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement Edit Profile logic
                  },
                  child: Text('Edit Profile'),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement Settings logic
                  },
                  child: Text('Settings'),
                ),
              ),
            ],
          ),
        ),
      ),
      // BottomNavigationBar is handled by FarmerHomePage
    );
  }
} 