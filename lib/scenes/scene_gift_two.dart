import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

/// Scene 6 — Second Gift Reveal (Chocolates).
///
/// The previous gift (flower thumbnail) shrinks to top-left. A real chocolate
/// image pops into centre with rotation + scale. Fully responsive design.
class SceneGiftTwo extends StatefulWidget {
  final bool isActive;
  final VoidCallback onNext;

  const SceneGiftTwo({
    super.key,
    required this.isActive,
    required this.onNext,
  });

  @override
  State<SceneGiftTwo> createState() => _SceneGiftTwoState();
}

class _SceneGiftTwoState extends State<SceneGiftTwo> {
  bool _activated = false;

  @override
  void initState() {
    super.initState();
    _checkActivation();
  }

  @override
  void didUpdateWidget(covariant SceneGiftTwo oldWidget) {
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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF004D40),
            Color(0xFF00695C),
            Color(0xFF00796B),
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
      child: Stack(
        children: [
          // ── Previous gift (flower thumbnail) shrinking to top-left ──
          Positioned(
            top: 24,
            left: 24,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF4081).withAlpha(60),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  'https://images.unsplash.com/photo-1487530811176-3780de880c2d?w=100&h=100&fit=crop&q=60',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFFFFD700),
                      child: const Center(
                        child: Text('💐', style: TextStyle(fontSize: 28)),
                      ),
                    );
                  },
                ),
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(2.5, 2.5),
                  end: const Offset(1.0, 1.0),
                  duration: 1000.ms,
                  curve: Curves.easeInOutCubic,
                )
                .slide(
                  begin: const Offset(1.5, 3.0),
                  end: Offset.zero,
                  duration: 1000.ms,
                  curve: Curves.easeInOutCubic,
                )
                .fade(duration: 600.ms),
          ),

          // ── Main content ─────────────────────────────────────
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text
                    Text(
                      'And another one,\njust because you\'re you. 💝',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    )
                        .animate()
                        .fade(duration: 600.ms, delay: 600.ms)
                        .slideY(
                          begin: -0.2,
                          end: 0,
                          duration: 600.ms,
                          delay: 600.ms,
                          curve: Curves.easeOut,
                        ),

                    const SizedBox(height: 28),

                    // ── Real chocolate image ──────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C4DFF).withAlpha(120),
                            blurRadius: 30,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=400&h=400&fit=crop&q=80',
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
                                  colors: [
                                    Color(0xFFE040FB),
                                    Color(0xFF7C4DFF),
                                  ],
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
                                  colors: [
                                    Color(0xFFE040FB),
                                    Color(0xFF7C4DFF),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Center(
                                child:
                                    Text('🍫', style: TextStyle(fontSize: 80)),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                        .animate()
                        .scale(
                          begin: const Offset(0.0, 0.0),
                          end: const Offset(1.0, 1.0),
                          duration: 1200.ms,
                          delay: 500.ms,
                          curve: Curves.elasticOut,
                        )
                        .rotate(
                          begin: -0.05,
                          end: 0,
                          duration: 1200.ms,
                          delay: 500.ms,
                          curve: Curves.elasticOut,
                        )
                        .fade(duration: 400.ms, delay: 500.ms),

                    const SizedBox(height: 14),

                    // ── Gift label ────────────────────────────────────
                    Text(
                      '🍫  Box of Sweet Treats  🍫',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    )
                        .animate()
                        .fade(duration: 600.ms, delay: 1400.ms),

                    const SizedBox(height: 16),

                    // ── Caring message ────────────────────────────────
                    Text(
                      'Life is sweeter because of you. These treats are '
                      'just a tiny taste of all the sweetness you bring '
                      'into our lives every single day. 🤎',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dancingScript(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withAlpha(230),
                        height: 1.5,
                      ),
                    )
                        .animate()
                        .fade(duration: 800.ms, delay: 1700.ms)
                        .slideY(
                          begin: 0.15,
                          end: 0,
                          duration: 800.ms,
                          delay: 1700.ms,
                          curve: Curves.easeOut,
                        ),

                    const SizedBox(height: 32),

                    // Next button
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
                            color: const Color(0xFF00695C),
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fade(duration: 600.ms, delay: 2400.ms)
                        .slideY(
                          begin: 0.3,
                          end: 0,
                          duration: 600.ms,
                          delay: 2400.ms,
                          curve: Curves.easeOut,
                        ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
