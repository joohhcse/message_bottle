import 'dart:async';
import 'package:flutter/material.dart';
import 'package:message_bottle/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/utils.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';


class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {

  String userID = '';
  String userName = '';
  bool isLoggedIn = false;
  bool isLoading = false;
  late StreamSubscription<AuthState> _authStateChangesSubscription;

  // Create a function that returns a StreamSubscription of AuthState
  StreamSubscription<AuthState> getAuthStateSubscription() {
    // Listen to the onAuthStateChange stream and return the state
    return Supabase.instance.client.auth.onAuthStateChange.listen((state) {
      // If the user is signed in, update the state with their details
      if (state.event == AuthChangeEvent.signedIn) {
        final userData = state.session!.user;
        setState(() {
          isLoggedIn = true;
          userID = userData.id;
          userName = userData.userMetadata!['username'];
        });
        // If the user is signed out, reset the state
      } else if (state.event == AuthChangeEvent.signedOut) {
        setState(() {
          isLoggedIn = false;
          userID = '';
          userName = '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Init Screen'),
      ),
      body: Center(
        child: Text('test'),
      ),
    );
  }


  Future<void> _logout() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Supabase.instance.client.auth.signOut();
    } on AuthException catch (error) {
      showErrorSnackBar(context, message: error.message);
    } on Exception catch (error) {
      showErrorSnackBar(context, message: error.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

