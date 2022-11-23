import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:provider/provider.dart';

import 'Home.dart';
import 'Login.dart';
import 'Registery.dart';
import 'Chat.dart';
import 'Setting.dart';
import 'RouteRec.dart';
import 'ChatModel.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatModel(),
      child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context ) {
    return MaterialApp(
        initialRoute: '/login',
        routes: {
          '/': (context) => RouteRec(),
          '/login': (context) => Login(),
          '/registery': (context) => Registery(),
        },
    );
  }
}

