import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_therapy/controllers/splash_controller.dart';

// ─────────────────────────────────────────────
//  Data model for each onboarding page
// ─────────────────────────────────────────────
class _OnboardingPage {
  final String title;
  final String subtitle;
  final Widget illustration;
  final Color accentColor;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.illustration,
    required this.accentColor,
  });
}

// ─────────────────────────────────────────────
//  Root Splash Screen
// ─────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _blobController;
  late AnimationController _loadingController;
  late PageController _pageController;

  final SplashController controller = Get.put(SplashController());

  int _currentPage = 0;

  late final List<_OnboardingPage> _pages;

  @override
  void initState() {
    super.initState();

    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _pageController = PageController();

    _pages = [
      _OnboardingPage(
        title: 'MindCare',
        subtitle: 'Your mental wellness companion.\nHeal. Grow. Thrive.',
        illustration: const _LogoIllustration(),
        accentColor: const Color(0xFF818CF8),
      ),
      _OnboardingPage(
        title: 'Talk to a Real Therapist',
        subtitle:
            'Book private sessions with certified professionals — whenever you need support.',
        illustration: const _TherapistIllustration(),
        accentColor: const Color(0xFF34D399),
      ),
      _OnboardingPage(
        title: 'Begin Your Healing Journey',
        subtitle:
            'Track your moods, access resources, and take control of your mental health.',
        illustration: const _HealingIllustration(),
        accentColor: const Color(0xFFC084FC),
      ),
    ];
  }

  @override
  void dispose() {
    _blobController.dispose();
    _loadingController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _goToNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      controller.navigate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ── Animated galaxy background ──
          AnimatedBuilder(
            animation: _blobController,
            builder: (_, __) => CustomPaint(
              painter: _BackgroundPainter(_blobController.value),
              size: size,
            ),
          ),

          // ── Pages ──
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index], index);
            },
          ),

          // ── Skip button (top-right) ──
          if (_currentPage < _pages.length - 1)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 24,
              child: GestureDetector(
                onTap: controller.navigate,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

          // ── Bottom Controls ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControls(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          // Top spacer
          SizedBox(height: MediaQuery.of(context).padding.top + 60),

          // Illustration area
          Expanded(
            flex: 5,
            child: Center(
              child: _AnimatedIllustrationWrapper(
                key: ValueKey(index),
                accentColor: page.accentColor,
                child: page.illustration,
              ),
            ),
          ),

          // Text area
          Expanded(
            flex: 4,
            child: _PageTextContent(
              key: ValueKey('text_$index'),
              title: page.title,
              subtitle: page.subtitle,
              accentColor: page.accentColor,
              isFirstPage: index == 0,
            ),
          ),

          // Bottom spacer for controls
          const SizedBox(height: 140),
        ],
      ),
    );
  }

  Widget _buildBottomControls(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;
    final accentColor = _pages[_currentPage].accentColor;

    return Container(
      padding: EdgeInsets.fromLTRB(
          32, 20, 32, MediaQuery.of(context).padding.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == i ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == i
                      ? accentColor
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // CTA Button
          GestureDetector(
            onTap: _goToNext,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: double.infinity,
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor,
                    accentColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(29),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLastPage ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Animated wrapper for each illustration
// ─────────────────────────────────────────────
class _AnimatedIllustrationWrapper extends StatefulWidget {
  final Widget child;
  final Color accentColor;

  const _AnimatedIllustrationWrapper({
    super.key,
    required this.child,
    required this.accentColor,
  });

  @override
  State<_AnimatedIllustrationWrapper> createState() =>
      _AnimatedIllustrationWrapperState();
}

class _AnimatedIllustrationWrapperState
    extends State<_AnimatedIllustrationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeScale;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fadeScale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _pulse = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _ctrl.forward();
    // Pulse loop
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _ctrl.repeat(reverse: true,
            period: const Duration(milliseconds: 2000));
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeScale,
      child: ScaleTransition(
        scale: _pulse,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.accentColor.withOpacity(0.18),
                    widget.accentColor.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Inner glow ring
            Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.accentColor.withOpacity(0.25),
                  width: 1.5,
                ),
              ),
            ),
            // Illustration
            widget.child,
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Page text content (animated)
// ─────────────────────────────────────────────
class _PageTextContent extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color accentColor;
  final bool isFirstPage;

  const _PageTextContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.isFirstPage,
  });

  @override
  State<_PageTextContent> createState() => _PageTextContentState();
}

