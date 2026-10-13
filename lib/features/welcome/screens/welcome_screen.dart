import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bikip_kanji_app/app/router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    _goHomeAfterDelay();
  }

  Future<void> _goHomeAfterDelay() async {
    await Future.delayed(const Duration(seconds: 4));

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('has_seen_welcome', true);

    if (!mounted) return;

    context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAF7F0),

      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,

            child: ScaleTransition(
              scale: _scaleAnimation,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  // Logo
                  Container(
                    width: 110,

                    height: 110,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: Colors.white,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,

                          blurRadius: 20,

                          offset: Offset(0, 10),
                        ),
                      ],
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Image.asset(
                        "assets/icon/app_icon.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Bí Kíp Kanji",

                    style: TextStyle(
                      fontSize: 34,

                      fontWeight: FontWeight.bold,

                      color: Color(0xff222222),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Người Việt học Kanji\n"
                    "dễ hơn bằng âm Hán Việt",

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 18,

                      height: 1.5,

                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Kanji learning flow
                  _buildKanjiFlow(),

                  const SizedBox(height: 50),

                  const CircularProgressIndicator(strokeWidth: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKanjiFlow() {
    return Column(
      children: [
        const Text(
          "母",

          style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        _arrow(),

        const Text(
          "Mẫu",

          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),

        _arrow(),

        const Text("Mẹ", style: TextStyle(fontSize: 24)),

        _arrow(),

        const Text(
          "はは",

          style: TextStyle(fontSize: 24, color: Colors.blueGrey),
        ),
      ],
    );
  }

  Widget _arrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),

      child: Text("↓", style: TextStyle(fontSize: 22, color: Colors.grey)),
    );
  }
}
