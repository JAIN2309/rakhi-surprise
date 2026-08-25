import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Scene 4 — The Teaser.
///
/// Dimmed dark background. A character-by-character typewriter effect reveals
/// the text "I have a few small surprises for you…". Auto-advances 1 s after
/// the last character is typed.
class SceneTeaser extends StatefulWidget {
  final bool isActive;
  final VoidCallback onComplete;

  const SceneTeaser({
    super.key,
    required this.isActive,
    required this.onComplete,
  });

  @override
  State<SceneTeaser> createState() => _SceneTeaserState();
}

class _SceneTeaserState extends State<SceneTeaser> {
  bool _activated = false;

  // Typewriter state
  String _displayedText = '';
  final String _fullText = 'I have a few small surprises for you...';
  int _charIndex = 0;
  Timer? _typewriterTimer;

  // ── Activation lifecycle ──────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _checkActivation();
  }

  @override
  void didUpdateWidget(covariant SceneTeaser oldWidget) {
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

    // Start the typewriter after a brief dramatic pause
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      _typewriterTimer =
          Timer.periodic(const Duration(milliseconds: 60), (timer) {
        if (_charIndex < _fullText.length) {
          setState(() {
            _charIndex++;
            _displayedText = _fullText.substring(0, _charIndex);
          });
        } else {
          timer.cancel();
          // Auto-advance 1 s after typewriter finishes
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) widget.onComplete();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D1B2A), // dark navy
            Color(0xFF1B0A2E), // dark purple
            Color(0xFF0A0A1A), // near-black
          ],
        ),
      ),
      child: _activated ? _buildContent() : const SizedBox.shrink(),
    );
  }

  Widget _buildContent() {
    final bool isTyping = _charIndex < _fullText.length;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          isTyping ? '$_displayedText▌' : _displayedText,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFFFD54F),
            height: 1.5,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
