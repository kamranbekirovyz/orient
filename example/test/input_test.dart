import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example/widgets/input.dart';

import 'test_helper.dart';

void main() {
  group('Input', () {
    group('rendering', () {
      testWidgets('renders without error', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(),
        ));

        expect(find.byType(Input), findsOneWidget);
      });

      testWidgets('renders label', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(label: 'Email'),
        ));

        expect(find.text('Email'), findsOneWidget);
      });

      testWidgets('renders description', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(description: 'Enter your email address'),
        ));

        expect(find.text('Enter your email address'), findsOneWidget);
      });

      testWidgets('renders placeholder', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(placeholder: 'Type here...'),
        ));

        expect(find.text('Type here...'), findsOneWidget);
      });

      testWidgets('hides placeholder when text entered', (tester) async {
        final controller = TextEditingController(text: 'hello');

        await tester.pumpWidget(wrapWithStyling(
          Input(
            controller: controller,
            placeholder: 'Type here...',
          ),
        ));

        expect(find.text('Type here...'), findsNothing);
        expect(find.text('hello'), findsOneWidget);
      });

      testWidgets('renders prefix', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(
            prefix: SizedBox(width: 16, height: 16),
          ),
        ));

        expect(find.byType(Input), findsOneWidget);
      });

      testWidgets('renders suffix', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(
            suffix: SizedBox(width: 16, height: 16),
          ),
        ));

        expect(find.byType(Input), findsOneWidget);
      });

      testWidgets('renders error text', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(errorText: 'This field is required'),
        ));

        expect(find.text('This field is required'), findsOneWidget);
      });

      testWidgets('renders multiline', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(maxLines: 4, minLines: 3),
        ));

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.maxLines, 4);
        expect(editableText.minLines, 3);
      });
    });

    group('states', () {
      testWidgets('disabled shows reduced opacity', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(disabled: true, placeholder: 'Disabled'),
        ));

        final opacity = tester.widget<Opacity>(find.byType(Opacity));
        expect(opacity.opacity, 0.5);
      });

      testWidgets('disabled prevents interaction', (tester) async {
        String? changedValue;

        await tester.pumpWidget(wrapWithStyling(
          Input(
            disabled: true,
            onChanged: (value) => changedValue = value,
          ),
        ));

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.readOnly, isTrue);
        expect(changedValue, isNull);
      });
    });

    group('interaction', () {
      testWidgets('onChanged fires', (tester) async {
        String? changedValue;

        await tester.pumpWidget(wrapWithStyling(
          Input(
            onChanged: (value) => changedValue = value,
          ),
        ));

        await tester.enterText(find.byType(EditableText), 'test');
        await tester.pump();

        expect(changedValue, 'test');
      });

      testWidgets('onSubmitted fires', (tester) async {
        String? submittedValue;

        await tester.pumpWidget(wrapWithStyling(
          Input(
            onSubmitted: (value) => submittedValue = value,
          ),
        ));

        await tester.enterText(find.byType(EditableText), 'submitted text');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();

        expect(submittedValue, 'submitted text');
      });

      testWidgets('tap focuses', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(),
        ));

        await tester.tap(find.byType(Input));
        await tester.pump();

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.focusNode.hasFocus, isTrue);
      });

      testWidgets('autofocus works', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(autofocus: true),
        ));

        await tester.pump();
        await tester.pump();

        final editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.focusNode.hasFocus, isTrue);
      });

      testWidgets('password toggle works', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(obscureText: true),
        ));

        // Initially obscured
        var editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.obscureText, isTrue);

        // Tap toggle button
        final toggleButton = find.byType(GestureDetector).last;
        await tester.tap(toggleButton);
        await tester.pump();

        // Now visible
        editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.obscureText, isFalse);

        // Tap again to re-obscure
        await tester.tap(toggleButton);
        await tester.pump();

        editableText =
            tester.widget<EditableText>(find.byType(EditableText));
        expect(editableText.obscureText, isTrue);
      });
    });

    group('controller', () {
      testWidgets('uses provided controller', (tester) async {
        final controller = TextEditingController(text: 'initial');

        await tester.pumpWidget(wrapWithStyling(
          Input(controller: controller),
        ));

        expect(find.text('initial'), findsOneWidget);
      });

      testWidgets('creates internal controller', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(),
        ));

        await tester.enterText(find.byType(EditableText), 'typed');
        await tester.pump();

        expect(find.text('typed'), findsOneWidget);
      });

      testWidgets('updates on external change', (tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(wrapWithStyling(
          Input(controller: controller),
        ));

        controller.text = 'external update';
        await tester.pump();

        expect(find.text('external update'), findsOneWidget);
      });
    });

    group('accessibility', () {
      testWidgets('has textField semantics', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(placeholder: 'Enter text...'),
        ));

        final semantics = tester.getSemantics(find.byType(Semantics).first);
        expect(semantics.hasFlag(SemanticsFlag.isTextField), isTrue);
      });

      testWidgets('password toggle has button semantics', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(obscureText: true),
        ));

        final toggleSemantics = tester.getSemantics(
          find.bySemanticsLabel('Show password'),
        );
        expect(toggleSemantics.hasFlag(SemanticsFlag.isButton), isTrue);
      });
    });

    group('theming', () {
      testWidgets('renders in light mode', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(placeholder: 'Light mode'),
          brightness: Brightness.light,
        ));

        expect(find.text('Light mode'), findsOneWidget);
      });

      testWidgets('renders in dark mode', (tester) async {
        await tester.pumpWidget(wrapWithStyling(
          const Input(placeholder: 'Dark mode'),
          brightness: Brightness.dark,
        ));

        expect(find.text('Dark mode'), findsOneWidget);
      });
    });
  });
}
