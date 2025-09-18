import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodtracker_firebase/Mobile/dashboard.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscurePassword = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late String errorMessage = "";
  late bool isError = false;

  @override
  void initState() {
    errorMessage = "";
    isError = false;
    super.initState();
    _navigateUser();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Auto navigate if already logged in
  void _navigateUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(userEmail: user.email),
          ),
        );
      });
    }
  }

  /// Check login credentials
  Future checkLogin(email, password) async {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pop(context); // close loading dialog
      setState(() {
        errorMessage = "";
        isError = false;
      });

      // Navigate to dashboard with email
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Dashboard(userEmail: FirebaseAuth.instance.currentUser?.email),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      setState(() {
        errorMessage = e.message.toString();
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff213448), Color(0xff213448)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Logo
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: ClipOval(
                        child: Image.asset(
                          'images/foodtracker.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Firebase error message
                    if (isError)
                      Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),

                    const SizedBox(height: 60),

                    // Email field
                    SizedBox(
                      width: 500,
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          prefixIcon: const Icon(Icons.person),
                          fillColor: Colors.white,
                          hintText: 'Enter your Email Address',
                          hintStyle: const TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Password field
                    SizedBox(
                      width: 500,
                      child: TextField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter your Password',
                          hintStyle: const TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Login button
                    SizedBox(
                      width: 500,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 2),
                          backgroundColor: Colors.transparent,
                          minimumSize: const Size(500, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () async {
                          await checkLogin(
                            emailController.text,
                            passwordController.text,
                          );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
