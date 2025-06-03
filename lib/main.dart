import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dress_app/auth/login_or_register.dart';
import 'package:dress_app/blocs/item/item_bloc.dart';
import 'package:dress_app/blocs/item/item_event.dart';
import 'package:dress_app/blocs/outings/outings_bloc.dart';
import 'package:dress_app/themes/theme_provider.dart';
import 'package:dress_app/widgets/bottom_navigator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ItemBloc>(create: (_) => ItemBloc()..add(FetchItems())),
        BlocProvider<OutingsBloc>(
            create: (_) => OutingsBloc()..add(LoadOutings())),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BottomAppBarOptionProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
      home: const LoginOrRegister(),
    );
  }
}
