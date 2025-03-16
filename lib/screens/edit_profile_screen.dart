import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String _previewImageUrl = '';

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Load user data
    final user = _auth.currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? "";
      _imageUrlController.text = user.photoURL ?? "";
      _previewImageUrl = user.photoURL ?? "";

      _loadUserData(user.uid);
    }

    // Add listener to update preview
    _imageUrlController.addListener(() {
      setState(() {
        _previewImageUrl = _imageUrlController.text;
      });
    });

    // Start animation
    _animationController.forward();
  }

  void _loadUserData(String uid) async {
    try {
      final userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userData.exists && mounted) {
        setState(() {
          _nameController.text = userData['name'] ?? _nameController.text;
          _imageUrlController.text =
              userData['photoUrl'] ?? _imageUrlController.text;
          _previewImageUrl = _imageUrlController.text;
        });
      }
    } catch (e) {
      // Error handling
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Add haptic feedback
      HapticFeedback.mediumImpact();

      await user.updateDisplayName(_nameController.text);
      await user.updatePhotoURL(_imageUrlController.text);

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text,
        'photoUrl': _imageUrlController.text,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        // Success animation and snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "อัปเดตโปรไฟล์เรียบร้อยแล้ว!",
                  style: GoogleFonts.prompt(),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "เกิดข้อผิดพลาด: ${e.toString()}",
                    style: GoogleFonts.prompt(),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "แก้ไขโปรไฟล์",
          style: GoogleFonts.prompt(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(1, 1),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFFF5C8D), Color(0xFFFF8DA1)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      // Profile Image Preview
                      Hero(
                        tag: 'profileImage',
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: ClipOval(
                            child:
                                _previewImageUrl.isNotEmpty
                                    ? Image.network(
                                      _previewImageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: Icon(
                                            Icons.person,
                                            size: 80,
                                            color: Colors.grey[400],
                                          ),
                                        );
                                      },
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Color(0xFFFF5C8D),
                                                ),
                                          ),
                                        );
                                      },
                                    )
                                    : Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Colors.grey[400],
                                    ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      // Form Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ข้อมูลส่วนตัว",
                              style: GoogleFonts.prompt(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF5C8D),
                              ),
                            ),
                            Divider(
                              height: 30,
                              thickness: 1,
                              color: Colors.grey[200],
                            ),
                            _buildAnimatedInputField(
                              _nameController,
                              "ชื่อ",
                              Icons.person,
                              delay: 0,
                            ),
                            SizedBox(height: 20),
                            _buildAnimatedInputField(
                              _imageUrlController,
                              "URL รูปโปรไฟล์",
                              Icons.image,
                              delay: 100,
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      // Button
                      _isLoading
                          ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                          : ElevatedButton(
                            onPressed: _updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFFFF5C8D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 32,
                              ),
                              elevation: 8,
                              shadowColor: Colors.black38,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.save),
                                SizedBox(width: 8),
                                Text(
                                  "บันทึกการเปลี่ยนแปลง",
                                  style: GoogleFonts.prompt(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedInputField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int delay = 0,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: GoogleFonts.prompt(color: Color(0xFFFF5C8D)),
                prefixIcon: Icon(icon, color: Color(0xFFFF5C8D)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xFFFFD6DD), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xFFFFD6DD), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Color(0xFFFF5C8D), width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: GoogleFonts.prompt(),
              onChanged: (_) => setState(() {}),
            ),
          ),
        );
      },
    );
  }
}
