import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  final String? role;
  final String? email;

  AdminModel({
    this.role,
    this.email,
  });

  factory AdminModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return AdminModel(
      role: snapshot['role'],
      email: snapshot['email'],
    );
  }

  Map<String, dynamic> toJson() => {
        "role": role,
        "email": email,
      };
}
