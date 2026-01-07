import 'dart:io';
import 'package:http/http.dart' as http;

const baseUrl =
    'https://raw.githubusercontent.com/userorient/orient-ui/main/templates';

void main(List<String> args) async {
  if (args.isEmpty) {
    _printUsage();
    return;
  }

  final command = args[0];

  switch (command) {
    case 'init':
      await _initCommand();
      break;
    case 'add':
      if (args.length < 2) {
        print('❌ Please specify a component: orient_ui add <component>');
        return;
      }
      await _addCommand(args[1]);
      break;
    default:
      _printUsage();
  }
}

void _printUsage() {
  print('Orient UI - Design system for Flutter');
  print('Usage:');
  print('  orient_ui init           Initialize styling');
  print('  orient_ui add <widget>   Add a widget (button, etc)');
}

Future<void> _initCommand() async {
  print('🎨 Initializing Orient UI...');

  try {
    await _fetchAndSave('styling.dart', 'lib/styling.dart');

    print('🎉 All set! Wrap your app:');
    print('   ┌─────────────────────────────────');
    print('   │ Styling(');
    print('   │   brightness: Brightness.light,');
    print('   │   child: MaterialApp(...)');
    print('   │ )');
    print('   └─────────────────────────────────');
  } catch (e) {
    print('❌ Failed: $e');
    exit(1);
  }
}

Future<void> _addCommand(String widget) async {
  print('📦 Adding $widget...');

  final components = {
    'button': ComponentInfo('button.dart', dependencies: ['spinner']),
    'spinner': ComponentInfo('spinner.dart'),
  };

  if (!components.containsKey(widget)) {
    print('❌ Widget "$widget" not found');
    print('Available: ${components.keys.join(', ')}');
    exit(1);
  }

  final component = components[widget]!;

  try {
    await _fetchAndSave(component.filename, 'lib/$widget.dart');
    print('📝 Don\'t forget to import styling.dart in $widget.dart');

    if (component.dependencies.isNotEmpty) {
      print('⚠️  Depends on: ${component.dependencies.join(', ')}');
      print('   Run: orient_ui add ${component.dependencies.first}');
    }
  } catch (e) {
    print('❌ Failed: $e');
    exit(1);
  }
}

class ComponentInfo {
  final String filename;
  final List<String> dependencies;

  ComponentInfo(this.filename, {this.dependencies = const []});
}

Future<void> _fetchAndSave(String filename, String destination) async {
  final url = '$baseUrl/$filename';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch (${response.statusCode})');
  }

  final file = File(destination);
  file.createSync(recursive: true);
  file.writeAsStringSync(response.body);

  print('✨ Created $destination');
}
