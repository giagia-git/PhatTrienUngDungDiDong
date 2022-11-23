import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'User.dart';
import 'package:provider/provider.dart';
import 'ChatModel.dart';


class Registery extends StatefulWidget {
  const Registery({Key? key}) : super(key: key);

  @override
  RegisteryState createState() => RegisteryState();
}

class RegisteryState extends State<Registery> {
  final _formKey = GlobalKey<FormState>();
  late Socket socket;

  String email = "";
  String password = "";
  User user = new User();


  @override
  void initState() {
    super.initState();
    context.read<ChatModel>().init();
    socket = context.read<ChatModel>().socket;

    socket.on("Registery_Success", (res) => {
        print("Tài khoản đăng ký thành công")
    });
  }

  @override
  void dispose() {
    super.dispose();
          
    print("Registery dispose");
  }

  void submitForm_Registery() {
    socket.emit("User_Registery", {
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
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter your email",
                        ),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'Please input email';
                          }
                          email = value;
                          return null;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: "Enter your password",
                        ),
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'Please input password';
                          }
                          password = value;
                          return null;
                        },
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ElevatedButton(
                            onPressed: () => {
                              if(_formKey.currentState!.validate()) {
                                user.email=email,
                                user.password=password,
                                email='',
                                password='',
                                submitForm_Registery()
                              }
                            },
                          child: const Text("Đăng ký")),
                        )
                      ),
                      Center(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: ElevatedButton(
                              onPressed: () => {
                                  Navigator.pop(context)
                              },
                              child: const Text("Trở lại trang đăng nhập")
                            )
                        )
                      )
                ],
              )
            )
          )
        )
    );
  }
}