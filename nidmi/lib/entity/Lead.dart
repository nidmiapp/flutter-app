import 'dart:core';

import 'dart:ffi';

import 'package:nidmi/entity/Request.dart';

class Lead {
  num request_id;
  num owner_id;
  String category;
  String sub_category;
  double latitude;
  double longitude;
  String title;
  String media;
  bool confirmed;
  DateTime created_ts;
  DateTime updated_ts;

  Lead({
    this.request_id,
    this.owner_id,
    this.category,
    this.sub_category,
    this.latitude,
    this.longitude,
    this.title,
    this.media,
    this.confirmed,
    this.created_ts,
    this.updated_ts
  });

  copyRequest (Request req) {
    this.request_id = req.request_id;
    this.owner_id = req.owner_id;
    this.category = req.category;
    this.sub_category = req.sub_category;
    this.latitude = req.latitude;
    this.longitude = req.longitude;
    this.title = req.title;
    this.media = req.media;
    this.created_ts = req.created_ts;
    this.updated_ts = req.updated_ts;
  }

  factory Lead.fromJson(Map<String, dynamic> json){
    if(json['created_ts']==null)
      json['created_ts'] = (new DateTime(2000,1,1).toString());
    if(json['updated_ts']==null)
      json['updated_ts'] = (new DateTime(2000,1,1).toString());
    return new Lead(
        request_id : json['request_id'] ?? '',
        owner_id : json['owner_id'] ?? 0,
        category : json['category'] ?? '',
        sub_category : json['sub_category'] ?? '',
        latitude : json['latitude'] ?? '',
        longitude : json['longitude'] ?? '',
        title : json['title'] ?? '',
        media : json['media'] ?? '',
        confirmed : json['confirmed'] ?? false,
      created_ts : DateTime.parse(json['created_ts'].toString()) ?? null,
      updated_ts : DateTime.parse(json['updated_ts'].toString()) ?? null
    );
  }

}