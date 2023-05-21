import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locationapp/Terms.dart';

import 'package:locationapp/contactus.dart';
import 'package:locationapp/profile_page.dart';
import 'package:locationapp/service/auth_service.dart';
import 'package:locationapp/service/database_service.dart';
import 'auth/login_page.dart';
import 'helper/helper_function.dart';
import 'main.dart';
import 'widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatefulWidget {
  // String userName = '';
  // String email = '';

  // MyDrawer({Key? key, required this.email, required this.userName})
  //     : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  AuthService authService = AuthService();
  // const MyDrawer({Key key}) : super(key: key);
  String userName = "";
  String email = "";
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  void initState() {
    super.initState();

    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final image_url =
        "https://media.istockphoto.com/id/1209654046/vector/user-avatar-profile-icon-black-vector-illustration.jpg?s=612x612&w=0&k=20&c=EOYXACjtZmZQ5IsZ0UUp1iNmZ9q2xl1BD1VvN6tZ2UI=";
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 212, 145, 73),
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                accountName: Text(userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    )),
                accountEmail:
                    Text(email, style: TextStyle(color: Colors.black)),
                currentAccountPicture:
                    CircleAvatar(backgroundImage: NetworkImage(image_url)),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
            ),
            // SizedBox(
            //   child:Container(
            //     padding:EdgeInsets.symmetric(vertical: 0,horizontal: 3
            //     ),
            //       height:0.5,
            //       color:Colors.white,

            //   )
            // ),
            ListTile(
              onTap: () {
                nextScreen(context, MyApp());
              },
              leading: Icon(CupertinoIcons.home, color: Colors.white),
              title: Text("HOME",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
            ),

            ListTile(
              onTap: () {
                nextScreenReplace(
                    context,
                    ProfilePage(
                      userName: userName,
                      email: email,
                    ));
              },
              leading:
                  Icon(CupertinoIcons.profile_circled, color: Colors.white),
              title: Text("PROFILE",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
            ),

            ListTile(
              onTap: () {
                nextScreen(context, Contactus());
              },
              leading: Icon(CupertinoIcons.mail_solid, color: Colors.white),
              title: Text("Contact us",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () {
                nextScreen(context, Termspage());
              },
              leading: Icon(CupertinoIcons.settings_solid, color: Colors.white),
              title: Text("Terms and conditions",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.exit_to_app, color: Colors.white),
              title: Text("Exit",
                  textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
            )
            // ListTile(
            //   leading: Icon(CupertinoIcons.bell_fill, color: Colors.white),
            //   title: Text("NOTIFICATIONS",
            //       textScaleFactor: 1.2, style: TextStyle(color: Colors.white)),
            // )
          ],
        ),
      ),
    );
  }
}
