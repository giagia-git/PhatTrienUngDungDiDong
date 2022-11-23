class Message {
  Message({this.senderChatID,this.receiverChatID,this.content});
  String? senderChatID;
  String? receiverChatID;
  String? content;

  factory Message.fromJSON(Map<String,dynamic> json) {
    return Message(
        senderChatID: json['senderChatID'],
        receiverChatID: json['receiverChatID'],
        content: json['content']
    );
  }

  Map<String,dynamic> toJSON() => {
      'senderChatID': senderChatID,
      'receiverChatID': receiverChatID,
      'content': content
  };

  void displayMessage() {
    print("${senderChatID} -> ${content} -> ${receiverChatID}");
  }
}