class _PageTextContentState extends State<_PageTextContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Accent line
            Container(
              width: 48,
              height: 3,
              decoration: BoxDecoration(
                color: widget.accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: widget.isFirstPage ? 36 : 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: widget.isFirstPage ? 2 : 0.5,
                height: 1.1,
                shadows: [
                  Shadow(
                    color: widget.accentColor.withOpacity(0.5),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
                height: 1.6,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Page 1 — Logo Illustration
// ─────────────────────────────────────────────
class _LogoIllustration extends StatelessWidget {
  const _LogoIllustration();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: 200,
      height: 200,
      fit: BoxFit.contain,
    );
  }
}

// ─────────────────────────────────────────────
//  Page 2 — Therapist Illustration (CustomPainter)
// ─────────────────────────────────────────────
class _TherapistIllustration extends StatelessWidget {
  const _TherapistIllustration();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(180, 180),
      painter: _TherapistPainter(),
    );
  }
}

class _TherapistPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()..style = PaintingStyle.fill;

    // ── Person (left) ──
    // Head
    strokePaint.color = const Color(0xFF34D399);
    strokePaint.strokeWidth = 3;
    fillPaint.color = const Color(0xFF34D399).withOpacity(0.15);
    canvas.drawCircle(Offset(w * 0.32, h * 0.22), 18, fillPaint);
    canvas.drawCircle(Offset(w * 0.32, h * 0.22), 18, strokePaint);

    // Body
    final bodyPath = Path()
      ..moveTo(w * 0.32, h * 0.42)
      ..cubicTo(w * 0.15, h * 0.48, w * 0.12, h * 0.65, w * 0.18, h * 0.78)
      ..lineTo(w * 0.46, h * 0.78)
      ..cubicTo(w * 0.52, h * 0.65, w * 0.49, h * 0.48, w * 0.32, h * 0.42);
    canvas.drawPath(bodyPath, fillPaint);
    canvas.drawPath(bodyPath, strokePaint);

    // Arms
    canvas.drawLine(
        Offset(w * 0.2, h * 0.52), Offset(w * 0.08, h * 0.62), strokePaint);
    canvas.drawLine(
        Offset(w * 0.44, h * 0.52), Offset(w * 0.58, h * 0.50), strokePaint);

    // ── Person (right, therapist) ──
    strokePaint.color = const Color(0xFF818CF8);
    fillPaint.color = const Color(0xFF818CF8).withOpacity(0.15);
    canvas.drawCircle(Offset(w * 0.72, h * 0.22), 18, fillPaint);
    canvas.drawCircle(Offset(w * 0.72, h * 0.22), 18, strokePaint);

    final body2Path = Path()
      ..moveTo(w * 0.72, h * 0.42)
      ..cubicTo(w * 0.55, h * 0.48, w * 0.52, h * 0.65, w * 0.58, h * 0.78)
      ..lineTo(w * 0.86, h * 0.78)
      ..cubicTo(w * 0.92, h * 0.65, w * 0.89, h * 0.48, w * 0.72, h * 0.42);
    canvas.drawPath(body2Path, fillPaint);
    canvas.drawPath(body2Path, strokePaint);

    canvas.drawLine(
        Offset(w * 0.6, h * 0.52), Offset(w * 0.47, h * 0.50), strokePaint);
    canvas.drawLine(
        Offset(w * 0.84, h * 0.52), Offset(w * 0.96, h * 0.62), strokePaint);

    // ── Connecting heart in middle ──
    final heartPaint = Paint()
      ..color = const Color(0xFFF472B6)
      ..style = PaintingStyle.fill;
    final heartGlowPaint = Paint()
      ..color = const Color(0xFFF472B6).withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    _drawHeart(canvas, Offset(w * 0.5, h * 0.50), 18, heartGlowPaint);
    _drawHeart(canvas, Offset(w * 0.5, h * 0.50), 12, heartPaint);

    // Connection lines
    final linePaint = Paint()
      ..color = const Color(0xFFF472B6).withOpacity(0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.58, h * 0.50),
        Offset(w * 0.5 + 12, h * 0.50), linePaint);
    canvas.drawLine(Offset(w * 0.42, h * 0.50),
        Offset(w * 0.5 - 12, h * 0.50), linePaint);

    // ── Chat bubbles ──
    _drawBubble(canvas, Offset(w * 0.15, h * 0.12), w * 0.22, h * 0.12,
        const Color(0xFF34D399));
    _drawBubble(canvas, Offset(w * 0.63, h * 0.06), w * 0.28, h * 0.12,
        const Color(0xFF818CF8));
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy + size * 0.35);
    path.cubicTo(center.dx - size, center.dy - size * 0.3, center.dx - size,
        center.dy - size * 0.8, center.dx, center.dy - size * 0.3);
    path.cubicTo(center.dx + size, center.dy - size * 0.8, center.dx + size,
        center.dy - size * 0.3, center.dx, center.dy + size * 0.35);
    canvas.drawPath(path, paint);
  }

  void _drawBubble(
      Canvas canvas, Offset pos, double bw, double bh, Color color) {
    final paint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: pos, width: bw, height: bh),
        const Radius.circular(10));
    canvas.drawRRect(rect, paint);
    canvas.drawRRect(rect, borderPaint);
    // Lines inside bubble
    final lp = Paint()
      ..color = color.withOpacity(0.6)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(pos.dx - bw * 0.3, pos.dy - 2),
        Offset(pos.dx + bw * 0.3, pos.dy - 2), lp);
    canvas.drawLine(Offset(pos.dx - bw * 0.2, pos.dy + 4),
        Offset(pos.dx + bw * 0.2, pos.dy + 4), lp);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
