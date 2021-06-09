import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'file:///C:/Users/lalith%20k/AndroidStudioProjects/predict_ipl/lib/widgets/InputText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpLoginScreen extends StatefulWidget {
  @override
  _SignUpLoginScreenState createState() => _SignUpLoginScreenState();
}

class _SignUpLoginScreenState extends State<SignUpLoginScreen> {
  List documents = [];
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email, _password, _username;
  final _auth = auth.FirebaseAuth.instance;
  bool _loading = false;
  auth.User loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Center(
          child: Card(
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _isLogin ? 'LOGIN' : 'SIGN UP',
                        style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      InputText(
                        hidden: false,
                        caps: TextCapitalization.none,
                        icon: Icons.mail,
                        hintText: 'Email',
                        onChanged: (value) {
                          _email = value;
                        },
                        validate: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid Email address.';
                          }
                          return null;
                        },
                      ),
                      !_isLogin
                          ? InputText(
                              hidden: false,
                              caps: TextCapitalization.words,
                              hintText: 'Username',
                              icon: Icons.account_box,
                              onChanged: (value) {
                                _username = value;
                                _getDocuments(_username);
                              },
                              validate: (value) {
                                if (value.isEmpty || documents.length > 0) {
                                  return 'Username already exists.';
                                }
                                return null;
                              },
                            )
                          : Container(),
                      InputText(
                        hidden: true,
                        caps: TextCapitalization.none,
                        icon: Icons.remove_red_eye,
                        hintText: 'Password',
                        onChanged: (value) {
                          _password = value;
                        },
                        validate: (value) {
                          if (value.isEmpty || value.length < 6) {
                            return 'Atleast 6 characters.';
                          }
                          return null;
                        },
                      ),
                      !_isLogin
                          ? InputText(
                              hidden: true,
                              caps: TextCapitalization.none,
                              icon: Icons.remove_red_eye,
                              hintText: 'Confirm Password',
                              onChanged: (value) {},
                              validate: (value) {
                                if (value != _password) {
                                  return ' Confirm Password does not match.';
                                }
                                return null;
                              },
                            )
                          : Container(),
                      RaisedButton(
                        color: Colors.blue,
                        elevation: 5,
                        child: Text(
                          _isLogin ? 'Login' : 'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _trySubmit,
                      ),
                      FlatButton(
                        color: Colors.blue,
                        child: Text(
                          _isLogin
                              ? 'Create a new account'
                              : 'I already have an account',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginInFunction() async {
    setState(() {
      _loading = true;
    });
    try {
      final newUser = await _auth.signInWithEmailAndPassword(
          email: _email, password: _password);
      if (newUser != null) {
        loggedInUser = newUser.user;
        reloadCurrentUser();
        if (loggedInUser.emailVerified == true) {
          Navigator.pushNamed(context, 'HomeScreen');
          setState(() {
            _loading = false;
          });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('ALERT'),
                  content: Text('Email not verified.'),
                );
              });
          setState(() {
            _loading = false;
          });
        }
      }
    } on auth.FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ALERT'),
              content: Text(e.message),
            );
          });
      setState(() {
        _loading = false;
      });
    }
  }

  void signUpFunction() async {
    setState(() {
      _loading = true;
    });
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      if (newUser != null) {
        loggedInUser = newUser.user;
        loggedInUser.sendEmailVerification();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(newUser.user.uid)
            .set({
          'username': _username,
          'email': _email,
          'admin': false,
          'team': 8
        });

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('VERIFICATION LINK SENT'),
                content: Text(
                    'Click on the link which is sent to your Email ID to verify it'),
              );
            });
        setState(() {
          _isLogin = !_isLogin;
          _loading = false;
        });
      }
    } on auth.FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ALERT'),
              content: Text(e.message),
            );
          });
      setState(() {
        _loading = false;
      });
    }
  }

  void _getDocuments(String _username) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: _username)
        .get();
    documents = result.docs;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      _formKey.currentState.save();
      _isLogin ? loginInFunction() : signUpFunction();
    }
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void reloadCurrentUser() async {
    if (loggedInUser != null) {
      await loggedInUser.reload();
      loggedInUser = auth.FirebaseAuth.instance.currentUser;
    } else {
      loggedInUser = auth.FirebaseAuth.instance.currentUser;
    }
  }
}
