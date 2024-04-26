import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:message_bottle/screen/home_screen.dart';
import '../utils/utils.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12.0),
              ElevatedButton(
                child: isLoading ? const CircularProgressIndicator() : const Text('Login'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final response = await _loginWithPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                    if (response == null || response.user == null) {
                      return;
                    }
                    Navigator.of(context).pop();
                  }
                },
              ),
              TextButton(
                child: const Text('Go to Signup'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<AuthResponse?> _loginWithPassword({
    required String email,
    required String password,
  }) async {
    // Show a progress indicator while the login is in progress
    setState(() {
      isLoading = true;
    });
    try {
      // Call the Supabase auth.signInWithPassword method
      return await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (error) {
      // Show a snackbar with the error message if the login fails
      showErrorSnackBar(context, message: error.message);
    } on Exception catch (e) {
      // Show a snackbar with the error message if the login fails
      showErrorSnackBar(context, message: e.toString());
    } finally {
      // Hide the progress indicator
      setState(() {
        isLoading = false;
      });
    }
    // Return null if the login fails
    return null;
  }
}

