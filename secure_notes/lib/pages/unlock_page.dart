import 'package:flutter/material.dart';
import '/services/biometric_authentication.dart';
import 'home_page.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final BiometricAuthentication _biometricAuthentication =
      BiometricAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade700,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            bool authenticated = await _biometricAuthentication.authenticate();
            if (authenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Biometric authentication failed."),
                ),
              );
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromARGB(255, 235, 228, 109),
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(
                  16.0), 
            ),
          ),
          child: const Text(
            "UNLOCK",
            style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 25.0),
          ),
        ),
      ),
    );
  }
}
