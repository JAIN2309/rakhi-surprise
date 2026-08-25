import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Scene 2 — The Input.
///
/// Soft pastel gradient, an elegant gold-bordered [TextField] with auto-focus,
/// and a looping pulsing "Submit" button. Saves the sister's name on submit.
class SceneInput extends StatefulWidget {
  final bool isActive;
  final ValueChanged<String> onNameSubmitted;

  const SceneInput({
    super.key,
    required this.isActive,
    required this.onNameSubmitted,
  });

  @override
  State<SceneInput> createState() => _SceneInputState();
}

class _SceneInputState extends State<SceneInput> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _activated = false;

  @override
  void initState() {
    super.initState();
    _checkActivation();
  }

  @override
  void didUpdateWidget(covariant SceneInput oldWidget) {
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
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  void _submit() {
    final name = _textController.text.trim();
    if (name.isNotEmpty) {
      _focusNode.unfocus();
      widget.onNameSubmitted(name);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF0E6),
            Color(0xFFF3E5F5),
            Color(0xFFE8EAF6),
          ],
        ),
      ),
      child: _activated ? _buildContent() : const SizedBox.shrink(),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Question ────────────────────────────────────────────
                Text(
                  'What is your name,\nmy beautiful sister? 🌸',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4A1A6B),
                    height: 1.4,
                  ),
                )
                    .animate()
                    .fade(duration: 800.ms)
                    .slideY(
                      begin: -0.2,
                      end: 0,
                      duration: 800.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 44),

                // ── Text field (auto-focused) ───────────────────────────
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE1BEE7).withAlpha(128),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    textAlign: TextAlign.center,
                    textCapitalization: TextCapitalization.words,
                    style: GoogleFonts.dancingScript(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4A148C),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your name…',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFFAA88CC),
                      ),
                      filled: true,
                      fillColor: Colors.white.withAlpha(230),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFFD4AF37), width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFFD4AF37), width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFFD4AF37), width: 3),
                      ),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                )
                    .animate()
                    .fade(duration: 600.ms, delay: 400.ms)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1.0, 1.0),
                      duration: 600.ms,
                      delay: 400.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 36),

                // ── Pulsing submit button ───────────────────────────────
                GestureDetector(
                  onTap: _submit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFD4AF37),
                          Color(0xFFF4D03F),
                          Color(0xFFD4AF37),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD4AF37).withAlpha(102),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      'Submit ✨',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2C1810),
                      ),
                    ),
                  )
                      .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true))
                      .scale(
                        begin: const Offset(1.0, 1.0),
                        end: const Offset(1.08, 1.08),
                        duration: 1000.ms,
                        curve: Curves.easeInOut,
                      ),
                )
                    .animate()
                    .fade(duration: 600.ms, delay: 800.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
