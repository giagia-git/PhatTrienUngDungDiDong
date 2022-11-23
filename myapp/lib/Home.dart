import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:myapp/User.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:http/http.dart' as http;

import 'Chat.dart';
import 'ChatModel.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
    static final now = DateTime.now();
    late Socket socket;

    @override
    void initState() {
      super.initState();

      if(mounted) {
        context.read<ChatModel>().init();
        socket = context.read<ChatModel>().socket;
      }
        
      socket.on("Login_Success", (resFromServer) => {
        print(resFromServer),
        if(mounted) {
          context.read<ChatModel>().set_currentUser(resFromServer),
          socket.emit("joinRoom_currentUser",resFromServer),
        }
      });
    }

    @override
    void dispose() {
          super.dispose();
          
          print("Home dispose");
    }

    void friendClicked(User friend) {
      print(friend);
      if(mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Chat(friend);
            }
          )
        );
      }
    }

    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: Scaffold(
          body: Container(
            child: Consumer<ChatModel>(
              builder: (context,model,child) {
                return ListView.builder(
                    itemCount: model.friends.length,
                    itemBuilder: (context, index) {
                      User friend = model.friends[index];
                      return ListTile(
                        title: Text(friend.email.toString()),
                        onTap: () => {
                          friendClicked(friend)
                        }
                      );
                    },  
                );
              }
            )
          ),
        ),
      );
    }
}