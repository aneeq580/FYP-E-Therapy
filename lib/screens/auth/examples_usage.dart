/// Example Usage - Auth Screens Integration
///
/// This file demonstrates how to integrate the authentication screens
/// into your main app navigation.
///
/// Note: Copy relevant parts to your actual app files.
library examples_usage;

// ============================================================================
// EXAMPLE 1: Basic Integration in main.dart
// ============================================================================

import 'package:flutter/material.dart';
import 'package:fyp_therapy/screens/auth/role_selection_screen.dart';
import 'screens/auth/role_selection_screen.dart';

void main() {
  runApp(const TherapyApp());
}

class TherapyApp extends StatelessWidget {
  const TherapyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Therapy App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins', // Optional: add your custom font
      ),
      home: const RoleSelectionScreen(),
      // When you add navigation routes later:
      // routes: {
      //   '/role-selection': (_) => const RoleSelectionScreen(),
      //   '/login': (_) => const LoginScreen(),
      //   '/signup': (_) => const SignupScreen(),
      // },
    );
  }
}

// ============================================================================
// EXAMPLE 2: Adding Navigation to RoleSelectionScreen
// ============================================================================

/*
In role_selection_screen.dart, update the Continue button:

AuthButton(
  label: 'Continue',
  onPressed: selectedRole == null
      ? () {}
      : () {
          // Navigate to appropriate screen based on role
          if (selectedRole == 'patient') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        },
),
*/

// ============================================================================
// EXAMPLE 3: Adding Navigation Between Login and Signup
// ============================================================================

/*
In login_screen.dart, update the sign-up link:

GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  },
  child: const Text('Sign Up'),
),

In signup_screen.dart, update the login link:

GestureDetector(
  onTap: () {
    Navigator.pop(context); // Go back to login
    // Or if on a separate flow:
    // Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()))
  },
  child: const Text('Log In'),
),
*/

// ============================================================================
// EXAMPLE 4: Backend Integration with Firebase (Future)
// ============================================================================

/*
When you're ready to add backend logic, update LoginScreen.dart:

import 'package:firebase_auth/firebase_auth.dart';

// In the login button's onPressed:
AuthButton(
  label: 'Login',
  isLoading: isLoading,
  onPressed: () async {
    // Validate inputs
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Authenticate with Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Navigate to home screen
      Navigator.of(context).pushReplacementNamed('/home');
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Login failed';
      
      if (e.code == 'user-not-found') {
        errorMessage = 'No account found with this email';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() => isLoading = false);
    }
  },
),
*/

// ============================================================================
// EXAMPLE 5: Backend Integration with Django (Future)
// ============================================================================

/*
When using Django backend, update SignupScreen.dart:

import 'package:http/http.dart' as http;
import 'dart:convert';

AuthButton(
  label: 'Create Account',
  isLoading: isLoading,
  onPressed: agreedToTerms ? () async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://your-backend.com/api/auth/signup/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'full_name': fullNameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'password_confirm': confirmPasswordController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
          ),
        );
        Navigator.pop(context);
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['message'] ?? 'Signup failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  } : () {},
),
*/

// ============================================================================
// EXAMPLE 6: Custom Theme/Colors (Optional Enhancement)
// ============================================================================

/*
Create a colors.dart file in lib/core/constants/:

class AppColors {
  // Primary
  static const Color primaryPurple = Color(0xFF7B68C0);
  static const Color primaryLight = Color(0xFFF0EBF8);

  // Text
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textGray = Color(0xFF5A6B7E);

  // Backgrounds
  static const Color bgWhite = Color(0xFFFCFDFE);
  static const Color bgLight = Color(0xFFF5F7FA);

  // Borders
  static const Color borderLight = Color(0xFFE0E6ED);
}

// Then update widgets to use these constants:
// backgroundColor: AppColors.primaryPurple
*/

// ============================================================================
// EXAMPLE 7: Responsive Design for Tablets (Optional Enhancement)
// ============================================================================

/*
Make login screen responsive:

@override
Widget build(BuildContext context) {
  final isMobile = MediaQuery.of(context).size.width < 600;
  
  return Scaffold(
    body: Center(
      child: SizedBox(
        width: isMobile ? double.infinity : 400,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 40,
              vertical: isMobile ? 32 : 48,
            ),
            // ... rest of form
          ),
        ),
      ),
    ),
  );
}
*/

// ============================================================================
// EXAMPLE 8: Complete Integration Flow
// ============================================================================

/*
Step-by-step integration:

1. Copy auth folder to lib/screens/
2. Update imports in your main.dart
3. Set RoleSelectionScreen as home or initial route
4. Add navigation between screens (see Example 3)
5. Test all screens work together
6. Add backend code (see Examples 4-5)
7. Add validation and error handling
8. Test end-to-end authentication flow

Testing checklist:
✓ Role selection works
✓ Can navigate to login from role selection
✓ Can navigate to signup from login
✓ Can navigate back to login from signup
✓ All input fields accept text
✓ Password visibility toggle works
✓ All buttons are clickable
✓ Loading states appear
✓ Text colors and spacing look good
*/

// ============================================================================
// STYLING TIPS
// ============================================================================

/*
To enhance the UI further:

1. Add custom fonts in pubspec.yaml:
   dependencies:
     google_fonts: ^5.0.0

   Then use in themes:
   fontFamily: GoogleFonts.poppins().fontFamily,

2. Add animations to role cards:
   - ScaleTransition for selection
   - SlideTransition when navigating

3. Add input field validation:
   - Real-time email format check
   - Password strength meter
   - Confirm password match indicator

4. Add loading skeleton:
   - Before data loads
   - Smooth transition animations

5. Improve accessibility:
   - Add semantic labels
   - Better focus states
   - Higher contrast options
*/
