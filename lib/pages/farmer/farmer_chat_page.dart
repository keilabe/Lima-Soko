import 'package:flutter/material.dart';

class FarmerChatPage extends StatelessWidget {
  // Add a parameter to receive chat information
  final String chatId;
  const FarmerChatPage({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar is handled by FarmerHomePage
      body: Column(
        children: [
          // Display the chat ID or name for context
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Chat with: $chatId', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          // Placeholder for chat messages area
          Expanded(
            child: Center(
              child: Text('Chat messages will appear here'),
            ),
          ),
          // Placeholder for message input area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                FloatingActionButton(
                  onPressed: () {
                    // TODO: Implement send message logic
                  },
                  child: Icon(Icons.send),
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
      // BottomNavigationBar is handled by FarmerHomePage
    );
  }
} 