import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'scenes/scene_splash.dart';
import 'scenes/scene_input.dart';
import 'scenes/scene_greeting.dart';
import 'scenes/scene_teaser.dart';
import 'scenes/scene_gift_one.dart';
import 'scenes/scene_gift_two.dart';
import 'scenes/scene_drumroll.dart';
import 'scenes/scene_certificate.dart';

void main() {
  Animate.restartOnHotReload = true;
  runApp(const RakhiSurpriseApp());
}

/// Root application widget — Raksha Bandhan Surprise.
class RakhiSurpriseApp extends StatelessWidget {
  const RakhiSurpriseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raksha Bandhan Surprise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const SurpriseJourney(),
    );
  }
}

/// Master orchestrator — holds the [PageController], tracks the current page
/// index, and owns the shared [sisterName] state that downstream scenes read.
///
/// Uses [kIsWeb] + [MediaQuery] to present a phone-sized centred container
/// on wide web viewports while staying full-screen on mobile devices.
class SurpriseJourney extends StatefulWidget {
  const SurpriseJourney({super.key});

  @override
  State<SurpriseJourney> createState() => _SurpriseJourneyState();
}

class _SurpriseJourneyState extends State<SurpriseJourney> {
  final PageController _pageController = PageController();
  String sisterName = '';
  int _currentPage = 0;

  /// Programmatic page turn with a smooth cubic ease.
  /// Sets [_currentPage] **after** the animation completes so that child
  /// scenes can use `isActive` to know exactly when the transition is done.
  Future<void> _goToPage(int page) async {
    await _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
    if (mounted) {
      setState(() => _currentPage = page);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = kIsWeb && screenWidth > 600;

    // ── The 8-scene PageView ──────────────────────────────────────────────
    Widget body = PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // ── Scene 1 ─────────────────────────────────────────────
        SceneSplash(onComplete: () => _goToPage(1)),

        // ── Scene 2 ─────────────────────────────────────────────
        SceneInput(
          isActive: _currentPage == 1,
          onNameSubmitted: (name) {
            setState(() => sisterName = name);
            _goToPage(2);
          },
        ),

        // ── Scene 3 ─────────────────────────────────────────────
        SceneGreeting(
          sisterName: sisterName,
          isActive: _currentPage == 2,
          onComplete: () => _goToPage(3),
        ),

        // ── Scene 4 ─────────────────────────────────────────────
        SceneTeaser(
          isActive: _currentPage == 3,
          onComplete: () => _goToPage(4),
        ),

        // ── Scene 5 ─────────────────────────────────────────────
        SceneGiftOne(
          isActive: _currentPage == 4,
          onNext: () => _goToPage(5),
        ),

        // ── Scene 6 ─────────────────────────────────────────────
        SceneGiftTwo(
          isActive: _currentPage == 5,
          onNext: () => _goToPage(6),
        ),

        // ── Scene 7 ─────────────────────────────────────────────
        SceneDrumroll(
          sisterName: sisterName,
          isActive: _currentPage == 6,
          onComplete: () => _goToPage(7),
        ),

        // ── Scene 8 ─────────────────────────────────────────────
        SceneCertificate(
          sisterName: sisterName,
          isActive: _currentPage == 7,
        ),
      ],
    );

    // ── Responsive web shell ────────────────────────────────────────────
    // On wide web viewports: centre the app in a phone-like container
    // with rounded corners, a subtle border, and a deep shadow.
    // On phones / narrow viewports: full screen — no wrapper.
    if (isWideScreen) {
      body = Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 420, maxHeight: 900),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withAlpha(20),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(120),
                blurRadius: 80,
                spreadRadius: 10,
              ),
              BoxShadow(
                color: const Color(0xFF7C4DFF).withAlpha(30),
                blurRadius: 120,
                spreadRadius: 5,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: body,
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          isWideScreen ? const Color(0xFF0A0A0A) : Colors.transparent,
      body: body,
    );
  }
}
