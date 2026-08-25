import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Scene 7 — The Drumroll.
///
/// A pulsating, glowing golden circle scales up and down endlessly (heartbeat).
/// Text addresses the sister by name. Auto-advances after 3 seconds.
class SceneDrumroll extends StatefulWidget {
  final String sisterName;
  final bool isActive;
  final VoidCallback onComplete;

  const SceneDrumroll({
    super.key,
    required this.sisterName,
    required this.isActive,
    required this.onComplete,
  });

  @override
  State<SceneDrumroll> createState() => _SceneDrumrollState();
}

class _SceneDrumrollState extends State<SceneDrumroll> {
  bool _activated = false;

  // ── Activation lifecycle ──────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _checkActivation();
  }

  @override
  void didUpdateWidget(covariant SceneDrumroll oldWidget) {
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
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) widget.onComplete();
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.0,
          colors: [
            Color(0xFF1A1A2E), // dark indigo
            Color(0xFF0A0A1A), // near-black
          ],
        ),
      ),
      child: _activated ? _buildContent() : const SizedBox.shrink(),
    );
  }

  Widget _buildContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Heartbeat pulsating circle ─────────────────────────
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(
                colors: [
                  Color(0xFFFFD700),
                  Color(0xFFFFA000),
                  Color(0xFFFF6F00),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withAlpha(128),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: const Center(
              child: Text('✨', style: TextStyle(fontSize: 50)),
            ),
          )
              .animate(
                  onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(0.85, 0.85),
                end: const Offset(1.15, 1.15),
                duration: 800.ms,
                curve: Curves.easeInOut,
              ),

          const SizedBox(height: 48),

          // ── Text ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'But wait, ${widget.sisterName}…\nthere is one more thing.\nThe official award! 🏆',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.5,
              ),
            )
                .animate()
                .fade(duration: 800.ms, delay: 400.ms)
                .slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 800.ms,
                  delay: 400.ms,
                  curve: Curves.easeOut,
                ),
          ),
        ],
      ),
    );
  }
}
