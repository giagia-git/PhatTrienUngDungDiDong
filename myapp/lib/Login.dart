import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'User.dart';
import 'ChatModel.dart';


class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late Socket socket;
  String email = "";
  String password = "";
  User user = new User();
  bool isLogin = false;

  @override
  void initState() {
    super.initState();

    if(mounted) {
      context.read<ChatModel>().init();
      socket = context.read<ChatModel>().socket;
    }

    socket.on("Login_Success", (res) => {
      print("Đăng nhập thành công"),
      if(mounted) {
        setState(() => {
          isLogin = true,
          context.read<ChatModel>().set_isLogin(true),
        }),
        Navigator.pushNamed(context,"/")
      }
      ,
    });
  }

  @override
  void dispose() {
      super.dispose();
      print("Login dispose");
  }

  void submit_Login() async {
    socket.emit("User_Login", 
    {
      'email': user.email,
      'password': user.password
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
                key: _formKey,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                              TextFormField(
                                autofocus: true,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "Enter your email",
                                ),
                                onChanged: (value) {
                                  email=value;
                                },
                                validator: (value) {
                                  if(value == null || value.isEmpty) {
                                    return 'Please input email';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                //(obscureText) hien thi text -> ***** 
                                obscureText: true,
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "Enter your password",
                                ),
                                onChanged: (value) {
                                    password = value;
                                },
                                validator: (value) {
                                  if(value == null || value.isEmpty) {
                                    return 'Please input password';
                                  }
                                  return null;
                                },
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                                  child: ElevatedButton(
                                    onPressed: () => {
                                      if(_formKey.currentState!.validate()) {
                                        if(mounted) {
                                          setState(() => {
                                            user.email=this.email,
                                            user.password=this.password,
                                          })
                                        },
                                        submit_Login()
                                      },
                                    },
                                  child: const Text("Đăng nhập")),
                                )
                              ),
                              Center(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: ElevatedButton(
                                      onPressed: () => {
                                          Navigator.pushNamed(context, '/registery'),
                                      },
                                      child: const Text("Đăng ký")
                                    )
                                )
                              )
                            ],
                          ),
                  )
                ),
      )
    );
  }
}