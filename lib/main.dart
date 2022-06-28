import 'package:amazon_clone_tutorial/constants/global_variables.dart';
import 'package:amazon_clone_tutorial/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone_tutorial/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.primaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ), 
        ),
      ),
      // Runs every time we run pushNamed routes
      // We use it to pass parameters to routes
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const AuthScreen(),
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Amazon Clone'),
      //   ),
      //   body: Column(
      //     children: [
      //      const Center(child: Text('Flutter Demo Home Page')),
      //      Builder(
      //        builder: (context) {
      //          return ElevatedButton(
      //            child: const Text('Click'),
      //            onPressed: () {
      //             Navigator.pushNamed(context, AuthScreen.routeName);
      //            },
      //          );
      //        }
      //      ),
      //     ]
      //   ),
      // ) 
    );
  }
}
