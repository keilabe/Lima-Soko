import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.deepOrange, // Consistent with Marketplace AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Search Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Placeholder for Crop Type Filter
            TextField(
              decoration: InputDecoration(
                labelText: 'Crop Type',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Placeholder for Region Filter
            TextField(
              decoration: InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Placeholder for Price Range Filter
            TextField(
              decoration: InputDecoration(
                labelText: 'Price Range', // Or use a RangeSlider/RangeValues
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            // Placeholder Search Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement search logic with filters
                  // For now, just pop the page
                  Navigator.pop(context);
                },
                child: Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 