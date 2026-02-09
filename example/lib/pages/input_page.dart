import 'package:example/styling.dart';
import 'package:example/widgets/input.dart';
import 'package:flutter/widgets.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _defaultController = TextEditingController();
  final _passwordController = TextEditingController();
  final _multilineController = TextEditingController();

  @override
  void dispose() {
    _defaultController.dispose();
    _passwordController.dispose();
    _multilineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styling = Styling.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Default input
        const Input(placeholder: 'Enter text...'),
        const SizedBox(height: 20),

        // With label and description
        const Input(
          label: 'Email',
          description: 'We will never share your email.',
          placeholder: 'you@example.com',
        ),
        const SizedBox(height: 20),

        // Password input
        const Input(
          label: 'Password',
          placeholder: 'Enter password',
          obscureText: true,
        ),
        const SizedBox(height: 20),

        // Disabled
        const Input(
          label: 'Disabled',
          placeholder: 'Cannot edit this',
          disabled: true,
        ),
        const SizedBox(height: 20),

        // Error state
        const Input(
          label: 'Username',
          placeholder: 'Enter username',
          errorText: 'Username is already taken.',
        ),
        const SizedBox(height: 20),

        // With prefix and suffix
        Input(
          placeholder: 'Search...',
          prefix: CustomPaint(
            size: const Size(16, 16),
            painter: _SearchMiniPainter(
              color: styling.colors.secondaryText,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Multiline (textarea)
        const Input(
          label: 'Bio',
          placeholder: 'Tell us about yourself...',
          maxLines: 4,
          minLines: 3,
        ),
      ],
    );
  }
}

// Tiny search icon for prefix demo
class _SearchMiniPainter extends CustomPainter {
  final Color color;

  const _SearchMiniPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width / 24;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(10 * s, 10 * s), 7 * s, paint);
    canvas.drawLine(Offset(15 * s, 15 * s), Offset(21 * s, 21 * s), paint);
  }

  @override
  bool shouldRepaint(covariant _SearchMiniPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
