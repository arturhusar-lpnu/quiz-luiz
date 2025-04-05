import "package:fluter_prjcts/Router/router.dart";
import "package:flutter/material.dart";
import "package:fluter_prjcts/Firestore/Player/sign_user.dart";


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInState createState() => SignInState();


}

class SignInState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      await signInUser(email, password);
      print("logged in");
    } catch(e) {
      throw Exception("Auth error. Check email or password. Sign Up for a new account");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        "Welcome back wanderer!\n Please sign in",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
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
                          onPressed: _signIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Not a member? ", style: TextStyle(fontSize: 18),),
                            TextButton(
                              onPressed: () {
                                router.go('/sign-up');
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.amber,
                                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              child: const Text("Sign Up", style: TextStyle(fontSize: 18)),
                            ),
                          ],
                        ),
                      ),
                      //const SizedBox(height: 100),
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