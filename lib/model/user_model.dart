import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? role;
  final String? profile_pic;
  final String? names;
  final String? email;
  final String? contact;
  final String? address;
  final String? login;
  final String? fav_bible_verse;
  final String? date_created;
  final String? password;

  UserModel({
    this.id,
    this.role,
    this.profile_pic,
    this.names,
    this.email,
    this.contact,
    this.address,
    this.login,
    this.fav_bible_verse,
    this.date_created,
    this.password,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      id: snapshot['id'],
      role: snapshot['role'],
      profile_pic: snapshot['profile_pic'],
      names: snapshot['names'],
      email: snapshot['email'],
      contact: snapshot['contact'],
      address: snapshot['address'],
      login: snapshot['login'],
      fav_bible_verse: snapshot['fav_bible_verse'],
      date_created: snapshot['date_created'],
      password: snapshot['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "role": role,
        "profile_pic": profile_pic,
        "names": names,
        "email": email,
        "contact": contact,
        "address": address,
        "login": login,
        "fav_bible_verse": fav_bible_verse,
        "date_created": date_created,
        "password": password,
      };
}
