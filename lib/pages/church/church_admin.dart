import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:offering_collection_web/pages/church/church_admin_dashboard.dart';
import 'package:offering_collection_web/pages/church/search_page.dart';

class ChurchAdminPage extends StatefulWidget {
  static const String id = "church-admin-page";

  @override
  State<ChurchAdminPage> createState() => _ChurchAdminPageState();
}

class _ChurchAdminPageState extends State<ChurchAdminPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  var churchLogo;
  String churchName = '';

  // logout user
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  Widget _selectedPage = ChurchAdminDashboard();

  currentPage(item) {
    switch (item.route) {
      case ChurchAdminDashboard.id:
        setState(() {
          _selectedPage = ChurchAdminDashboard();
        });
        break;
      case SearchPage.id:
        setState(() {
          _selectedPage = SearchPage();
        });
        break;
      // case SearchPage.id:
      //   setState(() {
      //     _selectedPage = SearchPage();
      //   });
      //   break;
      //   case PdfPage.id:
      //   setState(() {
      //     _selectedPage = PdfPage();
      //   });
      //   break;
    }
  }

  getChurch() async {
    var chruchDataFromFirebase = await FirebaseFirestore.instance
        .collection('Churches')
        .where("email", isEqualTo: currentUser.email)
        .get();
    var churchData = chruchDataFromFirebase.docs;
    var church = churchData[0].data();
    var churchLogo1 = church['logo'];
    String churchName1 = church['name'];

    // var offeringDataFromFirebase = await FirebaseFirestore.instance
    //     .collection('Offerings')
    //     .where("church_id", isEqualTo: churchId)
    //     .get();

    // List offeringDocument = offeringDataFromFirebase.docs;

    setState(() {
      churchLogo = churchLogo1;
      churchName = churchName1;
      // offeringData = offeringDocument
      //     .map((offerings) => OfferingModel.fromDoc(offerings))
      //     .toList();
      // offeringsFiltered = offeringData!;
    });
  }

  @override
  void initState() {
    super.initState();
    getChurch();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          churchName,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          CircleAvatar(backgroundImage: NetworkImage(churchLogo)),
          SizedBox(
            width: 20,
          )
        ],
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
            title: 'OFFERING REPORT',
            route: SearchPage.id,
            icon: Icons.report,
          ),
          // AdminMenuItem(
          //   title: 'Search Page',
          //   route: SearchPage.id,
          //   icon: Icons.church_outlined,
          // ),
          // AdminMenuItem(
          //   title: 'Pdf Page',
          //   route: PdfPage.id,
          //   icon: Icons.picture_as_pdf,
          // ),
        ],
        selectedRoute: ChurchAdminPage.id,
        onSelected: (item) {
          currentPage(item);
          // if (item.route != null) {
          //   Navigator.of(context).pushNamed(item.route!);
          // }
        },

        // header:
        // // Container(
        // //   decoration: BoxDecoration(
        // //     image: DecorationImage(
        // //       image: Image.memory(churchLogo)),)

        //   // Image.network(churchLogo),
        // //   ),

        // Container(
        //   height: 30,
        //   // width: double.infinity,
        //   // width: 150,
        //   // color: const Color(0xff444444),
        //   child: Image.network(churchLogo),

        // //   // decoration: BoxDecoration(
        // //   //   image: DecorationImage(
        // //   //     image: Image.memory(churchLogo))),

        // //   // const Center(
        // //   //   child: Text(
        // //   //     'header',
        // //   //     style: TextStyle(
        // //   //       color: Colors.white,
        // //   //     ),
        // //   //   ),
        // //   // ),
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

        // Container(
        //   height: 50,
        //   width: double.infinity,
        //   color: const Color(0xff444444),
        //   child:
        //   IconButton(
        //   onPressed: logout,
        //   icon: Icon(Icons.logout),
        //   color: Colors.red,
        // ),
        // // Center(
        // //       child:
        // //           // Text(
        // //           //   'footer',
        // //           //   style: TextStyle(
        // //           //     color: Colors.white,
        // //           //   ),
        // //           // ),
        // //           MyButton(
        // //             text: "Logout",
        // //             onTap: logout,
        // //           ),
        // //   ),
        // ),
        
      ),
      body: _selectedPage,
    );
  }
}
