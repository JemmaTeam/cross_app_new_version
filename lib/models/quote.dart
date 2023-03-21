import 'package:jemma/enums/quote_status.dart';
import 'package:jemma/models/job_type.dart';
import 'package:jemma/models/tradie.dart';

import 'address.dart';
import 'customer.dart';

///  A quote which will be given by the tradie to the customer.
///
///  See https://miro.com/app/board/o9J_lJnBDec=/?moveToWidget=3074457357269825461&cot=14
class Quote{
  int id;
  Customer? customer;
  Tradie? tradie;
  String? customerSummary;
  String? customerDescription;
  JobType? jobType;
  Address? address;
  DateTime? timeStamp;
  double? price;
  QuoteStatus? status;
  String? notes;
  String? declineReason;

  Quote(this.id,[
    this.customer,
    this.tradie,
    this.jobType,
    this.customerDescription,
    this.customerSummary,
    this.address,
    this.status,
    this.price,
    this.timeStamp,
    this.notes,
    this.declineReason]);


  factory Quote.fromJson(json){
    if (json is int) {
      return Quote(json);
    } else{
      return Quote._fromJson(json);
    }
  }

  Quote._fromJson(Map<String, dynamic> json) :
        id =json["id"],
        tradie=json["tradie"]!= null ? Tradie.fromJson(json["tradie"]) : null,
        customer=json["customer"] !=null ? Customer.fromJson(json["customer"]) : null,
        jobType = json["job_type"]!=null ? JobType.fromJson(json["job_type"]) : null,
        address = json["address"] !=null ? Address.fromJson(json["address"]) : null ,
        timeStamp = json["time_stamp"] != null ? DateTime.parse(json["time_stamp"]) : null,
        price = json["price"] != null ? double.parse(json["price"].toString()): null,
        status = json["status"] != null ? parseQuoteStatusString(json["status"]): null,
        customerDescription = json["customer_description"],
        customerSummary = json["customer_summary"],
        notes = json["notes"],
        declineReason = json["decline_reason"];

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer": customer?.toJson(),
    "tradie": tradie?.toJson(),
    "job_type": jobType?.toJson(),
    "address": address?.toJson(),
    "date": timeStamp.toString(),
    "price": price.toString(),
    "status": status?.toSimpleString(),
    "customer_summary":customerSummary,
    "customer_description": customerDescription,
    "notes": notes,
    "decline_reason":declineReason

  };

  @override
  String toString() {
    return 'Quote{id: $id, customer: $customer, tradie: $tradie, customerSummary: $customerSummary, customerDescription: $customerDescription, jobType: $jobType, address: $address, timeStamp: $timeStamp, price: $price, status: $status, notes: $notes, declineReason: $declineReason}';
  }
}