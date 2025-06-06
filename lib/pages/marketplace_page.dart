import 'package:flutter/material.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key});

  @override
  _MarketplacePageState createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange, // Orange background
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white), // Menu icon
          onPressed: () {
            // TODO: Implement menu functionality
          },
        ),
        title: Text(
          'Marketplace 🏬',
          style: TextStyle(color: Colors.white), // White text
        ),
        centerTitle: true,
        // No actions in this AppBar based on the image provided
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Light grey background
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'What crops are you seeking?',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: InputBorder.none, // Remove default border
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
              ),
            ),
          ),
          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: Colors.deepOrange, // Selected tab text color
            unselectedLabelColor: Colors.grey, // Unselected tab text color
            indicatorColor: Colors.deepOrange, // Indicator color
            tabs: [
              Tab(text: 'Fruits'),
              Tab(text: 'Vegetables'),
              Tab(text: 'Grains'),
            ],
          ),
          // Tab Bar View (Content for each tab)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Fruits List
                ListView.builder(
                  itemCount: 6, // Placeholder item count
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Fruit Item \${index + 1}'), // Placeholder text
                      trailing: Icon(Icons.chevron_right), // Arrow icon
                      onTap: () {
                        // TODO: Implement navigation to item details
                      },
                    );
                  },
                ),
                // Vegetables List
                ListView.builder(
                  itemCount: 6, // Placeholder item count
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Vegetable Item \${index + 1}'), // Placeholder text
                      trailing: Icon(Icons.chevron_right), // Arrow icon
                      onTap: () {
                        // TODO: Implement navigation to item details
                      },
                    );
                  },
                ),
                // Grains List
                ListView.builder(
                  itemCount: 6, // Placeholder item count
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Grain Item \${index + 1}'), // Placeholder text
                      trailing: Icon(Icons.chevron_right), // Arrow icon
                      onTap: () {
                        // TODO: Implement navigation to item details
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 