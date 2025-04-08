import "package:flutter/material.dart";
import "package:fluter_prjcts/Firestore/Player/sign_user.dart";

import "package:fluter_prjcts/Firestore/Player/player.firestore.dart";

import "../Actions/Buttons/back_button.dart";
import "../Router/router.dart";
import "../Widgets/Other/screen_title.dart";
import "loading_screen.dart";


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void onPress() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LoadingScreen<void>(
          backgroundColor: Colors.amber,
          loadingText: "Creating your account...",
          future: _signUp,
          builder: (context, _) {
            // After sign up and login, go to home
            WidgetsBinding.instance.addPostFrameCallback((_) {
              router.go('/');
            });

            // Show empty container briefly to allow frame callback
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final username = _usernameController.text.trim();

      await checkUsername(username);
      await signUpUser(username, email, password);

      await signInUser(email, password);
    } catch(e) {
      throw Exception("Auth error. $e");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 15,),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ReturnBackButton(iconColor: Colors.amber),
                          ),
                          Center(child: ScreenTitle(title: "Sign Up")),
                        ],
                      ),
                      const SizedBox(height: 50),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Username",
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Email",
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Password",
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: onPress,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}