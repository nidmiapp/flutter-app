import 'dart:core';

class Review {
  int review_id;
  String email;
  String by_whom_email;
  String by_whom_name;
  String review;
  int rate_star;
  DateTime created_ts;
  DateTime updated_ts;

  Review({
    this.review_id,
    this.email,
    this.by_whom_email,
    this.by_whom_name,
    this.review,
    this.rate_star,
    this.created_ts,
    this.updated_ts
  });

  factory Review.fromJson(Map<String, dynamic> json){
    if(json['created_ts']==null)
      json['created_ts'] = (new DateTime(2000,1,1).toString());
    if(json['updated_ts']==null)
      json['updated_ts'] = (new DateTime(2000,1,1).toString());
    return new Review(
        review_id : json['user_id'] ?? 0,
        email : json['email'] ?? '',
        by_whom_email : json['by_whom_email'] ?? '',
        by_whom_name : json['by_whom_name'] ?? '',
        review : json['review'] ?? '',
        rate_star : json['rate_star'] ?? 0,
        created_ts : DateTime.parse(json['created_ts'].toString()) ?? null,
        updated_ts : DateTime.parse(json['updated_ts'].toString()) ?? null
    );
  }

}