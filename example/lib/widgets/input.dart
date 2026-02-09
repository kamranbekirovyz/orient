import 'package:example/styling.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

// Customizable constants
const double _kHeight = 52;
const double _kHorizontalPadding = 12;
const double _kVerticalPadding = 8;
const double _kBorderRadius = 10;
const double _kFontSize = 16;
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
  bool get _isFloating =>
      widget.label != null && (_isFocused || _controller.text.isNotEmpty);

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
            onTap: widget.disabled ? null : () => _focusNode.requestFocus(),
            behavior: HitTestBehavior.translucent,
            child: AnimatedContainer(
              duration: Styling.durations.fast,
              constraints: _isMultiline
                  ? null
                  : const BoxConstraints(minHeight: _kHeight),
              padding: EdgeInsets.symmetric(
                horizontal: _kHorizontalPadding,
              ),
              decoration: BoxDecoration(
                color: styling.colors.background,
                borderRadius: BorderRadius.circular(_kBorderRadius),
                border: Border.all(
                  color: borderColor,
                  width: _kBorderWidth,
                ),
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: _isMultiline ? 0 : _kVerticalPadding,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Floating label
                          if (widget.label != null)
                            AnimatedPositioned(
                              duration: Styling.durations.fast,
                              curve: Curves.easeOut,
                              top: _isFloating ? 0 : (_kHeight - _kVerticalPadding * 2 - _kFontSize) / 2,
                              left: 0,
                              child: AnimatedDefaultTextStyle(
                                duration: Styling.durations.fast,
                                curve: Curves.easeOut,
                                style: TextStyle(
                                  fontSize: _isFloating ? 12 : _kFontSize,
                                  height: 16 / (_isFloating ? 12 : _kFontSize),
                                  color: styling.colors.secondaryText,
                                ),
                                child: Text(widget.label!),
                              ),
                            ),
                          // Placeholder (only when no label, or when floating and empty)
                          if (showPlaceholder && widget.label == null)
                            Positioned(
                              top: (_kHeight - _kVerticalPadding * 2 - _kFontSize) / 2,
                              left: 0,
                              child: Text(
                                widget.placeholder!,
                                style: TextStyle(
                                  fontSize: _kFontSize,
                                  height: _kFontSize / _kFontSize,
                                  color: styling.colors.secondaryText,
                                ),
                              ),
                            ),
                          // Input field
                          Padding(
                            padding: EdgeInsets.only(
                              top: widget.label != null ? 16 : (_kHeight - _kVerticalPadding * 2 - _kFontSize) / 2,
                            ),
                            child: EditableText(
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
                          ),
                        ],
                      ),
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

    final bool hasDescription = widget.description != null;

    if (!hasDescription && !_showError) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
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

    // Pupil circle (radius 2)
    canvas.drawCircle(Offset(12 * s, 12 * s), 2 * s, paint);

    // Eye outline
    final path = Path();
    path.moveTo(21 * s, 12 * s);
    // Top arc: 21,12 -> 12,6 (via control points)
    path.cubicTo(
      18.6 * s, 8 * s,
      15.6 * s, 6 * s,
      12 * s, 6 * s,
    );
    // Continue: 12,6 -> 3,12
    path.cubicTo(
      8.4 * s, 6 * s,
      5.4 * s, 8 * s,
      3 * s, 12 * s,
    );
    // Bottom arc: 3,12 -> 12,18
    path.cubicTo(
      5.4 * s, 16 * s,
      8.4 * s, 18 * s,
      12 * s, 18 * s,
    );
    // Continue: 12,18 -> 21,12
    path.cubicTo(
      15.6 * s, 18 * s,
      18.6 * s, 16 * s,
      21 * s, 12 * s,
    );
    canvas.drawPath(path, paint);
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

    // Partial pupil arc (visible part of circle)
    final pupilPath = Path();
    pupilPath.moveTo(10.585 * s, 10.587 * s);
    pupilPath.arcToPoint(
      Offset(13.414 * s, 13.415 * s),
      radius: Radius.circular(2 * s),
    );
    canvas.drawPath(pupilPath, paint);

    // Eye outline (partial, with gaps for slash)
    // Right side: 16.681,16.673 -> 12,18 -> 3,12
    final rightPath = Path();
    rightPath.moveTo(16.681 * s, 16.673 * s);
    rightPath.cubicTo(
      15.5 * s, 17.5 * s,
      13.8 * s, 18 * s,
      12 * s, 18 * s,
    );
    rightPath.cubicTo(
      8.4 * s, 18 * s,
      5.4 * s, 16 * s,
      3 * s, 12 * s,
    );
    // Continue: 3,12 -> up to 7.32,7.326
    rightPath.cubicTo(
      4.272 * s, 9.88 * s,
      5.712 * s, 8.322 * s,
      7.32 * s, 7.326 * s,
    );
    canvas.drawPath(rightPath, paint);

    // Left side: 10.18,5.82 -> 12,6 -> 21,12 -> 18.862,14.87
    final leftPath = Path();
    leftPath.moveTo(10.18 * s, 5.82 * s);
    leftPath.cubicTo(
      10.76 * s, 5.68 * s,
      11.37 * s, 5.82 * s,
      12 * s, 6 * s,
    );
    leftPath.cubicTo(
      15.6 * s, 6 * s,
      18.6 * s, 8 * s,
      21 * s, 12 * s,
    );
    leftPath.cubicTo(
      20.334 * s, 13.11 * s,
      19.621 * s, 14.067 * s,
      18.862 * s, 14.87 * s,
    );
    canvas.drawPath(leftPath, paint);

    // Diagonal strike-through line
    canvas.drawLine(
      Offset(3 * s, 3 * s),
      Offset(21 * s, 21 * s),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _EyeClosedPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
