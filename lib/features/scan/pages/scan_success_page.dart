import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class ScanSuccessPage extends StatefulWidget {
  final int totalFigurinhas;

  const ScanSuccessPage({
    super.key,
    required this.totalFigurinhas,
  });

  @override
  State<ScanSuccessPage> createState() => _ScanSuccessPageState();
}

class _ScanSuccessPageState extends State<ScanSuccessPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _checkScale;
  late final Animation<double> _checkOpacity;
  late final Animation<double> _checkRotation;

  late final Animation<double> _burstProgress;
  late final Animation<double> _burstOpacity;

  late final Animation<double> _textOpacity;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _checkScale = Tween<double>(
      begin: 0.72,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.55,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _checkOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.35,
        curve: Curves.easeOut,
      ),
    );

    _checkRotation = Tween<double>(
      begin: -0.025,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.55,
          curve: Curves.easeOut,
        ),
      ),
    );

    _burstProgress = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.18,
          0.85,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    _burstOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.20,
          0.42,
          curve: Curves.easeOut,
        ),
      ),
    );

    _textOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.42,
        1.0,
        curve: Curves.easeOut,
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.22),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.42,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2600), () {
      if (!mounted) return;

      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get mensagem {
    if (widget.totalFigurinhas == 1) {
      return '1 FIGURINHA MARCADA';
    }

    return '${widget.totalFigurinhas} FIGURINHAS MARCADAS';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _SuccessBurstPainter(
                    progress: _burstProgress.value,
                    opacity: _burstOpacity.value,
                  ),
                ),
              ),

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeTransition(
                      opacity: _checkOpacity,
                      child: ScaleTransition(
                        scale: _checkScale,
                        child: RotationTransition(
                          turns: _checkRotation,
                          child: Container(
                            width: 156,
                            height: 156,
                            decoration: BoxDecoration(
                              color: AppColors.successGreen,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.successGreen.withAlpha(70),
                                  blurRadius: 28,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 96,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    FadeTransition(
                      opacity: _textOpacity,
                      child: SlideTransition(
                        position: _textSlide,
                        child: Column(
                          children: [
                            Text(
                              mensagem,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'COLEÇÃO ATUALIZADA',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SuccessBurstPainter extends CustomPainter {
  final double progress;
  final double opacity;

  const _SuccessBurstPainter({
    required this.progress,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;

    final center = Offset(size.width / 2, size.height / 2 - 48);

    final paint = Paint()
      ..color = AppColors.successGreen.withAlpha((115 * opacity).round())
      ..style = PaintingStyle.fill;

    final particles = [
      _BurstParticle(angle: -150, distance: 118, size: 7),
      _BurstParticle(angle: -125, distance: 150, size: 5),
      _BurstParticle(angle: -95, distance: 134, size: 6),
      _BurstParticle(angle: -55, distance: 140, size: 5),
      _BurstParticle(angle: -30, distance: 118, size: 7),
      _BurstParticle(angle: 18, distance: 135, size: 5),
      _BurstParticle(angle: 46, distance: 158, size: 7),
      _BurstParticle(angle: 78, distance: 125, size: 5),
      _BurstParticle(angle: 118, distance: 150, size: 6),
      _BurstParticle(angle: 148, distance: 120, size: 5),
      _BurstParticle(angle: 190, distance: 138, size: 7),
      _BurstParticle(angle: 225, distance: 158, size: 5),
      _BurstParticle(angle: 260, distance: 130, size: 6),
      _BurstParticle(angle: 305, distance: 142, size: 5),
      _BurstParticle(angle: 335, distance: 118, size: 7),
    ];

    for (final particle in particles) {
      final radians = particle.angle * math.pi / 180;

      final easedProgress = Curves.easeOutCubic.transform(progress);

      final distance = particle.distance * easedProgress;

      final position = Offset(
        center.dx + math.cos(radians) * distance,
        center.dy + math.sin(radians) * distance,
      );

      final particleOpacity = (1.0 - (progress * 0.35)).clamp(0.0, 1.0);

      paint.color = AppColors.successGreen.withAlpha(
        (120 * opacity * particleOpacity).round(),
      );

      canvas.drawCircle(
        position,
        particle.size * (0.75 + progress * 0.45),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SuccessBurstPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.opacity != opacity;
  }
}

class _BurstParticle {
  final double angle;
  final double distance;
  final double size;

  const _BurstParticle({
    required this.angle,
    required this.distance,
    required this.size,
  });
}