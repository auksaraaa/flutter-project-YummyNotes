import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/screens/edit_profile_screen.dart';
import 'package:flutter/services.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "โปรไฟล์ของฉัน",
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
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFFFEDFA), Color(0xFFFF8DA1)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ClipOval(
                            child:
                                user?.photoURL != null
                                    ? Image.network(
                                      user!.photoURL!,
                                      fit: BoxFit.cover,
                                      width: 120,
                                      height: 120,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Image.asset(
                                          "assets/default_avatar.png",
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    )
                                    : Image.asset(
                                      "assets/default_avatar.png",
                                      fit: BoxFit.cover,
                                    ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Text(
                              user?.displayName ?? "ไม่ทราบชื่อ",
                              style: GoogleFonts.prompt(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
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
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                user?.email ?? "ไม่มีอีเมล",
                                style: GoogleFonts.prompt(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
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
                        children: [
                          _buildProfileButton("แก้ไขโปรไฟล์", Icons.edit, () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        EditProfileScreen(),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  var begin = Offset(1.0, 0.0);
                                  var end = Offset.zero;
                                  var curve = Curves.easeInOut;
                                  var tween = Tween(
                                    begin: begin,
                                    end: end,
                                  ).chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          }),
                          const SizedBox(height: 15),
                          _buildProfileButton(
                            "ออกจากระบบ",
                            Icons.logout,
                            () async {
                              HapticFeedback.mediumImpact();
                              bool confirm =
                                  await showDialog(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          title: Text(
                                            "ออกจากระบบ",
                                            style: GoogleFonts.prompt(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Text(
                                            "คุณต้องการออกจากระบบใช่หรือไม่?",
                                            style: GoogleFonts.prompt(),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    false,
                                                  ),
                                              child: Text(
                                                "ยกเลิก",
                                                style: GoogleFonts.prompt(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed:
                                                  () => Navigator.pop(
                                                    context,
                                                    true,
                                                  ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(
                                                  0xFFFF5C8D,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              child: Text(
                                                "ออกจากระบบ",
                                                style: GoogleFonts.prompt(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  ) ??
                                  false;

                              if (confirm) {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushReplacementNamed(
                                  context,
                                  "/login",
                                );
                              }
                            },
                            isLogout: true,
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
    );
  }

  Widget _buildProfileButton(
    String text,
    IconData icon,
    VoidCallback onPressed, {
    bool isLogout = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: isLogout ? Colors.white : Colors.white),
        label: Text(
          text,
          style: GoogleFonts.prompt(
            fontSize: 16,
            color: isLogout ? Colors.white : Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isLogout ? Colors.redAccent.shade200 : Color(0xFFFF5C8D),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(vertical: 14),
          elevation: 3,
          shadowColor:
              isLogout
                  ? Color(0xFFFFEDFA).withOpacity(0.5)
                  : Color(0xFFFF5C8D).withOpacity(0.5),
        ),
      ),
    );
  }
}
