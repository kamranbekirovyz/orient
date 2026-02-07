import 'package:flutter/widgets.dart';
import 'package:example/widgets/toggle_tile.dart';

class ToggleTilePage extends StatefulWidget {
  const ToggleTilePage({super.key});

  @override
  State<ToggleTilePage> createState() => _ToggleTilePageState();
}

class _ToggleTilePageState extends State<ToggleTilePage> {
  bool _simple = false;
  bool _bordered = true;
  bool _filled = false;
  bool _titleOnly = false;
  bool _withLeading = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          title: 'Simple',
          child: ToggleTile(
            title: 'Notifications',
            subtitle: 'Receive push notifications',
            value: _simple,
            onChanged: (v) => setState(() => _simple = v),
          ),
        ),
        _buildSection(
          title: 'Bordered',
          child: ToggleTile(
            variant: ToggleTileVariant.bordered,
            title: 'Dark Mode',
            subtitle: 'Use dark theme across the app',
            value: _bordered,
            onChanged: (v) => setState(() => _bordered = v),
          ),
        ),
        _buildSection(
          title: 'Filled',
          child: ToggleTile(
            variant: ToggleTileVariant.filled,
            title: 'Auto Update',
            subtitle: 'Automatically install updates',
            value: _filled,
            onChanged: (v) => setState(() => _filled = v),
          ),
        ),
        _buildSection(
          title: 'Title Only',
          child: ToggleTile(
            variant: ToggleTileVariant.bordered,
            title: 'Enable Feature',
            value: _titleOnly,
            onChanged: (v) => setState(() => _titleOnly = v),
          ),
        ),
        _buildSection(
          title: 'With Leading',
          child: ToggleTile(
            variant: ToggleTileVariant.bordered,
            leading: const Text('\u2699', style: TextStyle(fontSize: 24)),
            title: 'Settings',
            subtitle: 'Manage your preferences',
            value: _withLeading,
            onChanged: (v) => setState(() => _withLeading = v),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF71717A),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
