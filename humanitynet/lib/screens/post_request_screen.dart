import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/request_provider.dart';
import '../utils/validators.dart';
//import '../routes/app_routes.dart';
import '../utils/constants.dart';

class PostRequestScreen extends StatefulWidget {
  const PostRequestScreen({super.key});

  @override
  State<PostRequestScreen> createState() => _PostRequestScreenState();
}

class _PostRequestScreenState extends State<PostRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _selectedCategory = '';
  bool _isUrgent = false;
  bool _isAnonymous = false;
  bool _isSubmitting = false;

  final Map<String, Map<String, dynamic>> _categoryData = {
    'Food': {
      'emoji': '🍎',
      'color': Color(0xFFFF6B35),
      'bg': Color(0xFFFFF3EE),
      'desc': 'Khana, Paani',
    },
    'Health': {
      'emoji': '🏥',
      'color': Color(0xFFEF4444),
      'bg': Color(0xFFFEF2F2),
      'desc': 'Dawa, Ilaaj',
    },
    'Education': {
      'emoji': '📚',
      'color': Color(0xFF3B82F6),
      'bg': Color(0xFFEFF6FF),
      'desc': 'Books, Fees',
    },
    'Clothing': {
      'emoji': '👕',
      'color': Color(0xFFA855F7),
      'bg': Color(0xFFFAF5FF),
      'desc': 'Kapde',
    },
  };

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // YEH CHECK ADD KARO SABSE PEHLE
    final auth = context.read<AuthProvider>();

    if (auth.currentUid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please login first!',
              style: GoogleFonts.outfit()),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }

    if (_selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a category! 📌',
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

    setState(() => _isSubmitting = true);

    final reqProvider = context.read<RequestProvider>();

    final result = await reqProvider.addRequest(
      title: _titleCtrl.text,
      description: _descCtrl.text,
      category: _selectedCategory,
      postedBy: auth.currentUid,
      postedByName: auth.user?.fullName?? '',
      city: auth.user?.city?? '',
      isUrgent: _isUrgent,
      isAnonymous: _isAnonymous,
    );

    setState(() => _isSubmitting = false);

    if (!mounted) return;

    if (result!= null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Request post ho gayi!',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
          backgroundColor: const Color(0xFF1DB954),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(reqProvider.errorMessage?? 'Error aaya',
              style: GoogleFonts.outfit()),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            'Post a Request',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fill in the details — someone will help you soon 🤝',
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

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category label
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      child: Text(
                        'Select Category *',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Category grid
                    FadeInUp(
                      delay: const Duration(milliseconds: 150),
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.6,
                        children: _categoryData.entries.map((entry) {
                          final cat = entry.key;
                          final data = entry.value;
                          final isSelected = _selectedCategory == cat;
                          final color = data['color'] as Color;
                          final bg = data['bg'] as Color;

                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedCategory = cat),
                            child: AnimatedContainer(
                              duration:
                                  const Duration(milliseconds: 250),
                              decoration: BoxDecoration(
                                color: isSelected? color : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                     ? color
                                      : Colors.grey[200]!,
                                  width: isSelected? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isSelected
                                       ? color.withOpacity(0.3)
                                        : Colors.black.withOpacity(0.04),
                                    blurRadius: isSelected? 16 : 8,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data['emoji'] as String,
                                    style: const TextStyle(fontSize: 28),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    cat,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                         ? Colors.white
                                          : const Color(0xFF1A1A2E),
                                    ),
                                  ),
                                  Text(
                                    data['desc'] as String,
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      color: isSelected
                                         ? Colors.white70
                                          : Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: _buildLabel('Request Title *'),
                    ),
                    const SizedBox(height: 8),
                    FadeInUp(
                      delay: const Duration(milliseconds: 220),
                      child: TextFormField(
                        controller: _titleCtrl,
                        maxLength: 60,
                        validator: Validators.requestTitle,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: const Color(0xFF1A1A2E),
                        ),
                        decoration: _inputDecoration(
                          'Kya chahiye? (e.g. Khana chahiye urgently)',
                          Icons.title_rounded,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Description
                    FadeInUp(
                      delay: const Duration(milliseconds: 250),
                      child: _buildLabel('Description *'),
                    ),
                    const SizedBox(height: 8),
                    FadeInUp(
                      delay: const Duration(milliseconds: 270),
                      child: TextFormField(
                        controller: _descCtrl,
                        maxLength: 300,
                        maxLines: 4,
                        validator: Validators.requestDescription,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          color: const Color(0xFF1A1A2E),
                        ),
                        decoration: _inputDecoration(
                          'Puri detail likho — jitni zyada detail, utni jaldi help milegi...',
                          Icons.description_rounded,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Urgent toggle
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      child: _buildToggle(
                        icon: '🚨',
                        iconBg: const Color(0xFFFEF2F2),
                        title: 'Urgent Request',
                        subtitle:
                            'Feed ke top pe aayegi + everyone ko notification',
                        value: _isUrgent,
                        activeColor: const Color(0xFFEF4444),
                        onChanged: (v) =>
                            setState(() => _isUrgent = v),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Anonymous toggle
                    FadeInUp(
                      delay: const Duration(milliseconds: 330),
                      child: _buildToggle(
                        icon: '👤',
                        iconBg: const Color(0xFFF1F5F9),
                        title: 'Anonymous Mode',
                        subtitle:
                            'Tumhara naam nahi dikhega — dignity protected',
                        value: _isAnonymous,
                        activeColor: const Color(0xFF6B7FD4),
                        onChanged: (v) =>
                            setState(() => _isAnonymous = v),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Submit button
                    FadeInUp(
                      delay: const Duration(milliseconds: 360),
                      child: GestureDetector(
                        onTap: _isSubmitting? null : _submit,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1DB954),
                                Color(0xFF0F9C3F)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1DB954)
                                   .withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          child: Center(
                            child: _isSubmitting
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
                                        Icons.send_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Post Request',
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A1A2E),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
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
            color: Color(0xFF1DB954), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
            const BorderSide(color: Color(0xFFEF4444)),
      ),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
    );
  }

  Widget _buildToggle({
    required String icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool value,
    required Color activeColor,
    required ValueChanged<bool> onChanged,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: value? activeColor.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
              value? activeColor.withOpacity(0.3) : Colors.grey[200]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(icon,
                  style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
          ),
        ],
      ),
    );
  }
}
