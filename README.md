# 🎁 Raksha Bandhan Surprise — Interactive Flutter Web & Mobile App

A beautiful, 60fps interactive 8-scene surprise journey built with Flutter, custom spring physics, timeline animations, and a downloadable Canva-style Certificate of Excellence.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Web](https://img.shields.io/badge/Web-Compatible-brightgreen?style=for-the-badge&logo=googlechrome&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-gold.svg?style=for-the-badge)

---

## ✨ Features & Scene Flow

1. **Scene 1: The Hook (Mini Splash)** — Deep magenta to royal blue radial gradient with entrance text scaling & fading in.
2. **Scene 2: Name Input** — Soft pastel aesthetic with a gold-bordered text input, auto-focus, and a pulsing glow button.
3. **Scene 3: Personalized Bounce Greeting** — Bounces into view using `Curves.elasticOut` with personalized text & caring subtitle.
4. **Scene 4: Cinematic Teaser** — Dark navy backdrop with a character-by-character typewriter reveal and `▌` cursor.
5. **Scene 5: First Gift Reveal (Flowers)** — Unsplash flower bouquet spring-loaded from the bottom with a caring message.
6. **Scene 6: Second Gift Reveal (Chocolates)** — Flower thumbnail shrinks to top-left while chocolate truffles pop into center with elastic rotation.
7. **Scene 7: The Drumroll** — Endless heartbeat-pulsating golden circle with glowing shadow effects.
8. **Scene 8: Grand Finale (Canva Certificate)** — Confetti blast with a golden double-bordered certificate card, Playfair Display typography, personalized letter, dual-line signature by Krish Jain, and **one-click PNG download** (`RepaintBoundary` + Blob web download).

---

## 🛠️ Responsive & Modular Architecture

- **`kIsWeb` Adaptive Shell:** On wide web viewports (>600px width), the entire app renders inside an ultra-sleek 420×900 phone container with rounded corners and glowing shadows. On smartphones (iOS/Android) and mobile web, it renders full-screen seamlessly.
- **Transform-Only Animations:** Strictly animates `ScaleTransition`, `SlideTransition`, `FadeTransition`, and `RotationTransition` via `flutter_animate` to maintain 60/120fps without layout jank.
- **Cross-Platform Download Utility:** Uses conditional imports (`download_web.dart` vs `download_stub.dart`) so web download works out of the box without breaking mobile/desktop builds.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.12+ recommended)

### Installation & Run

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_GITHUB_USERNAME/rakhi-surprise.git
cd rakhi-surprise

# 2. Get dependencies
flutter pub get

# 3. Run on Chrome Web
flutter run -d chrome

# 4. Run on Mobile (Android / iOS)
flutter run
```

---

## 📦 Main Dependencies

- [`flutter_animate`](https://pub.dev/packages/flutter_animate) — Timeline & spring extensions
- [`google_fonts`](https://pub.dev/packages/google_fonts) — Playfair Display, Dancing Script, & Poppins
- [`confetti`](https://pub.dev/packages/confetti) — Digital confetti particle burst
- [`intl`](https://pub.dev/packages/intl) — Professional date formatting

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

Developed with ❤️ by **Krish Jain**.
