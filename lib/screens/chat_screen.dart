import 'package:dress_app/widgets/bottom_navigator.dart';
import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isMe;

  const ChatMessage({required this.text, required this.isMe});
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  // Przykładowe dane do konwersacji
  final List<ChatMessage> _messages = const [
    ChatMessage(text: 'hi flutter!', isMe: false),
    ChatMessage(text: 'hi ronaldo!', isMe: true),
    ChatMessage(text: 'hi again', isMe: true),
    ChatMessage(text: 'okok', isMe: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Chatbot'),
        elevation: 1,
      ),
      body: Column(
        children: [
          // Lista wiadomości
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 8.0,
              ),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment:
                      msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    constraints: const BoxConstraints(maxWidth: 250),
                    decoration: BoxDecoration(
                      color: msg.isMe ? Colors.grey[300] : Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      msg.text,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          // Pole tekstowe i przycisk wysyłania
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 16.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                // Przykładowy przycisk wysyłania (tylko UI)
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF7D6CDA),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Tu wstawisz logikę wysyłania wiadomości
                    },
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBarMobileWidget(),
    );
  }
}