//  Page 3 — Healing/Lotus Illustration
// ─────────────────────────────────────────────
class _HealingIllustration extends StatelessWidget {
  const _HealingIllustration();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(180, 180),
      painter: _HealingPainter(),
    );
  }
}

class _HealingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h * 0.62);
    final accentPurple = const Color(0xFFC084FC);
    final accentPink = const Color(0xFFF472B6);
    final accentAmber = const Color(0xFFFBBF24);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.5;
    final fill = Paint()..style = PaintingStyle.fill;

    // ── Sun / energy rays ──
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * pi - pi / 2;
      final rStart = 28.0;
      final rEnd = 42.0 + (i.isEven ? 8 : 0);
      stroke.color = accentAmber.withOpacity(0.6 - i * 0.03);
      stroke.strokeWidth = i.isEven ? 2 : 1.5;
      canvas.drawLine(
        Offset(center.dx + cos(angle) * rStart,
            center.dy + sin(angle) * rStart),
        Offset(
            center.dx + cos(angle) * rEnd, center.dy + sin(angle) * rEnd),
        stroke,
      );
    }

    // ── Inner sun circle ──
    fill.color = accentAmber.withOpacity(0.15);
    canvas.drawCircle(center, 26, fill);
    fill.color = accentAmber.withOpacity(0.3);
    canvas.drawCircle(center, 18, fill);
    stroke.color = accentAmber;
    stroke.strokeWidth = 2;
    canvas.drawCircle(center, 18, stroke);

    // ── Lotus petals ──
    final petalColors = [accentPurple, accentPink, accentPurple, accentPink];
    for (int i = 0; i < 4; i++) {
      final angle = (i / 4) * 2 * pi;
      final petalCenter = Offset(
        center.dx + cos(angle) * 40,
        center.dy + sin(angle) * 40,
      );
      fill.color = petalColors[i].withOpacity(0.25);
      stroke.color = petalColors[i].withOpacity(0.7);
      stroke.strokeWidth = 1.5;

      final petalPath = Path()
        ..moveTo(center.dx, center.dy)
        ..quadraticBezierTo(
          petalCenter.dx - sin(angle) * 14,
          petalCenter.dy + cos(angle) * 14,
          petalCenter.dx,
          petalCenter.dy,
        )
        ..quadraticBezierTo(
          petalCenter.dx + sin(angle) * 14,
          petalCenter.dy - cos(angle) * 14,
          center.dx,
          center.dy,
        );
      canvas.drawPath(petalPath, fill);
      canvas.drawPath(petalPath, stroke);
    }

    // ── Upward floating sparkles ──
    final sparklePositions = [
      Offset(w * 0.25, h * 0.22),
      Offset(w * 0.5, h * 0.08),
      Offset(w * 0.75, h * 0.18),
      Offset(w * 0.38, h * 0.05),
      Offset(w * 0.62, h * 0.28),
    ];
    for (int i = 0; i < sparklePositions.length; i++) {
      final sp = sparklePositions[i];
      final r = 3.0 + (i % 2) * 2.0;
      fill.color = [accentPurple, accentAmber, accentPink][i % 3]
          .withOpacity(0.8);
      canvas.drawCircle(sp, r, fill);
      // Cross sparkle lines
      stroke.color = fill.color;
      stroke.strokeWidth = 1;
      canvas.drawLine(
          Offset(sp.dx, sp.dy - r * 2), Offset(sp.dx, sp.dy + r * 2), stroke);
      canvas.drawLine(
          Offset(sp.dx - r * 2, sp.dy), Offset(sp.dx + r * 2, sp.dy), stroke);
    }

    // ── Bottom wave ──
    final wavePath = Path()
      ..moveTo(0, h * 0.88)
      ..cubicTo(w * 0.25, h * 0.82, w * 0.5, h * 0.94, w * 0.75, h * 0.84)
      ..cubicTo(w * 0.88, h * 0.78, w, h * 0.88, w, h * 0.88)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    fill.color = accentPurple.withOpacity(0.12);
    canvas.drawPath(wavePath, fill);
    stroke.color = accentPurple.withOpacity(0.35);
    stroke.strokeWidth = 1.5;

    final waveStrokePath = Path()
      ..moveTo(0, h * 0.88)
      ..cubicTo(w * 0.25, h * 0.82, w * 0.5, h * 0.94, w * 0.75, h * 0.84)
      ..cubicTo(w * 0.88, h * 0.78, w, h * 0.88, w, h * 0.88);
    canvas.drawPath(waveStrokePath, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────
//  Background Painter (animated blobs)
// ─────────────────────────────────────────────
class _BackgroundPainter extends CustomPainter {
  final double t;
  _BackgroundPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    // Base background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF08091A),
    );

    final glow = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 90);

    // Blob 1 — blue
    glow.color = const Color(0xFF1D4ED8).withOpacity(0.35);
    canvas.drawCircle(
      Offset(size.width * 0.15 + sin(t * 2 * pi) * 40,
          size.height * 0.25 + cos(t * 2 * pi) * 40),
      180,
      glow,
    );

    // Blob 2 — purple
    glow.color = const Color(0xFF7C3AED).withOpacity(0.28);
    canvas.drawCircle(
      Offset(size.width * 0.85 + cos(t * 2 * pi) * 50,
          size.height * 0.65 + sin(t * 2 * pi) * 50),
      220,
      glow,
    );

    // Blob 3 — pink
    glow.color = const Color(0xFFDB2777).withOpacity(0.15);
    canvas.drawCircle(
      Offset(size.width * 0.5 + sin(t * 2 * pi + 1.5) * 70,
          size.height * 0.8 + cos(t * 2 * pi + 1.5) * 40),
      160,
      glow,
    );

    // Blob 4 — teal (subtle, top)
    glow.color = const Color(0xFF0D9488).withOpacity(0.12);
    canvas.drawCircle(
      Offset(size.width * 0.7 + cos(t * 2 * pi + 0.8) * 30,
          size.height * 0.1 + sin(t * 2 * pi + 0.8) * 30),
      130,
      glow,
    );
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter old) => old.t != t;
}
