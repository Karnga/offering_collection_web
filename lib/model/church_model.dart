import 'package:cloud_firestore/cloud_firestore.dart';

class ChurchModel {
  final String? id;
  final String? logo;
  final String? name;
  final String? email;
  final String? contact;
  final String? location;
  final String? login;
  final String? password;
  final String? role;

  ChurchModel({
    this.id,
    this.role,
    this.logo,
    this.name,
    this.email,
    this.contact,
    this.location,
    this.login,
    this.password,
  });

  factory ChurchModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ChurchModel(
      id: snapshot['id'],
      role: snapshot['role'],
      logo: snapshot['logo'],
      name: snapshot['name'],
      email: snapshot['email'],
      contact: snapshot['contact'],
      location: snapshot['location'],
      login: snapshot['login'],
      password: snapshot['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "logo": logo,
        "name": name,
        "email": email,
        "contact": contact,
        "location": location,
        "login": login,
        "password": password,
      };
}
