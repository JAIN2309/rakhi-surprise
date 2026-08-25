import 'dart:math';
import 'dart:ui' as ui;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../utils/download_stub.dart'
    if (dart.library.html) '../utils/download_web.dart';

/// Scene 8 — The Grand Finale (Certificate).
///
/// Canva-style tall certificate with a long heartfelt paragraph, confetti
/// burst, golden double-border, elegant typography, and a working
/// **Download Certificate** button that captures the card as a PNG.
class SceneCertificate extends StatefulWidget {
  final String sisterName;
  final bool isActive;

  const SceneCertificate({
    super.key,
    required this.sisterName,
    required this.isActive,
  });

  @override
  State<SceneCertificate> createState() => _SceneCertificateState();
}

class _SceneCertificateState extends State<SceneCertificate> {
  bool _activated = false;
  bool _downloading = false;
  late final ConfettiController _confettiController;
  final GlobalKey _certificateKey = GlobalKey();

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _checkActivation();
  }

  @override
  void didUpdateWidget(covariant SceneCertificate oldWidget) {
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
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  // ── Download logic ────────────────────────────────────────────────────────

  Future<void> _downloadCertificate() async {
    if (_downloading) return;
    setState(() => _downloading = true);

    try {
      final boundary = _certificateKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final bytes = byteData.buffer.asUint8List();
      await downloadPngBytes(bytes, 'raksha_bandhan_certificate.png');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Certificate downloaded! 🎉',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            backgroundColor: const Color(0xFF4A148C),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not download certificate',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
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
            Color(0xFF1A0A2E),
            Color(0xFF0A0A1A),
            Color(0xFF1A0A2E),
          ],
        ),
      ),
      child: Stack(
        children: [
          // ── Confetti ──────────────────────────────────────────
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 20,
              minBlastForce: 8,
              emissionFrequency: 0.06,
              numberOfParticles: 25,
              gravity: 0.1,
              shouldLoop: false,
              colors: const [
                Color(0xFFFFD700),
                Color(0xFFFF6F61),
                Color(0xFFE040FB),
                Color(0xFF7C4DFF),
                Color(0xFF00E5FF),
                Color(0xFF69F0AE),
              ],
            ),
          ),

          // ── Certificate + download button ─────────────────────
          if (_activated)
            Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAnimatedCertificate(),
                    const SizedBox(height: 28),
                    _buildDownloadButton(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Animated certificate (RepaintBoundary for screenshot) ─────────────

  Widget _buildAnimatedCertificate() {
    return RepaintBoundary(
      key: _certificateKey,
      child: Container(
        // Dark surround so the downloaded PNG has a complete background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0A2E), Color(0xFF0A0A1A)],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: _buildCertificateCard(),
      ),
    )
        .animate()
        .slideY(
          begin: 1.5,
          end: 0,
          duration: 1200.ms,
          curve: Curves.easeOutBack,
        )
        .rotate(
          begin: -0.028,
          end: 0,
          duration: 1200.ms,
          curve: Curves.easeOutBack,
        )
        .fade(duration: 600.ms);
  }

  // ── Download button ───────────────────────────────────────────────────

  Widget _buildDownloadButton() {
    return GestureDetector(
      onTap: _downloading ? null : _downloadCertificate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD4AF37), Color(0xFFF4D03F), Color(0xFFD4AF37)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withAlpha(80),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_downloading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFF2C1810),
                ),
              )
            else
              const Icon(Icons.download_rounded,
                  size: 22, color: Color(0xFF2C1810)),
            const SizedBox(width: 10),
            Text(
              _downloading ? 'Saving…' : 'Download Certificate',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2C1810),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fade(duration: 600.ms, delay: 1800.ms)
        .slideY(
          begin: 0.3,
          end: 0,
          duration: 600.ms,
          delay: 1800.ms,
          curve: Curves.easeOut,
        );
  }

  // ── Certificate card ────────────────────────────────────────────────────

  Widget _buildCertificateCard() {
    final formattedDate = DateFormat('MMMM d, yyyy').format(DateTime.now());
    final name = widget.sisterName;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDE7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4AF37), width: 4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withAlpha(77),
            blurRadius: 50,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.black.withAlpha(60),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFD4AF37).withAlpha(100),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top ornament ────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOrnamentLine(),
                const SizedBox(width: 12),
                Text(
                  '🏆',
                  style: TextStyle(
                    fontSize: 32,
                    color: const Color(0xFFD4AF37).withAlpha(200),
                  ),
                ),
                const SizedBox(width: 12),
                _buildOrnamentLine(),
              ],
            ),

            const SizedBox(height: 24),

            // ── Title ───────────────────────────────────────────
            Text(
              'CERTIFICATE',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF2C1810),
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'OF EXCELLENCE',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF8B6914),
                letterSpacing: 4,
              ),
            ),

            const SizedBox(height: 24),
            _buildGoldDivider(),
            const SizedBox(height: 24),

            // ── Awarded to ──────────────────────────────────────
            Text(
              'This certificate is proudly presented to',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6D4C41),
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 16),

            // ── Name (large cursive, golden) ────────────────────
            Text(
              name,
              textAlign: TextAlign.center,
              style: GoogleFonts.dancingScript(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFD4AF37),
                height: 1.1,
              ),
            ),

            const SizedBox(height: 16),

            // ── Award title ─────────────────────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF880E4F).withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '✨  Best Sister in the World  ✨',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF880E4F),
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 28),
            _buildGoldDivider(),
            const SizedBox(height: 28),

            // ── Long heartfelt Canva-style paragraph ────────────
            Text(
              'Dear $name,',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF3E2723),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'This certificate is awarded to you for being the most '
              'incredible, caring, and irreplaceable sister in the entire '
              'universe. For every time you stood by me when no one else '
              'did. For every smile you brought on my darkest days. For '
              'every silent prayer you whispered for my happiness. For '
              'every sacrifice you made without ever asking for anything '
              'in return. For being my first best friend, my fiercest '
              'protector, and the kindest soul I have ever known.\n\n'
              'No award in the world could ever capture what you truly mean '
              'to me — but today, on this beautiful day of Raksha Bandhan, '
              'I want you to know: you are loved beyond words, cherished '
              'beyond measure, and appreciated more than you will ever '
              'realize. This is my small attempt to say — thank you for '
              'being you. Thank you for being my sister. 💖',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF4E342E),
                height: 1.7,
                letterSpacing: 0.2,
              ),
            ),

            const SizedBox(height: 28),
            _buildGoldDivider(),
            const SizedBox(height: 24),

            // ── Date ────────────────────────────────────────────
            Text(
              formattedDate,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6D4C41),
              ),
            ),

            const SizedBox(height: 20),

            // ── Signature ───────────────────────────────────────
            Container(
              width: 160,
              height: 1,
              color: const Color(0xFFD4AF37).withAlpha(128),
            ),
            const SizedBox(height: 12),
            Text(
              'With all my love,',
              style: GoogleFonts.dancingScript(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4A148C),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Krish Jain',
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF4A148C),
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '(Your Caring Brother)',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF6D4C41),
              ),
            ),

            const SizedBox(height: 20),

            // ── Bottom ornament ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildOrnamentLine(),
                const SizedBox(width: 12),
                Text(
                  '💖',
                  style: TextStyle(
                    fontSize: 24,
                    color: const Color(0xFFD4AF37).withAlpha(200),
                  ),
                ),
                const SizedBox(width: 12),
                _buildOrnamentLine(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Decorative helpers ──────────────────────────────────────────────────

  Widget _buildGoldDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 1,
          color: const Color(0xFFD4AF37).withAlpha(100),
        ),
        const SizedBox(width: 8),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFD4AF37).withAlpha(150),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 60,
          height: 2,
          color: const Color(0xFFD4AF37),
        ),
        const SizedBox(width: 8),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFD4AF37).withAlpha(150),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 1,
          color: const Color(0xFFD4AF37).withAlpha(100),
        ),
      ],
    );
  }

  Widget _buildOrnamentLine() {
    return Container(
      width: 50,
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFD4AF37).withAlpha(0),
            const Color(0xFFD4AF37),
          ],
        ),
      ),
    );
  }
}
