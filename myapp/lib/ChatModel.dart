import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart';
import 'User.dart';
import 'Message.dart';


class ChatModel extends ChangeNotifier {
  late Socket socket;
  List<User> users = [];
  User currentUser = User();
  List<User> friends = <User>[];
  List<Message> messages = <Message>[];
  List<Message> messagesDisplay = <Message>[];
  Message message = Message();
  bool isLogin = false;
  bool isFetchDataFromServer = false;

  void init() {

    socket = io("http://localhost:3000", <String,dynamic> {
          'transports': ['websocket'],
          'autoConnect': false,
    });

    if(isLogin && !isFetchDataFromServer) {
        try {
          fetchUsers().then((res) => {
              users.addAll(res),
              friends = users.where((user) => currentUser.getChatID != user.chatID).toList(),
              isFetchDataFromServer=true,
              notifyListeners()
          });

          fetchMessage().then((res) => {
            messages.addAll(res),
            notifyListeners()
          });
      }catch(err) {
        throw err;
      }
    }

    socket.on("receiveMessage",(res) => {
      message = Message(senderChatID: currentUser.getChatID,receiverChatID: res['receiverChatID'],content: res['content']),
      messages.add(message),
      notifyListeners(),
    });

    socket.connect();
  }

  void sendMessage(String text,String receiverChatID) {
      message = Message(senderChatID: currentUser.chatID,receiverChatID: receiverChatID,content: text);
      messages.add(message);
      socket.emit("newMessage", 
        {
            'senderChatID': currentUser.getChatID,
            'receiverChatID': receiverChatID,
            'content': text
        }
      );
      notifyListeners();
  }

  void set_currentUser(Map<String,dynamic> json) {
    currentUser.displayUser();
    currentUser = User.fromJSON(json);
    notifyListeners();
  }

  void set_isLogin(active) {
    isLogin=active;
    notifyListeners();
  }

  void set_isFetchDataFromServer(active) {
    isFetchDataFromServer=active;
    notifyListeners();
  }

  void clear_AllUsers() {
    users = [];
    notifyListeners();
  }

  void clear_AllMessages() {
    messages = [];
    notifyListeners();
  }

  List<Message> getMessagesForChatID(String chatID) {
    return messages.
    where((message) => message.senderChatID == chatID || message.receiverChatID == chatID).toList();
  }


  Future<List<User>> fetchUsers() async {
        final response = await http.get(Uri.parse("http://localhost:3000/users"),headers: {
          "Content-Type": "application/json"
        });
        if(response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          return jsonResponse.map<User>((json) => User.fromJSON(json)).toList();
        } else {
          throw Exception("Failed to load Users");
        }
  }

  Future<List<Message>> fetchMessage() async {
      final response = await http.get(Uri.parse("http://localhost:3000/users/messages",),headers: {
          "Content-Type": "application/json"
      });
      if(response.statusCode == 200) {
          if(!response.body.isEmpty) {
            // json.decode have to different empty
            final jsonResponse = json.decode(response.body);
            return jsonResponse.map<Message>((json) => Message.fromJSON(json)).toList();
          } else {
            return [];
          }
      } else {
        throw Error;
      }
  }
}