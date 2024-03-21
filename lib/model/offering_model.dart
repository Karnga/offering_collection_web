import 'package:cloud_firestore/cloud_firestore.dart';

class OfferingModel {
  final String? id;
  final String? email;
  final String offeringType;
  final String? amount;
  final String? paymentMethod;
  final String? date;
  final String? number;

  // OfferingModel._({this.offeringType, this.amount, this.paymentMethod, this.date, this.id, this.email});

  OfferingModel({
    this.email,
    this.paymentMethod, 
    required this.offeringType, 
    this.amount, 
    this.id,
    this.date,
    this.number,
    });

  factory OfferingModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return OfferingModel(
      id: snapshot['id'],
      email: snapshot['email'],
      offeringType: snapshot['offeringType'],
      amount: snapshot['amount'],
      paymentMethod: snapshot['paymentMethod'],
      date: snapshot['date'],
      number: snapshot['number'],
    );
  }

  factory OfferingModel.fromDoc(offerings) {
    return OfferingModel(
            //fill in the fields
            id: offerings.id,
            email: offerings.get("email"),
            offeringType: offerings.get("offeringType"),
            paymentMethod: offerings.get("paymentMethod"),
            amount: offerings.get("amount"),
            date: offerings.get("date"),
            number: offerings.get("number"),
         );
}

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "offeringType": offeringType,
        "amount": amount,
        "paymentMethod": paymentMethod,
        "date": date,
  };

  // factory OfferingModel.fromJson(Map<String, dynamic> json) {
  //   return OfferingModel._(
  //     id: json['id'],
  //     email: json['email'],
  //     offeringType: json['offeringType'],
  //     amount: json['amount'],
  //     paymentMethod: json['paymentMethod'],
  //     date: json['date'],
  //   );
  // }
}
