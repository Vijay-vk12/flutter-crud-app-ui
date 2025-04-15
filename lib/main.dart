import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reg_user_app/pages/edit_page.dart';
import 'package:reg_user_app/pages/register_page.dart';
import 'package:reg_user_app/pages/user_list_page.dart'; // <-- new page
void main() {
  runApp(
    kIsWeb
        ? DevicePreview(
            builder: (context) => MyApp(),
          )
        : MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Operation',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const UserListPage(), // <-- open list page first
      debugShowCheckedModeBanner: false,
      routes: {
  '/register': (context) => const RegisterPage(),
 // create this screen
},
    );
  }
}
