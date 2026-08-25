import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Scene 1 — The Hook (Mini Splash).
///
/// Deep magenta → royal blue radial gradient. The greeting text fades and
/// scales up slowly, then auto-advances to Scene 2 after 3 seconds.
class SceneSplash extends StatefulWidget {
  final VoidCallback onComplete;

  const SceneSplash({super.key, required this.onComplete});

  @override
  State<SceneSplash> createState() => _SceneSplashState();
}

class _SceneSplashState extends State<SceneSplash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            Color(0xFF880E4F), // deep magenta
            Color(0xFF4A148C), // deep purple
            Color(0xFF1A237E), // royal blue
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Text(
            'Happy Raksha Bandhan\nto my caring and\ncute sister! 💖',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.4,
              letterSpacing: 0.5,
            ),
          )
              .animate()
              .fade(duration: 1200.ms, curve: Curves.easeOut)
              .scale(
                begin: const Offset(0.7, 0.7),
                end: const Offset(1.0, 1.0),
                duration: 1500.ms,
                curve: Curves.easeOutCubic,
              ),
        ),
      ),
    );
  }
}
