import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      email: _emailCtrl.text,
      password: _passCtrl.text,
    );

    if (!mounted) return;

    if (success) {
      final user = auth.user;

      // Verification status check
      if (user!= null &&!user.isAdmin) {
        if (user.verificationStatus == 'pending') {
          _showStatusDialog(
            emoji: '⏳',
            title: 'Verification Pending',
            message: 'Tumhara account abhi review mein hai. '
                'Jald hi approve ho jaayega.\n\n'
                'Agar zyada time lage toh support se rabta karo.',
            color: const Color(0xFFF59E0B),
          );
          await auth.logout();
          return;
        }

        if (user.verificationStatus == 'rejected') {
          _showStatusDialog(
            emoji: '❌',
            title: 'Account Rejected',
            message: 'Tumhara account verify nahi ho saka.\n\n'
                'Wajah: ${user.verificationNote.isNotEmpty? user.verificationNote : "Information sahi nahi thi"}\n\n'
                'Sahi information ke saath dobara register karo.',
            color: const Color(0xFFEF4444),
          );
          await auth.logout();
          return;
        }
      }

      // Approved — home pe jao
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            auth.errorMessage?? 'Login failed',
            style: GoogleFonts.outfit(),
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _showStatusDialog({
    required String emoji,
    required String title,
    required String message,
    required Color color,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 52)),
            const SizedBox(height: 14),
            Text(
              title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: color,
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
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      24, 40, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1DB954),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.white, size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'HumanityNet',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome Back 👋',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Login karke madad karo ya maango',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
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
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Email
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: _buildField(
                        controller: _emailCtrl,
                        hint: 'Email address',
                        icon: Icons.email_outlined,
                        type: TextInputType.emailAddress,
                        validator: Validators.email,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password
                    FadeInUp(
                      delay: const Duration(milliseconds: 150),
                      child: _buildPasswordField(),
                    ),

                    const SizedBox(height: 10),

                    // Forgot password
                    FadeInUp(
                      delay: const Duration(milliseconds: 180),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF1a237e),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Login button
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: GestureDetector(
                        onTap: auth.isLoading? null : _login,
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
                                    width: 24, height: 24,
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
                                        Icons.login_rounded,
                                        color: Colors.white, size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Login',
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

                    const SizedBox(height: 24),

                    // Divider
                    FadeInUp(
                      delay: const Duration(milliseconds: 230),
                      child: Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12),
                            child: Text(
                              'YA',
                              style: GoogleFonts.outfit(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Register link
                    FadeInUp(
                      delay: const Duration(milliseconds: 260),
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.register),
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF1a237e)
                                 .withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Naya Account Banao',
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1a237e),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Info
                    FadeInUp(
                      delay: const Duration(milliseconds: 290),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFBBF7D0),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text('🛡️',
                                style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Sirf verified users hi app use kar sakte hain. '
                                'AI + Admin dono milkar verification karte hain.',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: const Color(0xFF166534),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validator,
      style: GoogleFonts.outfit(
        fontSize: 14,
        color: const Color(0xFF1A1A2E),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(
          fontSize: 13, color: Colors.grey[400],
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
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
      ),
    );
  }

  // ✅ FIXED METHOD - obscure variable sahi jagah pe hai
  Widget _buildPasswordField() {
    bool obscure = true;
    return StatefulBuilder(
      builder: (context, setLocalState) {
        return TextFormField(
          controller: _passCtrl,
          obscureText: obscure,
          validator: Validators.password,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: const Color(0xFF1A1A2E),
          ),
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: GoogleFonts.outfit(
              fontSize: 13,
              color: Colors.grey[400],
            ),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: Colors.grey[400],
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                   ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey[400],
                size: 20,
              ),
              onPressed: () =>
                  setLocalState(() => obscure =!obscure),
            ),
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
        );
      },
    );
  }
}