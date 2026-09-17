import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoGlow;
  late final Animation<double> _textOpacity;
  late final Animation<double> _textSlide;
  late final Animation<double> _lineWidth;
  late final Animation<double> _bottomOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // Logo: aparece suavemente y hace un pequeño "pulso".
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.72, end: 1.06).chain(
          CurveTween(curve: Curves.easeOutCubic),
        ),
        weight: 65,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.06, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOut),
        ),
        weight: 35,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.48),
      ),
    );

    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.24,
        curve: Curves.easeOut,
      ),
    );

    // Intensidad del brillo del logo.
    _logoGlow = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.08,
          0.42,
          curve: Curves.easeOut,
        ),
      ),
    );

    // Nombre de la aplicación.
    _textOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.34,
        0.62,
        curve: Curves.easeOut,
      ),
    );

    _textSlide = Tween<double>(
      begin: 16,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.34,
          0.62,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // Barra inferior.
    _lineWidth = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.58,
          0.92,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _bottomOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.68,
        0.90,
        curve: Curves.easeOut,
      ),
    );

    _start();
  }

  Future<void> _start() async {
    await _controller.forward();

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      AppRouter.home,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF233131),
      body: Stack(
        children: [
          // Fondo de partículas.
          const Positioned.fill(
            child: _BackgroundParticles(),
          ),

          // Contenido principal.
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // LOGO
                    Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: _Logo(
                          glowIntensity: _logoGlow.value,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // NOMBRE + DESCRIPCIÓN
                    Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: Opacity(
                        opacity: _textOpacity.value,
                        child: const Column(
                          children: [
                            Text(
                              'CipherVault',
                              style: TextStyle(
                                color: Color(0xFFF1F5F4),
                                fontSize: 29,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.6,
                              ),
                            ),

                            SizedBox(height: 10),

                            Text(
                              'ENCRYPT • PROTECT • HIDE',
                              style: TextStyle(
                                color: Color(0xFF72F2B6),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 2.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // BARRA DE PROGRESO
                    SizedBox(
                      width: 110,
                      height: 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: _lineWidth.value,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF39D98A),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x6639D98A),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Texto inferior.
          Positioned(
            bottom: 34,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _bottomOpacity,
              builder: (context, child) {
                return Opacity(
                  opacity: _bottomOpacity.value,
                  child: const Text(
                    'LOCAL • PRIVATE • SECURE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0x668FA7A2),
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// LOGO
// -----------------------------------------------------------------------------

class _Logo extends StatelessWidget {
  final double glowIntensity;

  const _Logo({
    required this.glowIntensity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      height: 155,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF39D98A).withValues(
              alpha: 0.05 + (glowIntensity * 0.10),
            ),
            blurRadius: 30 + (glowIntensity * 20),
            spreadRadius: 2 + (glowIntensity * 5),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/logo.png',
        width: 155,
        height: 155,
        fit: BoxFit.contain,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// PARTÍCULAS DEL FONDO
// -----------------------------------------------------------------------------

class _BackgroundParticles extends StatefulWidget {
  const _BackgroundParticles();

  @override
  State<_BackgroundParticles> createState() =>
      _BackgroundParticlesState();
}

class _BackgroundParticlesState extends State<_BackgroundParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  final List<_Particle> _particles = List.generate(
    50,
    (index) => _Particle(index),
  );

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlesPainter(
            particles: _particles,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double phase;

  _Particle(int index)
      : x = _random(index * 17 + 1),
        y = _random(index * 31 + 7),
        size = 0.8 + (_random(index * 13 + 4) * 1.8),
        speed = 0.15 + (_random(index * 23 + 8) * 0.45),
        phase = _random(index * 41 + 3);

  static double _random(int seed) {
    final value = math.sin(seed * 12.9898) * 43758.5453;
    return value - value.floor();
  }
}

class _ParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlesPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final movement = math.sin(
        (progress * math.pi * 2 * particle.speed) +
            particle.phase,
      );

      final dx = particle.x * size.width;

      final dy = particle.y * size.height +
          (movement * 8);

      final opacity =
          0.08 + ((movement + 1) / 2) * 0.16;

      final paint = Paint()
        ..color = const Color(0xFF72F2B6).withValues(
          alpha: opacity,
        );

      canvas.drawCircle(
        Offset(dx, dy),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _ParticlesPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}
