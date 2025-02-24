import 'package:firebase/app_pallete.dart';
import 'package:flutter/material.dart';
import 'package:firebase/routes.dart';
import 'package:firebase/utils/validators.dart';
import 'package:firebase/custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isPasswordValid = false;
  bool _doPasswordsMatch = false;
  double _opacity = 0.0;
  String _passwordStrength = '';
  Color _passwordStrengthColor = Colors.grey;
  bool _termsAccepted = false;
  final bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Fade in effect
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Add listeners for password validation
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_validatePassword);
    _confirmPasswordController.removeListener(_validatePassword);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      // Check password strength
      if (password.isEmpty) {
        _passwordStrength = '';
        _passwordStrengthColor = Colors.grey;
        _isPasswordValid = false;
      } else if (password.length < 6) {
        _passwordStrength = 'Weak';
        _passwordStrengthColor = Colors.red;
        _isPasswordValid = false;
      } else if (password.length < 8) {
        _passwordStrength = 'Medium';
        _passwordStrengthColor = Colors.orange;
        _isPasswordValid = true;
      } else if (_hasStrongPassword(password)) {
        _passwordStrength = 'Strong';
        _passwordStrengthColor = Colors.green;
        _isPasswordValid = true;
      } else {
        _passwordStrength = 'Medium';
        _passwordStrengthColor = Colors.orange;
        _isPasswordValid = true;
      }

      // Check if passwords match
      _doPasswordsMatch = password.isNotEmpty && password == confirmPassword;
    });
  }

  bool _hasStrongPassword(String password) {
    // Check for at least one uppercase letter
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    // Check for at least one lowercase letter
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    // Check for at least one number
    bool hasNumber = password.contains(RegExp(r'[0-9]'));
    // Check for at least one special character
    bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    return password.length >= 8 &&
        hasUppercase &&
        hasLowercase &&
        hasNumber &&
        hasSpecialChar;
  }

  String? _getPasswordError() {
    final password = _passwordController.text;
    if (password.isEmpty) return null;
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!_hasStrongPassword(password)) {
      return 'Password should contain uppercase, lowercase, number, and special character';
    }
    return null;
  }

  String? _getConfirmPasswordError() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (confirmPassword.isEmpty) return null;
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleRegistration() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the terms and conditions'),
            backgroundColor: Colors.blue,
          ),
        );
        return;
      }

      // Navigate to AddPhoneNumberScreen with user data
      Navigator.pushNamed(
        context,
        '/add-phone-number',
        arguments: RegistrationArguments(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          username: _usernameController.text.trim(),
        ),
      );
    }
  }
      // setState(() {
      //   _isLoading = true;
      // });

      // try {
      //   // Generate and store UUIDs
      //   final userUUID = AppConfig.generateUUID();
      //   final deviceUUID = await AppConfig.getDeviceUUID();

      //   UserCredential userCredential = await FirebaseAuth.instance
      //       .createUserWithEmailAndPassword(
      //         email: _emailController.text.trim(),
      //         password: _passwordController.text,
      //       );

      //   // Store the user UUID
      //   await AppConfig.storeUserUUID(userUUID);

      //   // Add username and additional data to Firebase user profile
      //   await userCredential.user?.updateDisplayName(
      //     _usernameController.text.trim(),
      //   );

      //   // Print identification information
      //   print('User Information:');
      //   print('Firebase UID: ${userCredential.user?.uid}');
      //   print('Generated User UUID: $userUUID');
      //   print('Device UUID: $deviceUUID');
      //   print('Username: ${_usernameController.text.trim()}');
      //   print('Email: ${_emailController.text.trim()}');

      //   // Show success message and navigate to login
      //   if (mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(
      //         content: Text('Registration successful! Please login.'),
      //         backgroundColor: Colors.green,
      //       ),
      //     );
      //     Navigator.pushReplacementNamed(context, Routes.login);
      //   }
      // } on FirebaseAuthException catch (e) {
      //   String errorMessage = 'Registration failed';
      //   if (e.code == 'weak-password') {
      //     errorMessage = 'The password provided is too weak';
      //   } else if (e.code == 'email-already-in-use') {
      //     errorMessage = 'An account already exists for this email';
      //   } else if (e.code == 'invalid-email') {
      //     errorMessage = 'Please enter a valid email address';
      //   }
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      //   );
      // } catch (e) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Error: ${e.toString()}'),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // } finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Join our community and Experience a seamless tracking your relationship',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                CustomTextFormField(
                  controller: _usernameController,
                  label: 'Username',
                  validator: Validators.validateUsername,
                  keyboardType: TextInputType.text,
                  enabled: true,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _emailController,
                  label: 'Email',
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _passwordController,
                  label: 'Password',
                  validator: Validators.validatePassword,
                  obscureText: _obscurePassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                if (_passwordStrength.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Text(
                          'Password Strength: ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _passwordStrength,
                          style: TextStyle(
                            color: _passwordStrengthColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  validator:
                      (value) => Validators.validateConfirmPassword(
                        value,
                        _passwordController.text,
                      ),
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (value) {
                        setState(() {
                          _termsAccepted = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'By agreeing to the terms and conditions, you are entering into a legally binding contract with the service provider.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.purple, Colors.yellowAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegistration,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                            : const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.login);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Apppallete.lightGrey),
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
