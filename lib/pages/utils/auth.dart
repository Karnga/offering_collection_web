import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:offering_collection_web/pages/church/church_admin.dart';
import 'package:offering_collection_web/pages/services/login.dart';
import 'package:offering_collection_web/pages/system/system_admin.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final currentUser = FirebaseAuth.instance.currentUser!;
              // UserHelper.saveUser(snapshot.data);
              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Administrators")
                    .doc(currentUser.email)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    final userDoc =
                        snapshot.data!.data() as Map<String, dynamic>;
                    // final user = userDoc!.data() as Map<String, dynamic>;
                    // print(user["names"]);
                    if (userDoc['role'] == 'sys_admin') {
                      return SystemAdminPage();
                    } else if (userDoc['role'] == 'ch_admin') {
                      return ChurchAdminPage();
                    }
                    return Login();
                  } else {
                    return Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              );
            }
            return Login();
          }),
    );
  }
}
