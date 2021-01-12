import 'dart:core';

class Chat {
  num chat_id;
  num reply_id;
  num owner_id;
  String text;
  DateTime created_ts;
  DateTime updated_ts;

  Chat({
    this.chat_id,
    this.reply_id,
    this.owner_id,
    this.text,
    this.created_ts,
    this.updated_ts
  });

  factory Chat.fromJson(Map<String, dynamic> json){
    if(json['created_ts']==null)
      json['created_ts'] = (new DateTime(2000,1,1).toString());
    if(json['updated_ts']==null)
      json['updated_ts'] = (new DateTime(2000,1,1).toString());
    return new Chat(
        chat_id : json['chat_id'] ?? '',
        reply_id : json['reply_id'] ?? '',
        owner_id : json['owner_id'] ?? '',
        text : json['text'] ?? '',
      created_ts : DateTime.parse(json['created_ts'].toString()) ?? null,
      updated_ts : DateTime.parse(json['updated_ts'].toString()) ?? null
    );
  }

}