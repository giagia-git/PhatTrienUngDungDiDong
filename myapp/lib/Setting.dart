import 'package:flutter/material.dart';
import 'ChatModel.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';


class Setting extends StatefulWidget {
  @override
  SettingState createState() => SettingState();
}

class SettingState extends State<Setting> {
  late Socket socket;
  
  @override
  void initState() {
    super.initState();

    if(mounted) {
        context.read<ChatModel>().init();
        socket = context.read<ChatModel>().socket;
    }
  }

  @override
  void dispose() {
    super.dispose();
          
    print("Setting dispose");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: IconButton(
            icon: Icon(Icons.back_hand),
            iconSize: 36,
            onPressed: () => {
              if(mounted) {
                context.read<ChatModel>().set_isLogin(false),
                context.read<ChatModel>().set_isFetchDataFromServer(false),
                context.read<ChatModel>().clear_AllUsers(),
                context.read<ChatModel>().clear_AllMessages(),
                print(context.read<ChatModel>().currentUser),
                print(context.read<ChatModel>().currentUser.getEmail),
                print(context.read<ChatModel>().currentUser.getChatID),
                socket.emit("leaveroom_currentUser",
                {
                  'email': context.read<ChatModel>().currentUser.getEmail,
                  'chatID': context.read<ChatModel>().currentUser.getChatID
                }
                ),
                Navigator.pop(context),
              },
            },
          )
        ),
      )
    );
  }
}