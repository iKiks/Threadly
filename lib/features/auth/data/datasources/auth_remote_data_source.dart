import 'package:threadly/core/error/exceptions.dart';
import 'package:threadly/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  AuthRemoteDataSourceImpl(this._auth, this._firestore);

  @override
  Future<UserModel?> getCurrentUserData() {
    // TODO: implement getCurrentUserData
    throw UnimplementedError();
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? firebaseUser = response.user;
      if (firebaseUser == null) {
        throw Exception("User not found");
      }

      String uid = firebaseUser.uid;

      String? name = await _firestore
          .collection('users')
          .doc(uid)
          .get()
          .then((doc) => doc.data()?['name'] as String?);

      return UserModel(id: uid, email: email, name: name ?? "Unknown");
    } catch (e) {
      throw ServerException("Login failed: $e");
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? firebaseUser = response.user;
      if (firebaseUser == null) {
        throw Exception("User creation failed");
      }

      String uid = firebaseUser.uid;

      await _firestore.collection('users').doc(uid).set({
        "uid": uid,
        "name": name,
        "email": firebaseUser.email,
        "createdAt": FieldValue.serverTimestamp(),
      });

      return UserModel(id: uid, email: email, name: name);
    } catch (e) {
      throw ServerException(
        "Sign-up failed: $e",
      );
    }
  }
}
