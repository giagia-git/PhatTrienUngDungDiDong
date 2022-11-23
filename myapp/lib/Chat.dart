import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:http/http.dart' as http;
import 'ChatModel.dart';

import 'package:myapp/User.dart';
import 'package:myapp/Message.dart';

class Chat extends StatefulWidget {
  final User friend;
  Chat(this.friend);
  @override
  ChatState createState() => ChatState();
}


class ChatState extends State<Chat> {
  final TextEditingController textEditingController = TextEditingController();
  Message message = Message();

  late Socket socket;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if(mounted) {
          context.read<ChatModel>().init();
          socket = context.read<ChatModel>().socket;

          print("ChatPage");
          widget.friend.displayUser();
    }
    SchedulerBinding.instance.addPostFrameCallback((_) => scrollToEnd());
  }
  @override
  void dispose() {
      super.dispose();
      print("Chat dispose");
  }

  void scrollToEnd() async {
    print(_scrollController.position.maxScrollExtent.toString());
    await _scrollController.animateTo(_scrollController.position.maxScrollExtent,duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  Widget buildSingleMessage(Message message) {
    return Container(
      alignment: message.senderChatID == widget.friend.chatID
            ? Alignment.centerLeft
            : Alignment.centerRight,
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      child: Text(message.content.toString()),
    );
  }

  Widget buildChatList() {
    return Consumer<ChatModel>(
      builder: (context,model,child) {
        List<Message> messages = model.getMessagesForChatID(widget.friend.chatID.toString()).toList();
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          color: Color.fromARGB(255, 235, 234, 230),
          child: ListView.builder(
            controller: _scrollController,
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return buildSingleMessage(messages[index]);
            }
          )
        );
      }
    );
  }

  Widget buildChatArea() {
    return Consumer<ChatModel>(
      builder: (context,model,child) {
        return Container(
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: textEditingController,
                ),
              ),
              SizedBox(width: 10),
              FloatingActionButton(
                onPressed: (() => {
                    if(mounted) {
                        context.read<ChatModel>().sendMessage(textEditingController.text,widget.friend.chatID.toString()),
                        // textEditingController.text = '',
                        socket.emit("newMessage", 
                          {
                              'senderChatID': model.currentUser.getChatID,
                              'receiverChatID': widget.friend.chatID,
                              'content': textEditingController.text
                          }
                        ),
                    },

                    SchedulerBinding.instance.addPostFrameCallback((_) => scrollToEnd())
                }),
                elevation: 0,
                child: Icon(Icons.send)
              )
            ],
          )
        );
      }
    );
  }

  @override 
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 64, 82, 70),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
              iconSize: 24,
              onPressed: () => {
                  Navigator.pop(context)
              },
          ),
          title: Text(widget.friend.email.toString()),
          actions: []
        ),
        body: ListView(
          children: <Widget>[
              buildChatList(),
              buildChatArea()
          ]
        ),
      )
    );
  }
}
