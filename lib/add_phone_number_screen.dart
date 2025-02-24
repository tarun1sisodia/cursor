import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase/routes.dart';
import 'package:firebase/custom_text_form_field.dart';

class AddPhoneNumberScreen extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPhoneNumberScreen({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  _AddPhoneNumberScreenState createState() => _AddPhoneNumberScreenState();
}

class _AddPhoneNumberScreenState extends State<AddPhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _sendCode() async {
    String phoneNumber = _phoneController.text.trim();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (mounted) {
            Navigator.pushReplacementNamed(context, Routes.login);
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
          }
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
        print('Verification failed: ${e.code} - ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.pushNamed(
          context,
          '/confirm-phone-number',
          arguments: VerificationArguments(
            verificationId: verificationId,
            email: widget.email,
            password: widget.password,
            username: widget.username,
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Phone Number')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(
              controller: _phoneController,
              label: 'Phone Number',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendCode,
              child: Text('Send me the code'),
            ),
          ],
        ),
      ),
    );
  }
}
