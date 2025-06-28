import 'dart:ui';

import 'package:dress_app/screens/account_screen.dart';
import 'package:dress_app/screens/chat_screen.dart';
import 'package:dress_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomAppBarMobileWidget extends StatefulWidget {
  const BottomAppBarMobileWidget({super.key});

  @override
  BottomAppBarMobileWidgetState createState() =>
      BottomAppBarMobileWidgetState();
}

class BottomAppBarMobileWidgetState extends State<BottomAppBarMobileWidget> {
  @override
  Widget build(BuildContext context) {
    final optionIndexModel = Provider.of<BottomAppBarOptionProvider>(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.5), Colors.transparent],
        ),
      ),
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: ShapeDecoration(
              color: const Color(0x7FDDDDDD).withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23.81),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23.81),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    option("Menu", () {
                      setState(() {
                        optionIndexModel.selectOption(0);
                      });
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    }, optionIndexModel.selectedOptionIndex == 0),
                    option("Chat", () {
                      setState(() {
                        optionIndexModel.selectOption(1);
                      });
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChatScreen(),
                        ),
                      );
                    }, optionIndexModel.selectedOptionIndex == 1),
                    option("Account", () {
                      setState(() {
                        optionIndexModel.selectOption(2);
                      });
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AccountScreen(),
                        ),
                      );
                    }, optionIndexModel.selectedOptionIndex == 2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget option(String name, Function() onPressed, bool isChosen) {
  return Container(
    height: 35,
    decoration: isChosen
        ? ShapeDecoration(
            color: Color(0xFF7D6CDA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(23.81),
            ),
          )
        : null,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            onPressed();
          },
          child: Text(
            name,
            style: TextStyle(
              color: !isChosen ? Colors.black : Colors.white,
              fontSize: 12.40,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0.11,
            ),
          ),
        ),
      ],
    ),
  );
}

class BottomAppBarOptionProvider extends ChangeNotifier {
  int _selectedOptionIndex = 0;

  int get selectedOptionIndex => _selectedOptionIndex;

  void selectOption(int optionIndex) {
    _selectedOptionIndex = optionIndex;
    notifyListeners();
  }
}
