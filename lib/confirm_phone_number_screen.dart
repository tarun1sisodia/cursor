import 'package:firebase/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase/custom_text_form_field.dart';

class ConfirmPhoneNumberScreen extends StatefulWidget {
  final String verificationId;
  final String email;
  final String password;
  final String username;

  const ConfirmPhoneNumberScreen({
    super.key,
    required this.verificationId,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  _ConfirmPhoneNumberScreenState createState() =>
      _ConfirmPhoneNumberScreenState();
}

class _ConfirmPhoneNumberScreenState extends State<ConfirmPhoneNumberScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  void _confirmCode() async {
    setState(() => _isLoading = true);

    try {
      // First verify the OTP
      PhoneAuthCredential phoneCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpController.text.trim(),
      );

      // Create user account with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: widget.email,
            password: widget.password,
          );

      // Update the user profile with username
      await userCredential.user?.updateDisplayName(widget.username);

      // Show success message and navigate to login
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.login,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Incorrect OTP! Please enter correct OTP for next step.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Phone Number')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextFormField(
              controller: _otpController,
              label: 'Enter OTP',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the OTP';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _confirmCode,
              child:
                  _isLoading ? const CircularProgressIndicator() : const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
