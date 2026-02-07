import 'package:flutter/material.dart';
import 'package:example/widgets/button.dart';
import 'package:example/widgets/demo_section.dart';

class ButtonPage extends StatefulWidget {
  const ButtonPage({super.key});

  @override
  State<ButtonPage> createState() => _ButtonPageState();
}

class _ButtonPageState extends State<ButtonPage> {
  bool _loading = false;

  void _simulateLoading() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DemoSection(
          title: 'Variants',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              Button.small(
                onPressed: () {},
                label: 'Primary',
                variant: ButtonVariant.primary,
              ),
              Button.small(
                onPressed: () {},
                label: 'Secondary',
                variant: ButtonVariant.secondary,
              ),
              Button.small(
                onPressed: () {},
                label: 'Destructive',
                variant: ButtonVariant.destructive,
              ),
              Button.small(
                onPressed: () {},
                label: 'Outline',
                variant: ButtonVariant.outline,
              ),
              Button.small(
                onPressed: () {},
                label: 'Ghost',
                variant: ButtonVariant.ghost,
              ),
              Button.small(
                onPressed: () {},
                label: 'Link',
                variant: ButtonVariant.link,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Sizes',
          child: Row(
            children: [
              Expanded(
                child: Button(
                  onPressed: () {},
                  label: 'Default size',
                ),
              ),
              const SizedBox(width: 12),
              Button.small(
                onPressed: () {},
                label: 'Small size',
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'With icon',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              Button.small(
                onPressed: () {},
                label: 'Settings',
                icon: const Icon(Icons.settings),
              ),
              Button.small(
                onPressed: () {},
                label: 'Delete',
                icon: const Icon(Icons.delete),
                variant: ButtonVariant.destructive,
              ),
              Button.small(
                onPressed: () {},
                label: 'Add new',
                icon: const Icon(Icons.add),
                variant: ButtonVariant.outline,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Loading state',
          child: Row(
            children: [
              Button.small(
                onPressed: _simulateLoading,
                label: _loading ? 'Loading...' : 'Click to load',
                loading: _loading,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Disabled state',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              Button.small(
                onPressed: null,
                label: 'Primary',
                variant: ButtonVariant.primary,
              ),
              Button.small(
                onPressed: null,
                label: 'Secondary',
                variant: ButtonVariant.secondary,
              ),
              Button.small(
                onPressed: null,
                label: 'Destructive',
                variant: ButtonVariant.destructive,
              ),
              Button.small(
                onPressed: null,
                label: 'Outline',
                variant: ButtonVariant.outline,
              ),
              Button.small(
                onPressed: null,
                label: 'Ghost',
                variant: ButtonVariant.ghost,
              ),
              Button.small(
                onPressed: null,
                label: 'Link',
                variant: ButtonVariant.link,
              ),
            ],
          ),
        ),
      ],
    );
  }

}
