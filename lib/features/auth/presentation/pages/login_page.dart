import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadly/core/theme/app_pallete.dart';
import 'package:threadly/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:threadly/features/auth/presentation/pages/home_page.dart';
import 'package:threadly/features/auth/presentation/pages/signup_page.dart';
import 'package:threadly/features/auth/presentation/widgets/authfield.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) =>
                          const Center(child: CircularProgressIndicator()),
                );
              } else {
                if (Navigator.canPop(context)) Navigator.pop(context);
                if (state is AuthSuccess) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePage(user: state.user),
                    ),
                  );
                } else if (state is AuthFailure) {
                  print(state.message);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              }
            },
            builder: (context, state) {
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Authfield(
                      hintText: "Email",
                      labelText: "Email",
                      controller: emailController,
                    ),
                    const SizedBox(height: 12),
                    Authfield(
                      hintText: "Password",
                      labelText: "Password",
                      controller: passwordController,
                      isObscureText: true,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(SignupPage.route());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            Icons.arrow_right_alt,
                            color: AppPallete.primaryColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          state is AuthLoading
                              ? null
                              : () {
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    AuthLogin(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    ),
                                  );
                                  print("Sign Login button pressed");
                                  print(
                                    "Email: ${emailController.text.trim()}",
                                  );
                                  print(
                                    "Password: ${passwordController.text.trim()}",
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(395, 45),
                        backgroundColor: AppPallete.primaryColor,
                        shadowColor: AppPallete.transparentColor,
                      ),
                      child:
                          state is AuthLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : Text(
                                "LOGIN",
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: AppPallete.whiteColor,
                                ),
                              ),
                    ),
                    const SizedBox(height: 175),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "Or login with social account",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(92, 64),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  backgroundColor: AppPallete.whiteColor,
                                  shadowColor: AppPallete.transparentColor,
                                ),
                                child: Image.asset(
                                  "assets/icons/google_icon.png",
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                              const SizedBox(width: 15),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(92, 64),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  backgroundColor: AppPallete.whiteColor,
                                  shadowColor: AppPallete.transparentColor,
                                ),
                                child: Image.asset(
                                  "assets/icons/facebook_icon.png",
                                  width: 35,
                                  height: 35,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
