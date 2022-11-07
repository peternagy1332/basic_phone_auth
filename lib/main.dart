import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase Auth'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: '+44 7123 123 456',
                verificationCompleted: (PhoneAuthCredential credential) {
                  print("verificationCompleted");
                },
                verificationFailed: (FirebaseAuthException e) {
                  print("verificationFailed");
                },
                codeSent: (String verificationId, int? resendToken) async {
                  print("codeSent");

                  String smsCode = '000000';

                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationId, smsCode: smsCode);

                  await FirebaseAuth.instance.signInWithCredential(credential);
                },
                codeAutoRetrievalTimeout: (String verificationId) {
                  print("codeAutoRetrievalTimeout");
                },
              );
            },
            child: const Text('Sign in'),
          ),
        ),
      ),
    );
  }
}
