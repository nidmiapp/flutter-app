import 'dart:core';

class AccountInfo {
  String email;
  int user_id;
  String business_name;
  String business_title;
  String business_email;
  String business_website;
  String category;
  String sub_category;
  String expertise_list;
  int years_experience;
  String address;
  String mobile;
  String phone;
  double business_rate;
  double latitude;
  double longitude;
  bool registered;
  bool licensed;
  bool confirmed;
  DateTime service_expiry;
  DateTime created_ts;
  DateTime updated_ts;

  AccountInfo({
    this.email,
    this.user_id,
    this.business_name,
    this.business_title,
    this.business_email,
    this.business_website,
    this.category,
    this.sub_category,
    this.expertise_list,
    this.years_experience,
    this.address,
    this.mobile,
    this.phone,
    this.business_rate,
    this.latitude,
    this.longitude,
    this.registered,
    this.licensed,
    this.confirmed,
    this.service_expiry,
    this.created_ts,
    this.updated_ts
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json){
    if(json['created_ts']==null)
      json['created_ts'] = (new DateTime(2000,1,1).toString());
    if(json['updated_ts']==null)
      json['updated_ts'] = (new DateTime(2000,1,1).toString());
    if(json['service_expiry']==null)
      json['service_expiry'] = (new DateTime(2000,1,1).toString());
    return new AccountInfo(
        email : json['email'] ?? '',
        user_id : json['user_id'] ?? 0,
        business_name : json['business_name'] ?? '',
        business_title : json['business_title'] ?? '',
        business_email : json['business_email'] ?? '',
        business_website : json['business_website'] ?? '',
        category : json['category'] ?? '',
        sub_category : json['sub_category'] ?? '',
        expertise_list : json['expertise_list'] ?? '',
        years_experience : json['years_experience'] ?? 0,
        address : json['address'] ?? '',
        mobile : json['mobile'] ?? '',
        phone : json['phone'] ?? '',
        business_rate : json['business_rate'] ?? 0,
        latitude : json['latitude'] ?? 0,
        longitude : json['longitude'] ?? 0,
        registered : json['registered'] ?? false,
        licensed : json['licensed'] ?? false,
        confirmed : json['confirmed'] ?? false,
        service_expiry : DateTime.parse(json['service_expiry'].toString()) ?? null,
        created_ts : DateTime.parse(json['created_ts'].toString()) ?? null,
        updated_ts : DateTime.parse(json['updated_ts'].toString()) ?? null
    );
  }

}