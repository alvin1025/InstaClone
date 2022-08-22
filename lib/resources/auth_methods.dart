// import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intsa/resources/storage_methods.dart';

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Something Error Occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty) {
      // auth user
      UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print(cred.user!.uid);

      String photoUrl = await StorageMethod().uploadImageStorage('profilePics', file, false);

      // store to database
      _firestore.collection('users').doc(cred.user!.uid).set({
        'username' : username,
        'uid' : cred.user!.uid,
        'password' : password,
        'bio' : bio,
        'followers' : [],
        'following' : [],
        'photoUrl' : photoUrl
      });
  // another way to add to database
    // _firestore.collection('users').add({
    //     'username' : username,
    //     'uid' : cred.user!.uid,
    //     'password' : password,
    //     'bio' : bio,
    //     'followers' : [],
    //     'following' : [],
    // });


      res = "Success";
      }
    } 
    // get error auth
    // on FirebaseAuthException catch(error){
    //   if (error.code == 'invalid-email') {
    //     res = 'This email is badly formatter';
    //   } else if (error.code == 'weak-password'){
    //     res = 'Password should be at least 6 character';
    //   }
    // }
    
    
    catch (error) {
      res = error.toString();
    }
    return res;
  }

  // Login User
  Future<String> loginUser({
    required String email,
    required String password,

  }) async {
    String res = "Some Error Occured";

    try {
      if(email.isNotEmpty || password.isEmpty){
       await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = "Success";
      } else {
        res = "Please Enter All Fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}