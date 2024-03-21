import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:offering_collection_web/model/admin_model.dart';
import 'package:offering_collection_web/model/church_model.dart';
import 'package:offering_collection_web/model/offering_model.dart';
import 'package:offering_collection_web/model/user_model.dart';

final currentUser = FirebaseAuth.instance.currentUser!;
dynamic image;
late String fileName;
String imageLink = '';

class FirestoreHelper {

  static Stream<List<ChurchModel>> readChurch() {
    final churchCollection = FirebaseFirestore.instance.collection("Churches");
    return churchCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ChurchModel.fromSnapshot(e)).toList());
  }

  static Stream<List<UserModel>> readUser() {
    final userCollection = FirebaseFirestore.instance.collection("Users");
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  static Stream<List<ChurchModel>> readSingleChurch() {
    var churchCollection = FirebaseFirestore.instance.collection("Churches");
     var church = churchCollection.where("email", isEqualTo: currentUser.email);
    return church.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ChurchModel.fromSnapshot(e)).toList());
  }

  static Stream<List<ChurchModel>> singleChurchMember() {
    var churchCollection = FirebaseFirestore.instance.collection("Offerings");
     var church = churchCollection.where("church_id", isEqualTo: currentUser.email);
    return church.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => ChurchModel.fromSnapshot(e)).toList());
  }

  // var churchId = readSingleChurch().church_id.toString();

  static Stream<List<OfferingModel>> churchOffering() {
    final offeringCollection =
        FirebaseFirestore.instance.collection("Offerings");

    var offerings = offeringCollection.where("church_id", isEqualTo: "");

    return offeringCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => OfferingModel.fromSnapshot(e)).toList());
  }

  static Stream<List<OfferingModel>> readOffering() {
    final offeringCollection =
        FirebaseFirestore.instance.collection("Offerings");
    return offeringCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => OfferingModel.fromSnapshot(e)).toList());
  }

  

  static Future createChurch(ChurchModel church) async {
    final churchCollection =
        FirebaseFirestore.instance.collection("Churches");

    final cid = churchCollection.doc().id;
    final docRef = churchCollection.doc(cid);

    final newChurch = ChurchModel(
      id: cid,
      role: church.role,
      logo: church.logo,
      name: church.name,
      email: church.email,
      contact: church.contact,
      location: church.location,
      login: church.login,
      password: church.password,
    ).toJson();

    try {
      // await docRef.set(newChurch);
      await FirebaseFirestore.instance.collection("Churches").doc(church.email).set(newChurch);
    } catch (e) {
      print("some error occured $e");
    }
  }

    static Future createAdmin( admin) async {
    final adminCollection =
        FirebaseFirestore.instance.collection("Administrators");

    final cid = adminCollection.doc().id;
    final docRef = adminCollection.doc(cid);

    final newAdmin = AdminModel(
      role: admin.role,
      email: admin.email,
    ).toJson();

    try {
      // await docRef.set(newadmin);
      await FirebaseFirestore.instance.collection("Administrators").doc(admin.email).set(newAdmin);
    } catch (e) {
      print("some error occured $e");
    }
  }

  static Future createUser(UserModel user) async {
    final churchCollection =
        FirebaseFirestore.instance.collection("Users");

    final newUser = UserModel(
      // id: cid,
      role: "ch_admin",
      // logo: church.logo,
      names: user.names,
      email: user.email,
      contact: user.contact,
      address: user.address,
      login: user.login,
      password: user.password,
    ).toJson();

    try {
      await FirebaseFirestore.instance.collection("Users").doc(user.email).set(newUser);
    } catch (e) {
      print("some error occured $e");
    }
  }

  // static Future create(ChurchModel church) async {
  //   final offeringCollection =
  //       FirebaseFirestore.instance.collection("Churches");
  //   final oid = offeringCollection.doc().id;
  //   final docRef = offeringCollection.doc(oid);
  //   final newOffering = ChurchModel(
  //     id: oid,
  //     name: church.name,
  //     email: church.email,
  //     contact: church.contact,
  //     location: church.location,
  //     login: church.login,
  //     password: church.password,
  //   ).toJson();
  //   try {
  //     await docRef.set(newOffering);
  //   } catch (e) {
  //     print("some error occured $e");
  //   }
  // }

  static Future updateChurch(ChurchModel church) async {
    final churchCollection = FirebaseFirestore.instance.collection("Churches");

    final docRef = churchCollection.doc(church.email);

    final newChurch = ChurchModel(
      // id: church.id,
      logo: church.logo,
      name: church.name,
      email: church.email,
      contact: church.contact,
      location: church.location,
      login: church.login,
      password: church.password,
    ).toJson();

    try {
      await docRef.update(newChurch);
    } catch (e) {
      print("some error occured $e");
    }
  }

  static Future updateUser(UserModel user) async {
    final userCollection = FirebaseFirestore.instance.collection("Users");

    final docRef = userCollection.doc(user.email);

    final newUser = UserModel(
      // id: user.id,
      profile_pic: user.profile_pic,
      names: user.names,
      email: user.email,
      contact: user.contact,
      address: user.address,
      fav_bible_verse: user.fav_bible_verse,
      date_created: user.date_created,
      // password: user.password,
    ).toJson();

    try {
      await docRef.update(newUser);
    } catch (e) {
      print("some error occured $e");
    }
  }

  // static Future update(ChurchModel church) async {
  //   final offeringCollection =
  //       FirebaseFirestore.instance.collection("Offerings");
  //   final docRef = offeringCollection.doc(church.id);
  //   final newOffering = ChurchModel(
  //     id: church.id,
  //     name: church.name,
  //     email: church.email,
  //     contact: church.contact,
  //     location: church.location,
  //     login: church.login,
  //     password: church.password,
  //   ).toJson();
  //   try {
  //     await docRef.update(newOffering);
  //   } catch (e) {
  //     print("some error occured $e");
  //   }
  // }

  static Future deleteChurch(ChurchModel church) async {
    final churchCollection = FirebaseFirestore.instance.collection("Churches");
    final docRef = churchCollection.doc(church.email).delete();
  }

  static Future deleteMember(UserModel user) async {
    final userCollection = FirebaseFirestore.instance.collection("Users");
    final docRef = userCollection.doc(user.email).delete();
  }

  static Future deleteOffering(OfferingModel offering) async {
    final offeringCollection =
        FirebaseFirestore.instance.collection("Offerings");
    final docRef = offeringCollection.doc(offering.id).delete();
  }

  Future<String> _uploadFile() async {
  String imageUrl = '';
  try {
    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('churchlogo')
        .child('/' + fileName);

    uploadTask = ref.putData(image);

    await uploadTask.whenComplete(() => null);
    imageUrl = await ref.getDownloadURL();
    imageLink = imageUrl;
    // print('Uploaded image url ' + imageLink);
    // saveItem();
  } catch (e) {
    print(e);
  }
  return imageUrl;
}
}
