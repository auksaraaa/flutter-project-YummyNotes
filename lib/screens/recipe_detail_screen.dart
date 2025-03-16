import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeDetailScreen extends StatefulWidget {
  final QueryDocumentSnapshot recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'recipe-${widget.recipe.id}',
                    child: Image.network(
                      widget.recipe['imageUrl'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [Color(0xFFFFEDFA), Colors.transparent],
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                widget.recipe['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isFavorite
                            ? 'เพิ่มในรายการโปรดแล้ว'
                            : 'ลบออกจากรายการโปรดแล้ว',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('แชร์สูตรอาหารนี้'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            "โดย ${widget.recipe['createdBy']}",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.timer, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            "30 นาที",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      _buildSectionTitle(context, "ส่วนผสม", Icons.restaurant),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _buildIngredientsList(
                              widget.recipe['ingredients'],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle(context, "วิธีทำ", Icons.menu_book),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.recipe['instructions'],
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle(
                        context,
                        "เกร็ดความรู้",
                        Icons.lightbulb,
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 2,
                        color: Colors.amber[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "เคล็ดลับในการทำอาหารจานนี้ให้อร่อย คือการเลือกวัตถุดิบที่สดใหม่ และการควบคุมอุณหภูมิในการทำอาหารให้เหมาะสม",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.orange[800],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildIngredientsList(List<dynamic> ingredients) {
    return ingredients.map<Widget>((ingredient) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(ingredient, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      );
    }).toList();
  }
}
