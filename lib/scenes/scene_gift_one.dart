import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Scene 5 — First Gift Reveal (Flowers).
///
/// A real flower image springs from the bottom with [Curves.elasticOut],
/// accompanied by a heartfelt caring message. Fully responsive design.
class SceneGiftOne extends StatefulWidget {
  final bool isActive;
  final VoidCallback onNext;

  const SceneGiftOne({
    super.key,
    required this.isActive,
    required this.onNext,
  });

  @override
  State<SceneGiftOne> createState() => _SceneGiftOneState();
}

class _SceneGiftOneState extends State<SceneGiftOne> {
  bool _activated = false;

  @override
  void initState() {
    super.initState();
    _checkActivation();
  }

  @override
  void didUpdateWidget(covariant SceneGiftOne oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive && !_activated) {
      setState(() => _activated = true);
    }
  }

  void _checkActivation() {
    if (widget.isActive && !_activated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_activated) setState(() => _activated = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6F61),
            Color(0xFFFF4081),
            Color(0xFFE91E63),
          ],
        ),
      ),
      child: _activated ? _buildContent() : const SizedBox.shrink(),
    );
  }

  Widget _buildContent() {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSize = (screenHeight * 0.28).clamp(180.0, 300.0);

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Title ──────────────────────────────────────────────
                Text(
                  'A little something to\nmake you smile! 😊',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                )
                    .animate()
                    .fade(duration: 600.ms)
                    .slideY(
                        begin: -0.3,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOut),

                const SizedBox(height: 28),

                // ── Real flower image ──────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF4081).withAlpha(120),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1487530811176-3780de880c2d?w=400&h=400&fit=crop&q=80',
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: imageSize,
                          height: imageSize,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: imageSize,
                          height: imageSize,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Center(
                            child: Text('💐', style: TextStyle(fontSize: 80)),
                          ),
                        );
                      },
                    ),
                  ),
                )
                    .animate()
                    .slideY(
                      begin: 2.0,
                      end: 0,
                      duration: 1200.ms,
                      delay: 400.ms,
                      curve: Curves.elasticOut,
                    )
                    .fade(duration: 400.ms, delay: 400.ms),

                const SizedBox(height: 14),

                // ── Gift label ─────────────────────────────────────────
                Text(
                  '🌸  A Beautiful Bouquet  🌸',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .fade(duration: 600.ms, delay: 1200.ms),

                const SizedBox(height: 16),

                // ── Caring message ─────────────────────────────────────
                Text(
                  'Every petal in this bouquet represents a moment '
                  'you made my life beautiful. You deserve all the '
                  'flowers in the world, always. 💕',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dancingScript(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withAlpha(230),
                    height: 1.5,
                  ),
                )
                    .animate()
                    .fade(duration: 800.ms, delay: 1500.ms)
                    .slideY(
                      begin: 0.15,
                      end: 0,
                      duration: 800.ms,
                      delay: 1500.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 32),

                // ── Next button ────────────────────────────────────────
                GestureDetector(
                  onTap: widget.onNext,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 44, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withAlpha(77),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Text(
                      'Next →',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFE91E63),
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fade(duration: 600.ms, delay: 2200.ms)
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      duration: 600.ms,
                      delay: 2200.ms,
                      curve: Curves.easeOut,
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
