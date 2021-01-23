import 'dart:core';

class Device {
  int device_id;
  int owner_id;
  String device_unique_id;
  String token;
  String device_type;
  bool activated;
  DateTime created_ts;
  DateTime updated_ts;

  Device({
    this.device_id,
    this.owner_id,
    this.device_unique_id,
    this.token,
    this.device_type,
    this.activated,
    this.created_ts,
    this.updated_ts
  });

  factory Device.fromJson(Map<String, dynamic> json){
    if(json['created_ts']==null)
      json['created_ts'] = (new DateTime(2000,1,1).toString());
    if(json['updated_ts']==null)
      json['updated_ts'] = (new DateTime(2000,1,1).toString());
    return new Device(
        device_id : json['device_id'] ?? '',
        owner_id : json['owner_id'] ?? 0,
        device_unique_id : json['device_unique_id'] ?? '',
        token : json['token'] ?? '',
        device_type : json['device_type'] ?? '',
        activated : json['activated'] ?? false,
      created_ts : DateTime.parse(json['created_ts'].toString()) ?? null,
      updated_ts : DateTime.parse(json['updated_ts'].toString()) ?? null
    );
  }

}