import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart' as loc;
import 'package:locationapp/auth/login_page.dart';
import 'package:locationapp/button.dart';
import 'package:locationapp/drawer.dart';
import 'package:locationapp/flutter_flow/index.dart';

import 'package:locationapp/mymap.dart';
import 'package:locationapp/profile_page.dart';
import 'package:locationapp/service/auth_service.dart';
import 'package:locationapp/service/database_service.dart';
import 'package:locationapp/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'helper/helper_function.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: OnboardingWidget(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";
  @override
  void initState() {
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
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
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 227, 133, 33),
            elevation: 0,
            title: const Text(
              "MOVEASY",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 29,
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Color.fromARGB(255, 237, 190, 120),
          drawer: MyDrawer(),
          // appBar: AppBar(
          //   title: Text('live location tracker'),
          // ),
          // drawer: Drawer(
          //     child: ListView(
          //   padding: const EdgeInsets.symmetric(vertical: 50),
          //   children: <Widget>[
          //     Icon(
          //       Icons.account_circle,
          //       size: 150,
          //       color: Colors.grey[700],
          //     ),
          //     const SizedBox(
          //       height: 15,
          //     ),
          //     Text(
          //       userName,
          //       textAlign: TextAlign.center,
          //       style: const TextStyle(fontWeight: FontWeight.bold),
          //     ),
          //     const SizedBox(
          //       height: 30,
          //     ),
          //     const Divider(
          //       height: 2,
          //     ),
          //     // ListTile(
          //     //   onTap: () {
          //     //     nextScreen(context, MyApp());
          //     //   },
          //     //   contentPadding:
          //     //       const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //     //   leading: const Icon(Icons.group),
          //     //   title: const Text(
          //     //     "Groups",
          //     //     style: TextStyle(color: Colors.black),
          //     //   ),
          //     // ),
          //     ListTile(
          //       onTap: () {
          //         nextScreen(context, MyApp());
          //       },
          //       selected: true,
          //       selectedColor: Theme.of(context).primaryColor,
          //       contentPadding:
          //           const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //       leading: const Icon(Icons.group),
          //       title: const Text(
          //         "Home Screen",
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     ),
          //     ListTile(
          //       onTap: () async {
          //         showDialog(
          //             barrierDismissible: false,
          //             context: context,
          //             builder: (context) {
          //               return AlertDialog(
          //                 title: const Text("Logout"),
          //                 content:
          //                     const Text("Are you sure you want to logout?"),
          //                 actions: [
          //                   IconButton(
          //                     onPressed: () {
          //                       Navigator.pop(context);
          //                     },
          //                     icon: const Icon(
          //                       Icons.cancel,
          //                       color: Colors.red,
          //                     ),
          //                   ),
          //                   IconButton(
          //                     onPressed: () async {
          //                       await authService.signOut();
          //                       Navigator.of(context).pushAndRemoveUntil(
          //                           MaterialPageRoute(
          //                               builder: (context) =>
          //                                   const LoginPage()),
          //                           (route) => false);
          //                     },
          //                     icon: const Icon(
          //                       Icons.done,
          //                       color: Colors.green,
          //                     ),
          //                   ),
          //                 ],
          //               );
          //             });
          //       },
          //       contentPadding:
          //           const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //       leading: const Icon(Icons.exit_to_app),
          //       title: const Text(
          //         "Logout",
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     )
          //   ],
          // )),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyButton(
                    onPressed: () {
                      _getLocation();
                    },
                    text: "add Location"),
                MyButton(
                    onPressed: () {
                      _listenLocation();
                    },
                    text: "start tracking"),
                MyButton(
                    onPressed: () {
                      _stopListening();
                    },
                    text: "stop tracking"),

                // TextButton(
                //     onPressed: () {
                //       nextScreenReplace(
                //           context,
                //           ProfilePage(
                //             userName: userName,
                //             email: email,
                //           ));
                //     },
                //     child: Text('about page')),
                // Text('data'),
                // TextButton(
                //     onPressed: () {
                //       _listenLocation();
                //     },
                //     child: Text('enable live location')),
                // TextButton(
                //     onPressed: () {
                //       _stopListening();
                //     },
                //     child: Text('stop live location')),
                // Expanded(
                //     child: StreamBuilder(
                //   stream: FirebaseFirestore.instance
                //       .collection('location')
                //       .snapshots(),
                //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                //     if (!snapshot.hasData) {
                //       return Center(child: CircularProgressIndicator());
                //     }
                //     return ListView.builder(
                //         itemCount: snapshot.data?.docs.length,
                //         itemBuilder: (context, index) {
                //           return ListTile(
                //             title: Text(
                //                 snapshot.data!.docs[index]['name'].toString()),
                //             subtitle: Row(
                //               children: [
                //                 Text(snapshot.data!.docs[index]['latitude']
                //                     .toString()),
                //                 SizedBox(
                //                   width: 20,
                //                 ),
                //                 Text(snapshot.data!.docs[index]['longitude']
                //                     .toString()),
                //               ],
                //             ),
                //             trailing: IconButton(
                //               icon: Icon(Icons.directions),
                //               onPressed: () {
                //                 Navigator.of(context).push(MaterialPageRoute(
                //                     builder: (context) =>
                //                         MyMap(snapshot.data!.docs[index].id)));
                //               },
                //             ),
                //           );
                //         });
                //   },
                // )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': '$userName'
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': '$userName'
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
