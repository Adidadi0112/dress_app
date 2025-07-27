import 'package:dress_app/blocs/friends/friends_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:dress_app/auth/auth_gate.dart';
import 'package:dress_app/blocs/item/item_bloc.dart';
import 'package:dress_app/blocs/item/item_event.dart';
import 'package:dress_app/blocs/meetings/meetings_bloc.dart';
import 'package:dress_app/blocs/meetings/meetings_event.dart';
import 'package:dress_app/blocs/friends/friends_bloc.dart';
import 'package:dress_app/themes/theme_provider.dart';
import 'package:dress_app/widgets/bottom_navigator.dart';
import 'package:dress_app/services/firebase_auth_service.dart';
import 'package:dress_app/services/firestore_service.dart';
import 'package:dress_app/services/firestore_clothing_service.dart';
import 'package:dress_app/services/firestore_meetings_service.dart';
import 'package:dress_app/services/firebase_friends_service.dart';
import 'package:dress_app/services/firebase_storage_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ItemBloc>(create: (_) => ItemBloc()..add(FetchItems())),
        BlocProvider<MeetingsBloc>(
            create: (_) => MeetingsBloc()..add(LoadMeetings())),
        BlocProvider<FriendsBloc>(
            create: (_) => FriendsBloc()..add(LoadFriends())),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BottomAppBarOptionProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          Provider<FirebaseAuthService>(create: (_) => FirebaseAuthService()),
          Provider<FirestoreService>(create: (_) => FirestoreService()),
          Provider<FirestoreClothingService>(
              create: (_) => FirestoreClothingService()),
          Provider<FirestoreMeetingsService>(
              create: (_) => FirestoreMeetingsService()),
          Provider<FirebaseFriendsService>(
              create: (_) => FirebaseFriendsService()),
          Provider<FirebaseStorageService>(
              create: (_) => FirebaseStorageService()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discreet',
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}

// credentials login: t@t.pl password: Password12!
