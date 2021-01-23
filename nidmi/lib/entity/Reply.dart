import 'dart:core';

class Reply {
  int reply_id;
  int request_id;
  int supplier_id;
  String supplier_name;
  String title;
  DateTime created_ts;
  DateTime updated_ts;

  Reply({
    this.reply_id,
    this.request_id,
    this.supplier_id,
    this.supplier_name,
    this.title,
    this.created_ts,
    this.updated_ts
  });

  factory Reply.fromJson(Map<String, dynamic> json){
    if(json['created_ts']==null)
      json['created_ts'] = (new DateTime(2000,1,1).toString());
    if(json['updated_ts']==null)
      json['updated_ts'] = (new DateTime(2000,1,1).toString());
    return new Reply(
        reply_id : json['reply_id'] ?? '',
        request_id : json['request_id'] ?? '',
        supplier_id : json['supplier_id'] ?? 0,
        supplier_name : json['supplier_name'] ?? '',
        title : json['title'] ?? '',
      created_ts : DateTime.parse(json['created_ts'].toString()) ?? null,
      updated_ts : DateTime.parse(json['updated_ts'].toString()) ?? null
    );
  }

}