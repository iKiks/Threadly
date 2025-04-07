import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadly/core/theme/app_pallete.dart';
import 'package:threadly/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:threadly/features/auth/presentation/pages/login_page.dart';
import 'package:threadly/features/auth/presentation/widgets/authfield.dart';

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignupPage());
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                  Navigator.of(context).pushReplacement(LoginPage.route());
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
                    const Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Authfield(
                      hintText: "Name",
                      labelText: "Name",
                      controller: nameController,
                    ),
                    const SizedBox(height: 12),
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
                      onTap:
                          () => Navigator.of(context).push(LoginPage.route()),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            "Already have an account?",
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
                                    AuthSignUp(
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    ),
                                  );
                                  print("Sign up button pressed");
                                  print("Name: ${nameController.text.trim()}");
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
                              : const Text(
                                "SIGN UP",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: AppPallete.whiteColor,
                                ),
                              ),
                    ),
                    const SizedBox(height: 100),
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "Or sign up with social account",
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
