import 'package:flutter/widgets.dart';

class User {
  User({this.email,this.password,this.chatID});
  String? email;
  String? password;
  String? chatID;

  void displayUser() {
    print("\nEmail: ${email}\nchatID: ${chatID}");
  }

  get getEmail {
    return email;
  }

  get getChatID {
    return chatID;
  }

  factory User.fromJSON(Map<String,dynamic> json) {
    return User(
      email: json['email'],
      chatID: json['chatID']
    );
  }

  Map<String,dynamic> toJSON() => {
    'email': email,
    'chatID': chatID
  };

  
}