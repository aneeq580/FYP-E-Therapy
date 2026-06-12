import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/auth_controller.dart';
import 'package:fyp_therapy/routes/app_routes.dart';
import 'package:fyp_therapy/views/auth/signup/custom_text_field.dart';
import 'package:fyp_therapy/core/constants/colors.dart';
import 'package:file_picker/file_picker.dart';

class SignupScreen extends StatefulWidget {
  final String role;

  const SignupScreen({super.key, required this.role});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? pickedFileName;
  String? pickedFilePath;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickDegreeFile() async {
    try {
      print("Attempting to pick degree file...");
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
      );

      if (result != null) {
        print("File picked: ${result.files.single.name}");
        setState(() {
          pickedFileName = result.files.single.name;
          pickedFilePath = result.files.single.path;
        });
      } else {
        print("User cancelled the picker.");
      }
    } catch (e) {
      print("Error picking file: $e");
      Get.snackbar(
        "Picker Error",
        "Could not open file picker: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isTherapist = widget.role.toLowerCase() == 'therapist';

    final primaryColor = isTherapist
        ? AppColors.therapistPrimary
        : AppColors.primary;
    final secondaryColor = isTherapist
        ? AppColors.therapistPrimaryLight
        : AppColors.primaryLight;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Sign Up Screen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.backgroundLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Curved Header matches AppBar Color
              SizedBox(
                height: 150,
                width: double.infinity,
                child: CustomPaint(
                  painter: _HeaderPainter(
                    color: primaryColor,
                    lightColor: secondaryColor,
                  ),
                ),
              ),

              // Form Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 85, 8, 75),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enter your Personal Data",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Fields
                    CustomTextField(
                      hint: "First Name",
                      controller: firstNameController,
                      borderColor: primaryColor,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hint: "Last Name",
                      controller: lastNameController,
                      borderColor: primaryColor,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hint: "Email",
                      controller: emailController,
                      borderColor: primaryColor,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hint: "Phone Number",
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      borderColor: primaryColor,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hint: "Create Password",
                      controller: passwordController,
                      isPassword: true,
                      borderColor: primaryColor,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      hint: "Confirm Password",
                      controller: confirmPasswordController,
                      isPassword: true,
                      borderColor: primaryColor,
                    ),
                    const SizedBox(height: 16),

                    if (isTherapist) ...[
                      // Degree Upload
                      GestureDetector(
                        onTap: _pickDegreeFile,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: primaryColor, width: 1.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  pickedFileName ?? "Upload Degree Document",
                                  style: TextStyle(
                                    color: pickedFileName != null
                                        ? Colors.black87
                                        : primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(Icons.upload_file, color: primaryColor),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ] else ...[
                      const SizedBox(height: 8),
                    ],

                    // Signup Button
                    Obx(() {
                      final bool disabled = authController.isLoading.value;
                      return ElevatedButton(
                        onPressed: () {
                          if (disabled) return;
                          if (passwordController.text.trim() !=
                              confirmPasswordController.text.trim()) {
                            Get.snackbar(
                              'Error',
                              'Passwords do not match',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }
                          if (isTherapist && pickedFilePath == null) {
                            Get.snackbar(
                              'Error',
                              'Please upload your degree document',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          authController.updatePersonalDetails(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            phoneNum: phoneController.text,
                            degreePath: pickedFilePath,
                          );
                          authController.updateCredentials(
                            email: emailController.text,
                            password: passwordController.text,
                            role: widget.role,
                          );
                          authController.handleSignup();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          disabled ? "Please wait..." : "Signup",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 20),

                    // Terms & Policies
                    Text(
                      "By continuing you are agreeing to our Terms of Use and our privacy policies",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "or signup with google",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.shade300,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Google Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor.withOpacity(0.8),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Continue with Google",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an Account? ",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.offNamed(
                              AppRoutes.login,
                              arguments: widget.role,
                            );
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderPainter extends CustomPainter {
  final Color color;
  final Color lightColor;

  _HeaderPainter({required this.color, required this.lightColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Fill the very top so there's no gap under AppBar
    var squarePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Fill the background of the top curve
    var paint1 = Paint()
      ..color = lightColor.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    var path1 = Path();
    path1.lineTo(0, size.height * 0.75);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height * 0.85,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.9,
    );
    path1.lineTo(size.width, 0);
    path1.close();
    canvas.drawPath(path1, paint1);

    var paint2 = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    var path2 = Path();
    path2.lineTo(0, size.height * 0.65);
    path2.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.85,
      size.width * 0.5,
      size.height * 0.75,
    );
    path2.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.65,
      size.width,
      size.height * 0.8,
    );
    path2.lineTo(size.width, 0);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
