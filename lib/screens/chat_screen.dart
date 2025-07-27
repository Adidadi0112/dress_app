import 'package:dress_app/widgets/bottom_navigator.dart';
import 'package:dress_app/widgets/enhanced_card.dart';
import 'package:dress_app/widgets/modern_text_field.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:dress_app/theme/responsive.dart';
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
        title: Text(
          'Style Assistant',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              padding: ResponsiveHelper.getResponsivePadding(context),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: SpacingTokens.space12),
                  child: Row(
                    mainAxisAlignment: msg.isMe
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!msg.isMe) ...[
                        Container(
                          padding: const EdgeInsets.all(SpacingTokens.space8),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.assistant,
                            size: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(width: SpacingTokens.space8),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(SpacingTokens.space12),
                          decoration: BoxDecoration(
                            color: msg.isMe
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius:
                                BorderRadius.circular(RadiusTokens.radiusLg),
                          ),
                          child: Text(
                            msg.text,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: msg.isMe
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                ),
                          ),
                        ),
                      ),
                      if (msg.isMe) ...[
                        const SizedBox(width: SpacingTokens.space8),
                        Container(
                          padding: const EdgeInsets.all(SpacingTokens.space8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 16,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          // Input area
          EnhancedCard(
            child: Row(
              children: [
                Expanded(
                  child: ModernTextField(
                    hintText: 'Ask me about fashion...',
                    prefixIcon: const Icon(Icons.chat_bubble_outline),
                    maxLines: 1,
                  ),
                ),
                const SizedBox(width: SpacingTokens.space8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
                  ),
                  child: IconButton(
                    onPressed: () {
                      // TODO: Implement send message logic
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
