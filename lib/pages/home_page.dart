import 'package:flutter/material.dart';
import 'package:lima_soko/pages/marketplace_page.dart'; // Import the new marketplace page
import 'package:lima_soko/pages/profile_page.dart'; // Import the new profile page
import 'package:lima_soko/pages/search_page.dart'; // Import the new search page

class HomePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

// Helper widget for the product card
class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String shippingPrice;

  const ProductCard({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.shippingPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, // Card width
      margin: EdgeInsets.only(right: 16), // Spacing between cards
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Image.network(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 100,
                color: Colors.grey[300],
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
              ), // Placeholder for image loading errors
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  // Subtitle
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  // Shipping Price
                  Text(
                    shippingPrice,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0; // To keep track of the selected tab

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // List of widgets for each bottom navigation tab
  static List<Widget> _widgetOptions = <Widget>[
    // Home Page Content
    SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // New on Marketplace Section
            Text(
              'New on Marketplace',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200, // Height for horizontal list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Number of cards (placeholder)
                itemBuilder: (context, index) {
                  // Placeholder Data
                  return ProductCard(
                    imageUrl: 'https://via.placeholder.com/150', // Replace with actual image URLs
                    title: 'Item Title \${index + 1}',
                    subtitle: 'Item Subtitle',
                    shippingPrice: '\$2.50 shipping',
                  );
                },
              ),
            ),
            SizedBox(height: 20),

            // Trending Items Section
            Text(
              'Trending Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200, // Height for horizontal list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Number of cards (placeholder)
                itemBuilder: (context, index) {
                  // Placeholder Data
                  return ProductCard(
                    imageUrl: 'https://via.placeholder.com/150', // Replace with actual image URLs
                    title: 'Trending Item \${index + 1}',
                    subtitle: 'Trending Subtitle',
                    shippingPrice: '\$4.00 shipping',
                  );
                },
              ),
            ),
            SizedBox(height: 20),

            // Fast Shipping Section
            Text(
              'Fast Shipping',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200, // Height for horizontal list
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Number of cards (placeholder)
                itemBuilder: (context, index) {
                  // Placeholder Data
                  return ProductCard(
                    imageUrl: 'https://via.placeholder.com/150', // Replace with actual image URLs
                    title: 'Fast Ship Item \${index + 1}',
                    subtitle: 'Fast Ship Subtitle',
                    shippingPrice: '\$3.00 shipping',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    MarketplacePage(), // Use the new MarketplacePage widget
    SearchPage(), // Use the new SearchPage for the Search tab
    ProfilePage(), // Use the new ProfilePage widget
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded( // Wrap Text with Expanded
              child: Text(
                'Lima Soko',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                ),
                overflow: TextOverflow.ellipsis, // Add ellipsis for long text
              ),
            ),
          ],
        ),
        actions: [
          // Search Icon in AppBar
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Navigate to the SearchPage when the icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
          // Placeholder for User Name
          Center(child: Text('User Name')), // Replace with actual user name variable
          SizedBox(width: 8), // Spacing
          // User Profile Icon
          IconButton(
            icon: CircleAvatar(
              // Placeholder for user profile image
              backgroundImage: AssetImage('assets/images/farmer1.jpg'), // Replace with actual user profile image asset
              child: Icon(Icons.person), // Fallback icon if no image
            ),
            onPressed: () {
              // TODO: Navigate to profile page
            },
          ),
          SizedBox(width: 8), // Spacing on the right
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex), // Display content based on selected tab
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800], // Customize selected item color
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}