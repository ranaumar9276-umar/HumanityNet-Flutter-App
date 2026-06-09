import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey     = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  final _cityCtrl    = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _confirmCtrl = TextEditingController();

  String _accountType = 'individual';
  XFile? _selfie;
  bool _selfieError = false;
  int _currentStep = 0;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _takeSelfie() async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 80,
    );
    if (photo != null) {
      setState(() {
        _selfie = photo;
        _selfieError = false;
      });
    }
  }

  Future<void> _register() async {
    if (_selfie == null) {
      setState(() => _selfieError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selfie lena zaroori hai! 📸',
              style: GoogleFonts.outfit()),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      fullName:    _nameCtrl.text,
      email:       _emailCtrl.text,
      password:    _passCtrl.text,
      phone:       _phoneCtrl.text,
      city:        _cityCtrl.text,
      accountType: _accountType,
      selfieFile:  _selfie,
    );

    if (!mounted) return;

    if (success) {
      _showPendingDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Error aaya',
              style: GoogleFonts.outfit()),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showPendingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFFFFBEB),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('⏳', style: TextStyle(fontSize: 36)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Verification Pending',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tumhara account admin ke paas verification ke liye bhej diya gaya hai. '
              'Approve hone ke baad tum app use kar sakte ho.\n\n'
              'Usually 24 hours mein approve ho jaata hai.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(
                    context, AppRoutes.login);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1a237e), Color(0xFF283593)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Theek Hai',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Column(
        children: [
          // Header
          FadeInDown(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1a237e), Color(0xFF283593)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Create Account',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Real verification — sirf genuine log',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Account type
                    FadeInUp(
                      delay: const Duration(milliseconds: 80),
                      child: _sectionLabel(
                          'Main kya karna chahta/chahti hoon?'),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: Row(
                        children: [
                          Expanded(
                            child: _accountTypeCard(
                              type: 'individual',
                              emoji: '🙏',
                              title: 'Need Help',
                              subtitle: 'Mujhe help chahiye',
                              color: const Color(0xFF6B7FD4),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _accountTypeCard(
                              type: 'helper',
                              emoji: '🤝',
                              title: 'Give Help',
                              subtitle: 'Main help dena chahta hoon',
                              color: const Color(0xFF1DB954),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Selfie
                    FadeInUp(
                      delay: const Duration(milliseconds: 130),
                      child: _sectionLabel('Live Selfie — Verification ke liye *'),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      delay: const Duration(milliseconds: 150),
                      child: GestureDetector(
                        onTap: _takeSelfie,
                        child: Container(
                          width: double.infinity,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _selfieError
                                  ? const Color(0xFFEF4444)
                                  : _selfie != null
                                      ? const Color(0xFF1DB954)
                                      : Colors.grey[300]!,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                              )
                            ],
                          ),
                          child: _selfie != null
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(15),
                                  child: Image.file(
                                    File(_selfie!.path),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 56, height: 56,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1a237e)
                                            .withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_front_rounded,
                                        color: Color(0xFF1a237e),
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Camera se selfie lo',
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1a237e),
                                      ),
                                    ),
                                    Text(
                                      'Gallery se nahi — camera se hi lena hai',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    if (_selfie != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Color(0xFF1DB954), size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Selfie li gayi ✅',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: const Color(0xFF1DB954),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: _takeSelfie,
                            child: Text(
                              'Dubara lo',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: const Color(0xFF6B7FD4),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 20),

                    // Fields
                    _sectionLabel('Personal Information'),
                    const SizedBox(height: 12),

                    _buildField(
                      delay: 180,
                      controller: _nameCtrl,
                      hint: 'Full Name',
                      icon: Icons.person_outline_rounded,
                      validator: Validators.fullName,
                    ),
                    const SizedBox(height: 12),

                    _buildField(
                      delay: 200,
                      controller: _emailCtrl,
                      hint: 'Email Address',
                      icon: Icons.email_outlined,
                      type: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: 12),

                    _buildField(
                      delay: 220,
                      controller: _phoneCtrl,
                      hint: 'Phone Number (e.g. 03001234567)',
                      icon: Icons.phone_outlined,
                      type: TextInputType.phone,
                      validator: Validators.phone,
                    ),
                    const SizedBox(height: 12),

                    _buildField(
                      delay: 240,
                      controller: _cityCtrl,
                      hint: 'City (e.g. Faisalabad)',
                      icon: Icons.location_city_outlined,
                      validator: Validators.city,
                    ),
                    const SizedBox(height: 12),

                    _buildField(
                      delay: 260,
                      controller: _passCtrl,
                      hint: 'Password (min 8 characters)',
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: 12),

                    _buildField(
                      delay: 280,
                      controller: _confirmCtrl,
                      hint: 'Confirm Password',
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      validator: (val) => Validators.confirmPassword(
                          val, _passCtrl.text),
                    ),

                    const SizedBox(height: 16),

                    // Info box
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFBFDBFE),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text('ℹ️',
                                style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Tumhara account admin review ke baad approve hoga. '
                                'Sirf genuine logon ko approve kiya jaata hai. '
                                'Selfie se identity verify hoti hai.',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: const Color(0xFF1E40AF),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Register button
                    FadeInUp(
                      delay: const Duration(milliseconds: 320),
                      child: GestureDetector(
                        onTap: auth.isLoading ? null : _register,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1a237e),
                                Color(0xFF283593),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1a237e)
                                    .withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          child: Center(
                            child: auth.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.verified_user_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Create Account',
                                        style: GoogleFonts.outfit(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Login link
                    FadeInUp(
                      delay: const Duration(milliseconds: 340),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Account hai? ',
                            style: GoogleFonts.outfit(
                                color: Colors.grey[600]),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              'Login Karo',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF1a237e),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountTypeCard({
    required String type,
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    final isSelected = _accountType == type;
    return GestureDetector(
      onTap: () => setState(() => _accountType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.2)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? color : const Color(0xFF1A1A2E),
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.outfit(
                fontSize: 11,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            if (isSelected) ...[
              const SizedBox(height: 6),
              Icon(Icons.check_circle_rounded,
                  color: color, size: 18),
            ]
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A1A2E),
      ),
    );
  }

  Widget _buildField({
    required int delay,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType type = TextInputType.text,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        validator: validator,
        style: GoogleFonts.outfit(
          fontSize: 14,
          color: const Color(0xFF1A1A2E),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.outfit(
            fontSize: 13,
            color: Colors.grey[400],
          ),
          prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
                color: Color(0xFF1a237e), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Color(0xFFEF4444)),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}