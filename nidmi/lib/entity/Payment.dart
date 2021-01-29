import 'dart:core';

class Payment {
  int payment_id;
  String email;
  int card_type;
  String card_number;
  String card_expiry;
  int card_vin;
  int discount_percent;
  double amount;
  double bill_amount;
  bool refund;
  DateTime created_ts;
  DateTime updated_ts;

  Payment({
    this.payment_id,
    this.email,
    this.card_type,
    this.card_number,
    this.card_expiry,
    this.card_vin,
    this.discount_percent,
    this.amount,
    this.bill_amount,
    this.refund,
    this.created_ts,
    this.updated_ts
  });

  factory Payment.fromJson(Map<String, dynamic> json){
    if(json['created_ts']==null)
      json['created_ts'] = (new DateTime(2000,1,1).toString());
    if(json['updated_ts']==null)
      json['updated_ts'] = (new DateTime(2000,1,1).toString());
    return new Payment(
        payment_id : json['payment_id'] ?? 0,
        email : json['email'] ?? '',
        card_type : json['card_type'] ?? 0,
        card_number : json['card_number'] ?? '',
        card_expiry : json['card_expiry'] ?? '',
        card_vin : json['card_vin'] ?? 0,
        discount_percent : json['discount_percent'] ?? 0,
        amount : json['amount'] ?? 0,
        bill_amount : json['bill_amount'] ?? 0,
        refund : json['address'] ?? false,
        created_ts : DateTime.parse(json['created_ts'].toString()) ?? null,
        updated_ts : DateTime.parse(json['updated_ts'].toString()) ?? null
    );
  }

}