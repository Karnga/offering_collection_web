import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:offering_collection_web/pages/church/church_admin_dashboard.dart';
import 'package:offering_collection_web/pages/system/manage_church.dart';
import 'package:offering_collection_web/pages/system/manage_user.dart';
import 'package:offering_collection_web/pages/system/system_admin_dashboard.dart';

class SystemAdminPage extends StatefulWidget {
  static const String id = "system-admin-page";

  @override
  State<SystemAdminPage> createState() => _SystemAdminPageState();
}

class _SystemAdminPageState extends State<SystemAdminPage> {
  // logout user
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  Widget _selectedPage = SystemAdminDashboard();

  currentPage(item) {
    switch (item.route) {
      case SystemAdminDashboard.id:
        setState(() {
          _selectedPage = SystemAdminDashboard();
        });
        break;
      case ManageChurchPage.id:
        setState(() {
          _selectedPage = ManageChurchPage();
        });
        break;
      case ManageUserPage.id:
        setState(() {
          _selectedPage = ManageUserPage();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'System Admin Panel',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      sideBar: SideBar(
        // activeBackgroundColor: Colors.black,
        // activeIconColor: Colors.black,
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: ChurchAdminDashboard.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Manage Church',
            route: ManageChurchPage.id,
            icon: Icons.church_outlined,
          ),
          AdminMenuItem(
            title: 'Manage User',
            route: ManageUserPage.id,
            icon: Icons.person_2_outlined,
          ),
        ],
        selectedRoute: SystemAdminPage.id,
        onSelected: (item) {
          currentPage(item);
          // if (item.route != null) {
          //   Navigator.of(context).pushNamed(item.route!);
          // }
        },
        // header: Container(
        //   height: 50,
        //   width: double.infinity,
        //   color: const Color(0xff444444),
        //   child: const Center(
        //     child: Text(
        //       'header',
        //       style: TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
        footer: Container(
          // color: const Color(0xffEEEEEE),
          height: 50,
          width: 250,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xffE5E5E5))),
             color: const Color(0xffEEEEEE),
          ),
          child: TextButton.icon(
            onPressed: () {
              logout();
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.red,
            ),
            label: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
              ),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _selectedPage,
    );
  }
}
