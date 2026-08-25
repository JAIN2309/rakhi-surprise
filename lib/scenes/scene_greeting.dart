import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Scene 3 — Personalized Greeting with caring words.
///
/// Massive bold text bounces into place with [Curves.elasticOut], followed
/// by a warm caring subtitle. Auto-advances to Scene 4 after 3.5 seconds.
class SceneGreeting extends StatefulWidget {
  final String sisterName;
  final bool isActive;
  final VoidCallback onComplete;

  const SceneGreeting({
    super.key,
    required this.sisterName,
    required this.isActive,
    required this.onComplete,
  });

  @override
  State<SceneGreeting> createState() => _SceneGreetingState();
}

class _SceneGreetingState extends State<SceneGreeting> {
  bool _activated = false;

  @override
  void initState() {
    super.initState();
    _checkActivation();
  }

  @override
  void didUpdateWidget(covariant SceneGreeting oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive && !_activated) {
      _activate();
    }
  }

  void _checkActivation() {
    if (widget.isActive && !_activated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_activated) _activate();
      });
    }
  }

  void _activate() {
    setState(() => _activated = true);
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final titleFontSize = screenWidth > 600 ? 42.0 : 32.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE91E63),
            Color(0xFF9C27B0),
            Color(0xFF673AB7),
          ],
        ),
      ),
      child: _activated
          ? Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Main greeting ──────────────────────────────
                      Text(
                        'Yay! So nice to\ncelebrate with you,\n${widget.sisterName}! 🎉',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      )
                          .animate()
                          .fade(duration: 400.ms)
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 1200.ms,
                            curve: Curves.elasticOut,
                          )
                          .scale(
                            begin: const Offset(0.5, 0.5),
                            end: const Offset(1.0, 1.0),
                            duration: 1200.ms,
                            curve: Curves.elasticOut,
                          ),

                      const SizedBox(height: 28),

                      // ── Caring subtitle ───────────────────────────
                      Text(
                        'You make every day brighter\njust by being you ✨',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dancingScript(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withAlpha(220),
                          height: 1.4,
                        ),
                      )
                          .animate()
                          .fade(duration: 800.ms, delay: 1000.ms)
                          .slideY(
                            begin: 0.2,
                            end: 0,
                            duration: 800.ms,
                            delay: 1000.ms,
                            curve: Curves.easeOut,
                          ),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
