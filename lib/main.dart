import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'features/pretentation/home/home_cubit.dart';
import 'features/pretentation/home/home_screen.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'SFPro',
          scaffoldBackgroundColor: Colors.black,
        ),
        debugShowCheckedModeBanner: false,
        /*home: BlocProvider(
          create: (context) => locator<HomeCubit>(),
          child: HomeScreen(),
        ),*/
        initialRoute: '/',
        routes: {
          '/': (context) => BlocProvider(
            create: (context) => locator<HomeCubit>(),
            child: HomeScreen(),
          ),
        },
      ),
    );
  }
}