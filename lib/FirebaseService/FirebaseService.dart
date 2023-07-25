import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {

    static FirebaseAuth auth = FirebaseAuth.instance;

    static FirebaseFirestore firestore = FirebaseFirestore.instance;
}