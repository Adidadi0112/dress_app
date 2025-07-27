import 'dart:ui';

import 'package:dress_app/screens/account_screen.dart';
import 'package:dress_app/screens/chat_screen.dart';
import 'package:dress_app/screens/home.dart';
import 'package:dress_app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomAppBarMobileWidget extends StatefulWidget {
  const BottomAppBarMobileWidget({super.key});

  @override
  BottomAppBarMobileWidgetState createState() =>
      BottomAppBarMobileWidgetState();
}

class BottomAppBarMobileWidgetState extends State<BottomAppBarMobileWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final optionIndexModel = Provider.of<BottomAppBarOptionProvider>(context);
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(SpacingTokens.space16),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusTokens.radiusCircular),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(RadiusTokens.radiusCircular),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.8),
                borderRadius:
                    BorderRadius.circular(RadiusTokens.radiusCircular),
                border: Border.all(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    context: context,
                    icon: Icons.home_rounded,
                    index: 0,
                    isSelected: optionIndexModel.selectedOptionIndex == 0,
                    onTap: () {
                      _animateSelection();
                      optionIndexModel.selectOption(0);
                      _navigateToScreen(const HomeScreen(), 0);
                    },
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.chat_bubble_rounded,
                    index: 1,
                    isSelected: optionIndexModel.selectedOptionIndex == 1,
                    onTap: () {
                      _animateSelection();
                      optionIndexModel.selectOption(1);
                      _navigateToScreen(const ChatScreen(), 1);
                    },
                  ),
                  _buildNavItem(
                    context: context,
                    icon: Icons.person_rounded,
                    index: 2,
                    isSelected: optionIndexModel.selectedOptionIndex == 2,
                    onTap: () {
                      _animateSelection();
                      optionIndexModel.selectOption(2);
                      _navigateToScreen(const AccountScreen(), 2);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _animateSelection() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  void _navigateToScreen(Widget screen, int index) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Combine slide and fade animations
          const begin = Offset(0.0, 0.1);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          var slideAnimation = animation.drive(tween);

          var fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
          ));

          var scaleAnimation = Tween<double>(
            begin: 0.95,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack,
          ));

          return SlideTransition(
            position: slideAnimation,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isSelected ? _scaleAnimation.value : 1.0,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(RadiusTokens.radiusLg),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: isSelected ? 50 : 40,
                      height: isSelected ? 50 : 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        borderRadius:
                            BorderRadius.circular(RadiusTokens.radiusLg),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        icon,
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                        size: isSelected ? 24 : 22,
                      ),
                    ),
                    const SizedBox(height: 2),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isSelected ? 6 : 0,
                      height: 2,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BottomAppBarOptionProvider extends ChangeNotifier {
  int _selectedOptionIndex = 0;

  int get selectedOptionIndex => _selectedOptionIndex;

  void selectOption(int optionIndex) {
    _selectedOptionIndex = optionIndex;
    notifyListeners();
  }
}
