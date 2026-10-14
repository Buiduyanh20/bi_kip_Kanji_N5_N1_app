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
  static const double _maxWidth = 480;

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

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
        child: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxWidth),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 360;
                final logoSize = narrow ? 88.0 : 110.0;
                final titleSize = narrow ? 28.0 : 34.0;
                final subtitleSize = narrow ? 15.0 : 18.0;
                final kanjiSize = narrow ? 48.0 : 60.0;
                final stepSize = narrow ? 20.0 : 24.0;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: narrow ? 12 : 24,
                    vertical: 24,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: narrow ? 12 : 24),
                          Container(
                            width: logoSize,
                            height: logoSize,
                            decoration: const BoxDecoration(
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
                                'assets/icon/app_icon.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          SizedBox(height: narrow ? 20 : 30),
                          Text(
                            'Bí Kíp Kanji',
                            style: TextStyle(
                              fontSize: titleSize,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff222222),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Người Việt học Kanji\n'
                                'dễ hơn bằng âm Hán Việt',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: subtitleSize,
                              height: 1.5,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: narrow ? 32 : 50),
                          _buildKanjiFlow(
                            kanjiSize: kanjiSize,
                            stepSize: stepSize,
                          ),
                          SizedBox(height: narrow ? 32 : 50),
                          const CircularProgressIndicator(strokeWidth: 2),
                          SizedBox(height: narrow ? 12 : 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKanjiFlow({
    required double kanjiSize,
    required double stepSize,
  }) {
    return Column(
      children: [
        Text(
          '母',
          style: TextStyle(fontSize: kanjiSize, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _arrow(),
        Text(
          'Mẫu',
          style: TextStyle(fontSize: stepSize, fontWeight: FontWeight.w600),
        ),
        _arrow(),
        Text('Mẹ', style: TextStyle(fontSize: stepSize)),
        _arrow(),
        Text(
          'はは',
          style: TextStyle(fontSize: stepSize, color: Colors.blueGrey),
        ),
      ],
    );
  }

  Widget _arrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text('↓', style: TextStyle(fontSize: 22, color: Colors.grey)),
    );
  }
}