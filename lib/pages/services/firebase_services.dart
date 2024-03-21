import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:offering_collection_web/model/church_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('Users');

dynamic image;
late String fileName;
String imageLink = '';

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  CollectionReference churches =
      FirebaseFirestore.instance.collection('Churches');
  CollectionReference offerings = FirebaseFirestore.instance.collection('Offerings');
}

class Database {
  late String userId;

  Stream<QuerySnapshot> readItem() {
    CollectionReference userItemCollection =
        _mainCollection.doc(userId).collection('Users');

    return userItemCollection.snapshots();
  }
}

Future update(ChurchModel church) async {
  final churchCollection = FirebaseFirestore.instance.collection("Churches");

  final uid = churchCollection.doc().id;
  final docRef = churchCollection.doc(uid);

  // final new
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

  // saveItem() async {
  //   final churchEntryMap = ChurchEntry(
  //     email: _churchEmail.text,
  //     name: _churchName.text,
  //     image: imageLink,
  //     contact: _churchContact.text,
  //   ).toMap();

  //   FirebaseFirestore.instance.collection('Churches').add(churchEntryMap);
  //   clear();
  //   clearImage();
  // }
