import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadly/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:threadly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:threadly/features/auth/domain/usecases/user_login.dart';
import 'package:threadly/features/auth/domain/usecases/user_sign_up.dart';
import 'package:threadly/features/auth/presentation/bloc/auth_bloc.dart';
import 'firebase_options.dart';
import 'package:threadly/core/theme/theme.dart';
import 'package:threadly/features/auth/presentation/pages/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("🔥 Firebase Initialized: ${Firebase.apps.isNotEmpty}");

  // ✅ Manually initialize dependencies
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final authRemoteDataSource = AuthRemoteDataSourceImpl(
    firebaseAuth,
    firestore,
  );
  final authRepository = AuthRepositoryImpl(authRemoteDataSource);
  final userSignUp = UserSignUp(authRepository);
  final userLogin = UserLogin(authRepository);
  final authBloc = AuthBloc(userSignUp: userSignUp, userLogin: userLogin);

  runApp(BlocProvider(create: (ctx) => authBloc, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      home: SignupPage(),
    );
  }
}
