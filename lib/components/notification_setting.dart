import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_app/auth/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificiedSettingPage extends StatefulWidget {
  @override
  _NotificiedSettingPageState createState() => _NotificiedSettingPageState();
}

class _NotificiedSettingPageState extends State<NotificiedSettingPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryController = TextEditingController();
  late User? _user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> _savedCategories = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _fetchSavedCategories();
  }

  void _getCurrentUser() {
    _user = AuthenticationRepository.instance.firebaseUser.value;
    if (_user == null) {
      Navigator.of(context).pop();
    }
  }

  void _fetchSavedCategories() {
    if (_user != null) {
      _firestore
          .collection('categories')
          .doc(_user!.uid)
          .collection('user_categories')
          .get()
          .then((querySnapshot) {
        setState(() {
          _savedCategories = querySnapshot.docs
              .map((doc) => doc['category'].toString())
              .toList();
        });
      }).catchError((error) {
        print("Failed to fetch saved categories: $error");
      });
    }
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      String category = _categoryController.text.trim();
      if (category.isNotEmpty && _user != null) {
        _firestore
            .collection('categories')
            .doc(_user!.uid)
            .collection('user_categories')
            .add({'category': category}).then((value) {
          print("Category added");
          // Update UI to display saved category without navigating to another page
          _fetchSavedCategories();
        }).catchError((error) => print("Failed to add category: $error"));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _saveCategory,
                  child: Text('Save Category'),
                ),
                SizedBox(height: 20.0),
                Text('Saved Categories: $_savedCategories'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
