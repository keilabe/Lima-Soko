import 'package:flutter/material.dart';
import 'package:lima_soko/pages/farmer/farmer_chat_page.dart';
import 'package:lima_soko/pages/farmer/farmer_upload_produce_page.dart';
import 'package:lima_soko/pages/farmer/farmer_profile_page.dart';

class FarmerHomePage extends StatefulWidget {
  const FarmerHomePage({super.key});

  @override
  _FarmerHomePageState createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _farmerPages = <Widget>[
    FarmerHomePageContent(),
    FarmerChatPage(chatId: 'placeholder_chat_id'),
    FarmerUploadProducePage(),
    FarmerProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? 'Farmer Home' :
          _selectedIndex == 1 ? 'Farmer Chat' :
          _selectedIndex == 2 ? 'Upload Produce' :
          'Farmer Profile',
        ),
      ),
      body: _farmerPages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

class FarmerHomePageContent extends StatelessWidget {
  const FarmerHomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard/Stats Section (Image 3)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Low Produce Alert', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.orange, size: 30),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text('Your stock of tomatoes is running low. Please update your inventory to avoid running out.'),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                                SizedBox(width: 4),
                                Text('Upload', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                              ],
                            ),
                             Row(
                              children: [
                                Icon(Icons.star, size: 18, color: Colors.amber),
                                SizedBox(width: 4),
                                Text('5.0/5', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Implement upload produce navigation
                              },
                              child: Text('Upload Prod'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[700],
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Categories Section (Image 3)
           Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Categories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                           decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                           ),
                          child: Icon(Icons.local_florist_outlined, size: 30, color: Colors.black87),
                        ),
                        SizedBox(height: 4),
                        Text('Vegetables', style: TextStyle(fontSize: 12))
                      ],
                    ),
                     Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                           decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                           ),
                          child: Icon(Icons.apple, size: 30, color: Colors.black87),
                        ),
                        SizedBox(height: 4),
                        Text('Fruits', style: TextStyle(fontSize: 12))
                      ],
                    ),
                     Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                           decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                           ),
                          child: Icon(Icons.grain, size: 30, color: Colors.black87),
                        ),
                        SizedBox(height: 4),
                        Text('Grains', style: TextStyle(fontSize: 12))
                      ],
                    ),
                       Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                           decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                           ),
                          child: Icon(Icons.grass_outlined, size: 30, color: Colors.black87),
                        ),
                        SizedBox(height: 4),
                        Text('Herbs', style: TextStyle(fontSize: 12))
                      ],
                    ),
                  ],
                ),
        ],
        ),
            ),
            SizedBox(height: 16),

            // My Uploads Section (Image 3)
             Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text('My Uploads', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                   SizedBox(height: 16),
                    Card(
                      elevation: 2.0,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                       child: Padding(
                         padding: const EdgeInsets.all(16.0),
                         child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: Icon(Icons.image, size: 40, color: Colors.grey[600]),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Manage Your Uploads', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  Text('View and edit your listed produce.', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                ],
                              ),
                            ),
                            Icon(Icons.bookmark_border, size: 30, color: Colors.orange[700]),
                          ],
                         ),
                       ),
                    )
                ],
              ),
            ),
             SizedBox(height: 16),

            // Blog Section (Image 4)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Farmer Blogs',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2.0,
                          margin: EdgeInsets.only(right: 16.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Container(
                            width: 180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                  ),
                                  child: Center(child: Icon(Icons.article, size: 40, color: Colors.grey[600])),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Blog Title ${index + 1}',
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Short description of blog post ${index + 1}.',
                                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }    
  }
