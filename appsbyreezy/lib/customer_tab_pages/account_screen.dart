import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // Firebase instances
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String profileImage = ''; // You can set the initial image path here

  void updateProfileData(String name, String email, String phone, String image) {
    setState(() {
      nameController.text = name;
      emailController.text = email;
      phoneController.text = phone;
      profileImage = image;
    });
  }

  Future<void> getUserProfile(String userId) async {
    DocumentSnapshot snapshot = await firestore.collection('users').doc(userId).get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      updateProfileData(data['name'], data['email'], data['phone'], data['image']);
    }
  }

  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      String userId = auth.currentUser!.uid;
      getUserProfile(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    profileImage: profileImage,
                    onProfileUpdated: updateProfileData,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Center(
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage: profileImage.isNotEmpty
                    ? NetworkImage(profileImage)
                    : AssetImage('assets/default_profile_image.png') as ImageProvider<Object>,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Name',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              nameController.text,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Email',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              emailController.text,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Phone',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Text(
              phoneController.text,
              style: TextStyle(fontSize: 16.0),
            ),
        
          ],
        ),
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final Function(String, String, String, String) onProfileUpdated;

  EditProfileScreen({
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.onProfileUpdated,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Firebase instances
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  File? _image;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    emailController.text = widget.email;
    phoneController.text = widget.phone;
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> saveUserProfile(String userId, String name, String email, String phone, String image) async {
    try {
      await firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'phone': phone,
        'image': image,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void saveProfile() async {
    String userId = auth.currentUser?.uid ?? ''; // Get the current user ID
    if (userId.isNotEmpty) {
      widget.onProfileUpdated(
        nameController.text,
        emailController.text,
        phoneController.text,
        _image != null ? _image!.path : widget.profileImage,
      );

      await saveUserProfile(
        userId,
        nameController.text,
        emailController.text,
        phoneController.text,
        _image != null ? _image!.path : widget.profileImage,
      );

      Navigator.pop(context); // Close the edit profile screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Center(
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : widget.profileImage.isNotEmpty
                        ? NetworkImage(widget.profileImage)
                        : AssetImage('assets/default_profile_image.png') as ImageProvider<Object>,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _pickImage,
              child:
               Text('Change Profile Picture'),
               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            SizedBox(height: 20.0),
            Text(
              'Name',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Enter your name'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Email',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Enter your email'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Phone',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Enter your phone number'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: saveProfile,
              child: Text('Save Profile'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
