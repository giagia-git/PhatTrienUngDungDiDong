// child: FutureBuilder<List<Cards>>(
            //     future: _dataFuture,
            //     builder: (BuildContext context,AsyncSnapshot snapshot) {
            //       if(snapshot.hasError) {
            //         return Center(
            //           child: Text("Error")
            //         );
            //       } else if(snapshot.hasData){
            //         return ListView.builder(
            //           itemCount: snapshot.data.length,
            //           itemBuilder: ((context, index) {
            //                 return Consumer<ChatModel>(
            //                   builder: (context,model,child) {
            //                     return Text("${model.users[index].email}");
            //                     // return Card(
            //                     //     child: ListTile(
            //                     //         leading: FlutterLogo(size: 50),
            //                     //         title: Text("${snapshot.data![index].email}"),
            //                     //         subtitle: Text("Tin nhan"),
            //                     //         trailing: Column(
            //                     //           children: <Widget>[
            //                     //               Text(now.year.toString()+"/"+now.month.toString()+"/"+now.day.toString()),
            //                     //               Text("${model.currentUser}")
            //                     //           ]
            //                     //         ),
            //                     //         onTap: () => {
            //                     //               socket.emit("selected_User",
            //                     //                   json.encode(
            //                     //                     {
            //                     //                       'email': snapshot.data![index].email,
            //                     //                       'chatID': snapshot.data![index].chatID
            //                     //                     }
            //                     //                   )
            //                     //               ),
            //                     //               Navigator.pushNamed(context,"/chat")
            //                     //         },
            //                     //     )
            //                     // );
            //                   }
            //                 );
            //           }),
            //         );
            //       } else {
            //         return Center(
            //           child: Container()
            //         );
            //       }
            //     },
            //   ),
            ),