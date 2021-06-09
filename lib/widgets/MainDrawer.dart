import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:predict_ipl/widgets/DrawerTile.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool _isAdmin = false;
  User loggedInUser;

  getCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedInUser = user;
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(loggedInUser.uid)
            .get();
        if (this.mounted) {
          setState(() {
            _isAdmin = userData.get('admin');
            print(_isAdmin);
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 80,
          ),
          DrawerTile(
            title: 'HOME',
            icon: Icons.home,
            onTap: () {
              Navigator.pushNamed(context, 'HomeScreen');
            },
          ),
          DrawerTile(
            title: 'LOGOUT',
            icon: Icons.exit_to_app,
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, 'SignUpLoginScreen');
            },
          ),
          DrawerTile(
            title: 'ABOUT',
            icon: Icons.info_outline,
            onTap: () {
              Navigator.pushNamed(context, 'AboutScreen');
            },
          ),
          DrawerTile(
            title: 'ADMIN ACCESS',
            icon: Icons.account_box,
            onTap: _isAdmin
                ? () {
                    Navigator.pushNamed(context, 'AdminScreen');
                  }
                : () {
                    Navigator.pop(context);
                    scaffold.showSnackBar(SnackBar(
                      content: Text('You are not an Admin'),
                      duration: Duration(seconds: 1),
                    ));
                  },
          ),
        ],
      ),
    );
  }
}
