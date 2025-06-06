import 'package:flutter/material.dart';
import 'package:lima_soko/pages/farmer/farmer_chat_page.dart'; // Import the chat detail page

class FarmerChatListPage extends StatelessWidget {
  const FarmerChatListPage({super.key});

  // Placeholder data for chat list
  final List<Map<String, String>> chats = const [
    {'name': 'John Doe', 'lastMessage': 'Hi, is the produce fresh?', 'time': '10:30 AM'},
    {'name': 'Jane Smith', 'lastMessage': 'What is the price per kg?', 'time': 'Yesterday'},
    {'name': 'Farm Buyer 1', 'lastMessage': 'Ready to order', 'time': 'Mon'},
    {'name': 'Farm Buyer 2', 'lastMessage': 'See you tomorrow', 'time': 'Sun'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar is handled by FarmerHomePage
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: CircleAvatar(
              // Placeholder for user profile picture
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[600]),
            ),
            title: Text(chat['name'] ?? ''),
            subtitle: Text(chat['lastMessage'] ?? ''),
            trailing: Text(chat['time'] ?? ''),
            onTap: () {
              // Navigate to the chat detail page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FarmerChatPage(chatId: chat['name'] ?? 'unknown_chat'),
                ),
              );
            },
          );
        },
      ),
      // BottomNavigationBar is handled by FarmerHomePage
    );
  }
} 