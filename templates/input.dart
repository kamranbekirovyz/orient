import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'styling.dart';

// Customizable constants
const double _kHeight = 40;
const double _kHorizontalPadding = 12;
const double _kVerticalPadding = 8;
const double _kBorderRadius = 8;
const double _kFontSize = 14;
const double _kBorderWidth = 1;

class Input extends StatefulWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? placeholder;
  final String? label;
  final String? description;
  final bool disabled;
  final bool readOnly;
  final String? errorText;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final double? width;
  final FocusNode? focusNode;

  const Input({
    super.key,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.placeholder,
    this.label,
    this.description,
    this.disabled = false,
    this.readOnly = false,
    this.errorText,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = false,
    this.width,
    this.focusNode,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _isHovered = false;
  bool _obscured = false;

  bool get _isMultiline => widget.maxLines > 1;
  bool get _showError => widget.errorText != null;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _obscured = widget.obscureText;
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onTextChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChange() {
    setState(() {});
    widget.onChanged?.call(_controller.text);
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final StylingData styling = Styling.of(context);
    final bool showPlaceholder =
        _controller.text.isEmpty && widget.placeholder != null;

    final Color borderColor;
    if (_showError) {
      borderColor = styling.colors.input.error;
    } else if (_isFocused) {
      borderColor = styling.colors.input.borderFocus;
    } else if (_isHovered && !widget.disabled) {
      borderColor = styling.colors.input.borderFocus;
    } else {
      borderColor = styling.colors.input.border;
    }

    final List<BoxShadow> shadows;
    if (_isFocused && !_showError) {
      shadows = [
        BoxShadow(
          color: styling.colors.input.borderFocus.withValues(alpha: 0.15),
          blurRadius: 0,
          spreadRadius: 2,
        ),
      ];
    } else if (_isFocused && _showError) {
      shadows = [
        BoxShadow(
          color: styling.colors.input.error.withValues(alpha: 0.15),
          blurRadius: 0,
          spreadRadius: 2,
        ),
      ];
    } else {
      shadows = [];
    }

    Widget field = Semantics(
      textField: true,
      focused: _isFocused,
      hint: widget.placeholder,
      child: Opacity(
        opacity: widget.disabled ? 0.5 : 1.0,
        child: MouseRegion(
          cursor: widget.disabled
              ? SystemMouseCursors.forbidden
              : SystemMouseCursors.text,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.disabled
                ? null
                : () => _focusNode.requestFocus(),
            behavior: HitTestBehavior.translucent,
            child: AnimatedContainer(
              duration: Styling.durations.fast,
              constraints: _isMultiline
                  ? null
                  : const BoxConstraints(minHeight: _kHeight),
              padding: EdgeInsets.symmetric(
                horizontal: _kHorizontalPadding,
                vertical: _isMultiline ? _kVerticalPadding : 0,
              ),
              decoration: BoxDecoration(
                color: styling.colors.background,
                borderRadius: BorderRadius.circular(_kBorderRadius),
                border: Border.all(
                  color: borderColor,
                  width: _kBorderWidth,
                ),
                boxShadow: shadows,
              ),
              child: Row(
                crossAxisAlignment: _isMultiline
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  if (widget.prefix != null) ...[
                    widget.prefix!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Stack(
                      alignment: _isMultiline
                          ? Alignment.topLeft
                          : Alignment.centerLeft,
                      children: [
                        if (showPlaceholder)
                          Text(
                            widget.placeholder!,
                            style: TextStyle(
                              fontSize: _kFontSize,
                              height: _kFontSize / _kFontSize,
                              color: styling.colors.secondaryText,
                            ),
                          ),
                        EditableText(
                          controller: _controller,
                          focusNode: _focusNode,
                          readOnly: widget.readOnly || widget.disabled,
                          obscureText: _obscured,
                          maxLines: widget.obscureText ? 1 : widget.maxLines,
                          minLines: widget.minLines,
                          scrollPadding: EdgeInsets.zero,
                          keyboardType: widget.keyboardType,
                          textInputAction: widget.textInputAction,
                          inputFormatters: widget.maxLength != null
                              ? [
                                  LengthLimitingTextInputFormatter(
                                    widget.maxLength,
                                  ),
                                ]
                              : null,
                          style: TextStyle(
                            fontSize: _kFontSize,
                            height: _kFontSize / _kFontSize,
                            color: styling.colors.primaryText,
                          ),
                          cursorColor: styling.colors.primaryText,
                          cursorHeight: 16,
                          backgroundCursorColor: const Color(0x00000000),
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmitted,
                        ),
                      ],
                    ),
                  ),
                  if (widget.obscureText) ...[
                    const SizedBox(width: 8),
                    Semantics(
                      button: true,
                      label: _obscured ? 'Show password' : 'Hide password',
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: widget.disabled ? null : _toggleObscured,
                          child: CustomPaint(
                            size: const Size(20, 20),
                            painter: _obscured
                                ? _EyeClosedPainter(
                                    color: styling.colors.secondaryText,
                                  )
                                : _EyeOpenPainter(
                                    color: styling.colors.secondaryText,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ] else if (widget.suffix != null) ...[
                    const SizedBox(width: 8),
                    widget.suffix!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.width != null) {
      field = SizedBox(width: widget.width, child: field);
    }

    final bool hasLabel = widget.label != null;
    final bool hasDescription = widget.description != null;

    if (!hasLabel && !hasDescription && !_showError) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasLabel) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: styling.colors.primaryText,
            ),
          ),
          const SizedBox(height: 6),
        ],
        if (hasDescription) ...[
          Text(
            widget.description!,
            style: TextStyle(
              fontSize: 13,
              color: styling.colors.secondaryText,
            ),
          ),
          const SizedBox(height: 6),
        ],
        field,
        if (_showError) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: TextStyle(
              fontSize: 13,
              color: styling.colors.input.error,
            ),
          ),
        ],
      ],
    );
  }
}

// Tabler eye icon (open)
class _EyeOpenPainter extends CustomPainter {
  final Color color;

  const _EyeOpenPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width / 24;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Eye shape — two arcs forming an eye
    final path = Path();
    path.moveTo(3 * s, 12 * s);
    path.cubicTo(5 * s, 7 * s, 9 * s, 5 * s, 12 * s, 5 * s);
    path.cubicTo(15 * s, 5 * s, 19 * s, 7 * s, 21 * s, 12 * s);
    path.cubicTo(19 * s, 17 * s, 15 * s, 19 * s, 12 * s, 19 * s);
    path.cubicTo(9 * s, 19 * s, 5 * s, 17 * s, 3 * s, 12 * s);
    canvas.drawPath(path, paint);

    // Pupil circle
    canvas.drawCircle(Offset(12 * s, 12 * s), 3 * s, paint);
  }

  @override
  bool shouldRepaint(covariant _EyeOpenPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

// Tabler eye-off icon (closed)
class _EyeClosedPainter extends CustomPainter {
  final Color color;

  const _EyeClosedPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width / 24;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Upper arc of closed eye
    final path = Path();
    path.moveTo(3 * s, 12 * s);
    path.cubicTo(5 * s, 7 * s, 9 * s, 5 * s, 12 * s, 5 * s);
    path.cubicTo(15 * s, 5 * s, 19 * s, 7 * s, 21 * s, 12 * s);
    canvas.drawPath(path, paint);

    // Diagonal strike-through line
    canvas.drawLine(
      Offset(4 * s, 4 * s),
      Offset(20 * s, 20 * s),
      paint,
    );

    // Lower arc (partial, showing "closed" effect)
    final lowerPath = Path();
    lowerPath.moveTo(21 * s, 12 * s);
    lowerPath.cubicTo(19 * s, 17 * s, 15 * s, 19 * s, 12 * s, 19 * s);
    lowerPath.cubicTo(9 * s, 19 * s, 5 * s, 17 * s, 3 * s, 12 * s);
    canvas.drawPath(lowerPath, paint);
  }

  @override
  bool shouldRepaint(covariant _EyeClosedPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
