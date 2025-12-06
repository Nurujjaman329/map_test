import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [

                    const SizedBox(height: 100),

                    // /// Logo
                    // Image.asset(
                    //   "assets/logo.png",
                    //   width: 80,
                    // ),

                    const SizedBox(height: 16),

                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Sign in to access your account and continue\nwhere you left off.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 30),

                    // Email
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Password
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forget Password",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                        ),
                        onPressed: () {},
                        child: Text("Log In", style: TextStyle(fontSize: 18)),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text("or continue with"),

                    const SizedBox(height: 16),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     _loginOptionButton("assets/google.png", "Google"),
                    //     SizedBox(width: 12),
                    //     _loginOptionButton("assets/apple.png", "Log in"),
                    //   ],
                    // ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don’t have an account? "),
                        Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),

          // ---------------------------
          // 🔵 Abstract Background Shapes
          // ---------------------------
          Positioned(
            top: 80,
            left: -30,
            child: _blobShape(size: 120),
          ),

          Positioned(
            top: 250,
            right: -40,
            child: _blobShape(size: 140),
          ),

          Positioned(
            bottom: 160,
            left: -20,
            child: _blobShape(size: 150),
          ),

          Positioned(
            bottom: 70,
            right: -30,
            child: _blobShape(size: 120),
          ),

          // ---------------------------
          // 🔹 Login Content
          // ---------------------------

        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // 🔵 Reusable blob background shape (similar to screenshot)
  // ------------------------------------------------------------
  Widget _blobShape({double size = 140}) {
    return Opacity(
      opacity: 0.25,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: BorderRadius.circular(size * 0.6),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // 🔘 Social login button
  // ------------------------------------------------------------
  Widget _loginOptionButton(String icon, String text) {
    return Container(
      width: 130,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, width: 20),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
