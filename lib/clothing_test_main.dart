import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:dress_app/blocs/clothing_item/clothing_item_bloc.dart';
import 'package:dress_app/blocs/clothing_item/clothing_item_event.dart';
import 'package:dress_app/screens/clothing_wardrobe_screen.dart';
import 'package:dress_app/services/firebase_auth_service.dart';
import 'package:dress_app/services/firestore_clothing_service.dart';
import 'package:dress_app/services/firebase_storage_service.dart';
import 'package:dress_app/themes/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ClothingTestApp());
}

class ClothingTestApp extends StatelessWidget {
  const ClothingTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ClothingItemBloc>(
          create: (_) => ClothingItemBloc()..add(LoadClothingItems()),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
          Provider<FirestoreClothingService>(
              create: (_) => FirestoreClothingService()),
          Provider<FirebaseStorageService>(
              create: (_) => FirebaseStorageService()),
        ],
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return MaterialApp(
              title: 'Clothing Items Test',
              theme: themeProvider.themeData,
              debugShowCheckedModeBanner: false,
              home: const ClothingWardrobeScreen(),
            );
          },
        ),
      ),
    );
  }
}
