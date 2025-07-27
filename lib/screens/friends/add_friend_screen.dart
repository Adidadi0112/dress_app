import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/blocs/friends/friends_bloc.dart';
import 'package:dress_app/blocs/friends/friends_event.dart';
import 'package:dress_app/blocs/friends/friends_state.dart';
import 'package:dress_app/widgets/enhanced_card.dart';
import 'package:dress_app/widgets/modern_text_field.dart';
import 'package:dress_app/widgets/gradient_button.dart';
import 'package:dress_app/theme/tokens.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({Key? key}) : super(key: key);

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  Map<String, dynamic>? _foundUser;
  bool _isSearching = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _searchUser() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text.trim();
      setState(() {
        _isSearching = true;
        _foundUser = null;
      });

      context.read<FriendsBloc>().add(SearchUserByEmail(email));
    }
  }

  void _sendFriendRequest() {
    if (_foundUser != null) {
      context.read<FriendsBloc>().add(SendFriendRequest(_foundUser!['id']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friend'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: BlocListener<FriendsBloc, FriendsState>(
        listener: (context, state) {
          setState(() {
            _isSearching = false;
          });

          if (state is UserSearchResult) {
            setState(() {
              _foundUser = state.userData;
            });
          } else if (state is FriendsError) {
            setState(() {
              _foundUser = null;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          } else if (state is FriendRequestSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(SpacingTokens.space16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Search section
                EnhancedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(SpacingTokens.space20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Friend by Email',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: SpacingTokens.space8),
                        Text(
                          'Enter the email address of the person you want to add as a friend.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: SpacingTokens.space16),
                        ModernTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          prefixIcon: const Icon(Icons.email_outlined),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: SpacingTokens.space16),
                        SizedBox(
                          width: double.infinity,
                          child: _isSearching
                              ? ElevatedButton(
                                  onPressed: null,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text('Searching...'),
                                    ],
                                  ),
                                )
                              : GradientButton(
                                  onPressed: _searchUser,
                                  text: 'Search User',
                                  icon: Icons.search,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Search results section
                if (_foundUser != null) ...[
                  const SizedBox(height: SpacingTokens.space16),
                  EnhancedCard(
                    child: Padding(
                      padding: const EdgeInsets.all(SpacingTokens.space20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Found',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          const SizedBox(height: SpacingTokens.space16),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(RadiusTokens.radiusMd),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                backgroundImage:
                                    _foundUser!['profileImageUrl'] != null
                                        ? NetworkImage(
                                            _foundUser!['profileImageUrl'])
                                        : null,
                                child: _foundUser!['profileImageUrl'] == null
                                    ? Text(
                                        _foundUser!['name'].isNotEmpty
                                            ? _foundUser!['name'][0]
                                                .toUpperCase()
                                            : '?',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null,
                              ),
                              title: Text(
                                _foundUser!['name'] ?? 'Unknown User',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              subtitle: Text(
                                _foundUser!['email'] ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: SpacingTokens.space16),
                          SizedBox(
                            width: double.infinity,
                            child: GradientButton(
                              onPressed: _sendFriendRequest,
                              text: 'Send Friend Request',
                              icon: Icons.person_add,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: SpacingTokens.space24),

                // Instructions card
                EnhancedCard(
                  child: Padding(
                    padding: const EdgeInsets.all(SpacingTokens.space20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: SpacingTokens.space8),
                            Text(
                              'How it works',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: SpacingTokens.space12),
                        _buildInstructionStep(
                          context,
                          '1.',
                          'Enter your friend\'s email address',
                        ),
                        _buildInstructionStep(
                          context,
                          '2.',
                          'We\'ll search for users with that email',
                        ),
                        _buildInstructionStep(
                          context,
                          '3.',
                          'Send a friend request to connect',
                        ),
                        _buildInstructionStep(
                          context,
                          '4.',
                          'They\'ll receive a notification to accept or decline',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionStep(
      BuildContext context, String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingTokens.space8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: SpacingTokens.space12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
