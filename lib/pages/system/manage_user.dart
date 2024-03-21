import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:offering_collection_web/model/church_model.dart';
import 'package:offering_collection_web/model/user_model.dart';
import 'package:offering_collection_web/pages/services/firestore_helper.dart';

class ManageUserPage extends StatefulWidget {
  static const String id = "manage-user-page";

  const ManageUserPage({
    super.key,
  });

  @override
  State<ManageUserPage> createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {
  dynamic image;
  late String fileName;

  String errorMsg = "";
  String profilePic = "";
  
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _login = TextEditingController();
  final TextEditingController _fav_bible_verse = TextEditingController();
  final TextEditingController _date_created = TextEditingController();
  final TextEditingController _password = TextEditingController();

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
    _address.dispose();
    _login.dispose();
    _password.dispose();
    // super.dispose();
  }

  void clear() {
    image = null;
    _name.clear();
    _email.clear();
    _contact.clear();
    _address.clear();
    _login.clear();
    _password.clear();
  }

  // pickImage() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //     allowMultiple: false,
  //   );
  //   if (result != null) {
  //     setState(() {
  //       image = result.files.first.bytes;
  //       fileName = result.files.first.name;
  //       Navigator.pop(context);
  //       AddDialogBox();
  //     });
  //   } else {
  //     print("No image selected");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     AddDialogBox();
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.blue,
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(children: [
        Text("REGISTERED MEMBER(S)",
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
          child: StreamBuilder<List<UserModel>>(
              stream: FirestoreHelper.readUser(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Failed');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  final memberData = snapshot.data;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: memberData!.length,
                      itemBuilder: (context, index) {
                        final singleMember = memberData[index];

                        return Card(
                          child: ListTile(
                            onTap: () {
                              viewDialogBox(singleMember);
                            },
                            leading: CircleAvatar(
                              // radius: 70,
                              backgroundImage:
                                  NetworkImage("${singleMember.profile_pic}"),
                            ),
                            title: Text("Name: ${singleMember.names}"),
                            subtitle: Text("Email: ${singleMember.email}"),
                            trailing: Wrap(
                              spacing: 30, // space between two icons
                              children: <Widget>[
                                InkWell(
                                    onTap: () {
                                      EditDialogBox(singleMember);
                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => MyDialog()));
                                    },
                                    child: Icon(Icons.edit)), // icon-1

                                InkWell(
                                    onTap: () {
                                      FirestoreHelper.deleteMember(
                                          singleMember);
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

  viewDialogBox(singleMember) {
    profilePic = singleMember.profile_pic;
    _name.text = singleMember.names;
    _email.text = singleMember.email;
    _contact.text = singleMember.contact;
    _address.text = singleMember.address;
    _fav_bible_verse.text = singleMember.fav_bible_verse;
    _date_created.text = singleMember.date_created;
    // _login.text = singleMember.login;

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
                        profilePic,
                        fit: BoxFit.cover,
                      )
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    enabled: false,
                    controller: _name,
                    decoration: InputDecoration(
                        fillColor: Colors.black,
                        labelText: "Names",
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
                        labelText: "Email",
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
                        labelText: "Contact",
                        labelStyle: TextStyle(color: Colors.black)),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    enabled: false,
                    controller: _address,
                    decoration: InputDecoration(
                        fillColor: Colors.black,
                        labelText: "Address",
                        labelStyle: TextStyle(color: Colors.black)),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    enabled: false,
                    controller: _fav_bible_verse,
                    decoration: InputDecoration(
                        fillColor: Colors.black,
                        labelText: "Favorite Bible Verse",
                        labelStyle: TextStyle(color: Colors.black)),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    enabled: false,
                    controller: _date_created,
                    decoration: InputDecoration(
                        fillColor: Colors.black,
                        labelText: "Date created",
                        labelStyle: TextStyle(color: Colors.black)),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // clear();
                      },
                      child: Text('CLOSE')),
                ],
              ),
            );
          });
        });
    // clear();
  }

  EditDialogBox(singleMember) {
    profilePic = singleMember.profile_pic;
    _name.text = singleMember.names;
    _email.text = singleMember.email;
    _contact.text = singleMember.contact;
    _address.text = singleMember.address;
    _fav_bible_verse.text = singleMember.fav_bible_verse;
    _date_created.text = singleMember.date_created;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setStateForDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              scrollable: true,
              title: Text(
                "EDIT USER DETAILS",
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
                        profilePic,
                        fit: BoxFit.cover,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    // enabled: false,
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: "Names",
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    // enabled: false,
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    // enabled: false,
                    controller: _contact,
                    decoration: InputDecoration(
                      labelText: "Contact",
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    // enabled: false,
                    controller: _address,
                    decoration: InputDecoration(
                      labelText: "Address",
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    // enabled: false,
                    controller: _fav_bible_verse,
                    decoration: InputDecoration(
                      labelText: "Favorite Bible verse",
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    // enabled: false,
                    controller: _date_created,
                    decoration: InputDecoration(
                      labelText: "Date created",
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
                            FirestoreHelper.updateUser(UserModel(
                              // id: singleMember?.id,
                              profile_pic: profilePic,
                              names: _name.text,
                              email: _email.text,
                              contact: _contact.text,
                              address: _address.text,
                              fav_bible_verse: _fav_bible_verse.text,
                              date_created: _date_created.text,
                            ));
                            Navigator.pop(context);
                            // clear();
                          },
                          child: Text("UPDATE")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // clear();
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
  
}
