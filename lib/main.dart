import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fun Signup App',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _selectedAvatar;
  final List<String> _avatars = ['😊', '🚀', '🎉', '🐱', '🌈'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Us Today for the Cash Money!'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Create Your Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Choose an avatar:', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: _avatars.map((emoji) {
                    final selected = _selectedAvatar == emoji;
                    return ChoiceChip(
                      label: Text(emoji, style: const TextStyle(fontSize: 24)),
                      selected: selected,
                      onSelected: (s) {
                        setState(() {
                          _selectedAvatar = s ? emoji : null;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(
                            name: _nameController.text,
                            avatar: _selectedAvatar ?? '😊',
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  final String name;
  final String avatar;
  const WelcomeScreen({super.key, required this.name, required this.avatar});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _revealController;
  late Animation<double> _revealAnim;
  late AnimationController _confettiController;
  bool _showMessage = false;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..forward();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showMessage = true;
        });
        _revealController.forward();
      }
    });
    _revealController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _revealAnim = CurvedAnimation(parent: _revealController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _revealController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Stack(
        children: [
          Positioned.fill(
            child: ConfettiOverlay(progress: _confettiController),
          ),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _showMessage
                  ? FadeTransition(
                      opacity: _revealAnim,
                      child: ScaleTransition(
                        scale: _revealAnim,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.avatar, style: const TextStyle(fontSize: 72)),
                            const SizedBox(height: 20),
                            Text(
                              'Welcome, ${widget.name}!',
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      key: const ValueKey('pre'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(widget.avatar, style: const TextStyle(fontSize: 72)),
                        const SizedBox(height: 12),
                        const Text('Celebrating...', style: TextStyle(fontSize: 18)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfettiOverlay extends StatefulWidget {
  final AnimationController progress;
  const ConfettiOverlay({super.key, required this.progress});
  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> {
  late List<_Particle> particles;
  final Random rng = Random();

  @override
  void initState() {
    super.initState();
    particles = List.generate(140, (_) => _Particle.random(rng));
    widget.progress.addListener(() {
      setState(() {
        for (final p in particles) {
          p.update(widget.progress.value);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _ConfettiPainter(particles: particles, t: widget.progress.value),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _Particle {
  Offset start;
  double dx;
  double speed;
  double size;
  double spin;
  double hue;
  double life;
  double delay;
  _Particle(this.start, this.dx, this.speed, this.size, this.spin, this.hue, this.life, this.delay);
  factory _Particle.random(Random rng) {
    return _Particle(
      Offset(rng.nextDouble(), -0.1 + rng.nextDouble() * 0.2),
      (rng.nextDouble() - 0.5) * 0.4,
      0.4 + rng.nextDouble() * 0.9,
      2 + rng.nextDouble() * 6,
      rng.nextDouble() * pi,
      rng.nextDouble(),
      0.6 + rng.nextDouble() * 0.4,
      rng.nextDouble() * 0.7,
    );
  }
  void update(double t) {}
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;
  _ConfettiPainter({required this.particles, required this.t});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      if (t < p.delay) continue;
      final localT = ((t - p.delay) / p.life).clamp(0.0, 1.0);
      final y = p.start.dy * size.height + localT * p.speed * size.height;
      final x = p.start.dx * size.width + p.dx * size.width * localT + sin((localT * 6 + p.spin)) * 6;
      final alpha = (1.0 - localT).clamp(0.0, 1.0);
      final hsv = HSVColor.fromAHSV(alpha, p.hue * 360, 0.85, 1.0);
      paint.color = hsv.toColor();
      final rect = Rect.fromCenter(center: Offset(x, y), width: p.size, height: p.size * (0.6 + 0.8 * (0.5 + 0.5 * sin(localT * 10 + p.spin))));
      canvas.save();
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.rotate(localT * 10 + p.spin);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: rect.width, height: rect.height), const Radius.circular(1.5)), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.particles != particles;
  }
}
