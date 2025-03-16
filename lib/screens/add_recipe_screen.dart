import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _addRecipe() async {
    User? user = _auth.currentUser;

    if (user == null) {
      _showErrorDialog("กรุณาเข้าสู่ระบบก่อนเพิ่มสูตรอาหาร");
      return;
    }

    if (_nameController.text.isEmpty || 
        _ingredientsController.text.isEmpty || 
        _instructionsController.text.isEmpty) {
      _showErrorDialog("กรุณากรอกชื่ออาหาร ส่วนผสม และวิธีทำให้ครบถ้วน");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('recipes').add({
        'name': _nameController.text,
        'imageUrl': _imageUrlController.text,
        'ingredients': _ingredientsController.text.split(','),
        'instructions': _instructionsController.text,
        'cookTime': _cookTimeController.text,
        'servings': _servingsController.text,
        'createdBy': user.displayName ?? user.email ?? 'ไม่ทราบชื่อ',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showSuccessMessage();
    } catch (e) {
      _showErrorDialog("เกิดข้อผิดพลาด: ${e.toString()}");
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text('บันทึกสูตรอาหารเรียบร้อยแล้ว!'),
          ],
        ),
        backgroundColor: Color(0xFFFF85A2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('เกิดข้อผิดพลาด', style: GoogleFonts.prompt(color: Color(0xFFFF5C8D))),
        content: Text(message, style: GoogleFonts.prompt()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ตกลง', style: GoogleFonts.prompt(color: Color(0xFFFF5C8D))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "✨ เพิ่มสูตรอาหารแสนอร่อย ✨",
          style: GoogleFonts.prompt(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInputField(_nameController, "ชื่ออาหาร", Icons.restaurant_menu, required: true),
            SizedBox(height: 12),
            _buildInputField(_imageUrlController, "URL รูปภาพ", Icons.image),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildInputField(_cookTimeController, "เวลาทำ (นาที)", Icons.timer)),
                SizedBox(width: 12),
                Expanded(child: _buildInputField(_servingsController, "จำนวนเสิร์ฟ", Icons.people)),
              ],
            ),
            SizedBox(height: 12),
            _buildInputField(_ingredientsController, "ส่วนผสม (คั่นด้วย ,)", Icons.shopping_cart, maxLines: 3, required: true),
            SizedBox(height: 12),
            _buildInputField(_instructionsController, "วิธีทำ", Icons.format_list_numbered, maxLines: 5, required: true),
            SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    bool required = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: required ? "$label *" : label,
        labelStyle: GoogleFonts.prompt(color: Color(0xFFD27D93)),
        prefixIcon: Icon(icon, color: Color(0xFFF48FB1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Color(0xFFFFD6DD), width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _addRecipe,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFF5C8D),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
      child: Text(
        "บันทึกสูตรอาหาร",
        style: GoogleFonts.prompt(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    super.dispose();
  }
}
