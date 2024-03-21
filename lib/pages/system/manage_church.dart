import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:offering_collection_web/model/admin_model.dart';
import 'package:offering_collection_web/model/church_model.dart';
import 'package:offering_collection_web/pages/services/firestore_helper.dart';

class ManageChurchPage extends StatefulWidget {
  static const String id = "manage-church-page";

  const ManageChurchPage({
    super.key,
  });

  @override
  State<ManageChurchPage> createState() => _ManageChurchPageState();
}

class _ManageChurchPageState extends State<ManageChurchPage> {
  dynamic image;
  late String fileName;

  String errorMsg = "";
  String logo = "";
  String _id = "";
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _login = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String _adminRole = "church_admin";

  // final GlobalKey _formKey = GlobalKey<FormState>();

  String defaultImageUrl = '';
  bool isItemSaved = false;
  String imageLink = '';
  String imageUrl = '';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _contact.dispose();
    _location.dispose();
    _login.dispose();
    _password.dispose();
    // super.dispose();
  }

  void clear() {
    image = null;
    _name.clear();
    _email.clear();
    _contact.clear();
    _location.clear();
    _login.clear();
    _password.clear();
  }

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        image = result.files.first.bytes;
        fileName = result.files.first.name;
        Navigator.pop(context);
        AddDialogBox();
      });
    } else {
      print("No image selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AddDialogBox();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(children: [
        Text("REGISTERED CHURCHES",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 30,
            )),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey),
            ),
          ),
          height: 543,
          child: StreamBuilder<List<ChurchModel>>(
              stream: FirestoreHelper.readChurch(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Failed');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  final offeringData = snapshot.data;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: offeringData!.length,
                      itemBuilder: (context, index) {
                        final singleChurch = offeringData[index];

                        return Card(
                          child: ListTile(
                            onTap: () {
                              viewDialogBox(singleChurch);
                            },
                            leading: CircleAvatar(
                              // radius: 70,
                              backgroundImage:
                                  NetworkImage("${singleChurch.logo}"),
                            ),
                            title: Text("${singleChurch.name}"),
                            subtitle: Text("${singleChurch.email}"),
                            trailing: Wrap(
                              spacing: 30, // space between two icons
                              children: <Widget>[
                                InkWell(
                                    onTap: () {
                                      EditDialogBox(singleChurch);
                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => MyDialog()));
                                    },
                                    child: Icon(Icons.edit)), // icon-1

                                InkWell(
                                    onTap: () {
                                      FirestoreHelper.deleteChurch(
                                          singleChurch);
                                    },
                                    child: Icon(Icons.delete)), // icon-2
                              ],
                            ),
                          ),
                        );
                      });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
        // Stack(child: FloatingActionButton(onPressed: (){})),
      ]),
    );
  }

  viewDialogBox(singleChurch) {
    logo = singleChurch.logo;
    _name.text = singleChurch.name;
    _email.text = singleChurch.email;
    _contact.text = singleChurch.contact;
    _location.text = singleChurch.location;
    _login.text = singleChurch.login;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStateForDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              scrollable: true,
              title: Text(
                "CHURCH DETAILS",
                textAlign: TextAlign.center,
              ),
              contentPadding:
                  EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              content: Column(
                children: [
                  Container(
                      height: 100,
                      width: 100,
                      // color: Colors.blueGrey,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      child: Image.network(
                        logo,
                        fit: BoxFit.cover,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    enabled: false,
                    controller: _name,
                    decoration: InputDecoration(
                        fillColor: Colors.black,
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.black)),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    enabled: false,
                    controller: _email,
                    decoration: InputDecoration(
                        fillColor: Colors.black,
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.black)),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    enabled: false,
                    controller: _contact,
                    decoration: InputDecoration(
                        fillColor: Colors.black,
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.black)),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    enabled: false,
                    controller: _location,
                    decoration: InputDecoration(
                        fillColor: Colors.black,
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.black)),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    enabled: false,
                    controller: _login,
                    decoration: InputDecoration(
                        fillColor: Colors.black,
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.black)),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        clear();
                      },
                      child: Text('CLOSE')),
                ],
              ),
            );
          });
        });
    // clear();
  }

  EditDialogBox(singleChurch) {
    // _id = singleChurch.id;
    logo = singleChurch.logo;
    _name.text = singleChurch.name;
    _email.text = singleChurch.email;
    _contact.text = singleChurch.contact;
    _location.text = singleChurch.location;
    _login.text = singleChurch.login;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStateForDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              scrollable: true,
              title: Text(
                "EDIT CHURCH DETAILS",
                textAlign: TextAlign.center,
              ),
              contentPadding:
                  EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              content: Column(
                children: [
                  Container(
                      height: 100,
                      width: 100,
                      // color: Colors.blueGrey,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      child: Image.network(
                        logo,
                        fit: BoxFit.cover,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    // enabled: false,
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: "Church Name",
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    // enabled: false,
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: "Church Email",
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    // enabled: false,
                    controller: _contact,
                    decoration: InputDecoration(
                      labelText: "Church Contact",
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    // enabled: false,
                    controller: _location,
                    decoration: InputDecoration(
                      labelText: "Church Location",
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    // enabled: false,
                    controller: _login,
                    decoration: InputDecoration(
                      labelText: "Church Admin Login",
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            FirestoreHelper.updateChurch(ChurchModel(
                              // id: singleChurch?.id,
                              logo: logo,
                              name: _name.text,
                              email: _email.text,
                              contact: _contact.text,
                              location: _location.text,
                              login: _login.text,
                            ));
                            Navigator.pop(context);
                            clear();
                          },
                          child: Text("UPDATE")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            clear();
                          },
                          child: Text('CLOSE')),
                    ],
                  ),
                ],
              ),
            );
          });
        });
    // clear();
  }

  AddDialogBox() {
    // String imageLink = '';
    // String imageUrl = '';
    // setState(() {
    //   imageUrl = imageLink;
    // });
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStateForDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              scrollable: true,
              title: Text(
                "ADD CHURCH",
                textAlign: TextAlign.center,
              ),
              contentPadding:
                  EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              content: Column(
                children: [
                  InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                        height: 90,
                        width: 110,
                        // color: Colors.blueGrey,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                        child: image == null
                            ? Center(child: Icon(Icons.file_upload))
                            : Image.memory(
                                image,
                                fit: BoxFit.cover,
                              )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    // enabled: false,
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: "Name",
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  TextField(
                    // enabled: false,
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  TextField(
                    // enabled: false,
                    controller: _contact,
                    decoration: InputDecoration(
                      labelText: "Contact",
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  TextField(
                    // enabled: false,
                    controller: _location,
                    decoration: InputDecoration(
                      labelText: "Location",
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  TextField(
                    // enabled: false,
                    controller: _login,
                    decoration: InputDecoration(
                      labelText: "Login",
                    ),
                  ),
                  TextField(
                    // enabled: false,
                    controller: _password,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            _uploadFile();
                          },
                          child: Text("ADD")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            clear();
                          },
                          child: Text('CLOSE')),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  Future<String> _uploadFile() async {
    // String imageUrl = '';
    try {
      firebase_storage.UploadTask uploadTask;

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('churchlogo')
          .child('/' + fileName);

      uploadTask = ref.putData(image);

      await uploadTask.whenComplete(() => null);
      imageLink = await ref.getDownloadURL();

      FirestoreHelper.createChurch(ChurchModel(
        role: 'ch_admin',
        logo: imageLink,
        name: _name.text,
        email: _email.text,
        contact: _contact.text,
        location: _location.text,
        login: _login.text,
        password: _password.text,
      ));

      FirestoreHelper.createAdmin(AdminModel(
        role: 'ch_admin',
        email: _email.text,
      ));

      Navigator.pop(context);
      clear();
    } catch (e) {
      print(e);
    }
    return imageLink;
  }
}
