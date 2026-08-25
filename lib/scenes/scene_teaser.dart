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

  String _displayedText = '';
  final String _fullText = 'I have a few small surprises for you...';
  int _charIndex = 0;
  Timer? _typewriterTimer;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D1B2A),
            Color(0xFF1B0A2E),
            Color(0xFF0A0A1A),
          ],
        ),
      ),
      child: _activated ? _buildContent() : const SizedBox.shrink(),
    );
  }

  Widget _buildContent() {
    final bool isTyping = _charIndex < _fullText.length;
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth > 600 ? 34.0 : 24.0;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Text(
            isTyping ? '$_displayedText▌' : _displayedText,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFFFD54F),
              height: 1.5,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
