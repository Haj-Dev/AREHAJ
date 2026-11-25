import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Catppuccin Latte
const Color yellow = Color(0xFFDF8E1D);
const Color base = Color(0xFFEFF1F5);
const Color mantle = Color(0xFFE6E9EF);
const Color surface0 = Color(0xFFCCD0DA);
const Color text = Color(0xFF4C4F69);
const Color red = Color(0xFFD20F39);

const square = RoundedRectangleBorder(borderRadius: BorderRadius.zero);

final theme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: base,
  colorScheme: const ColorScheme.light(
    primary: yellow,
    onPrimary: text,
    surface: base,
    onSurface: text,
    error: red,
    outline: surface0,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: yellow,
    foregroundColor: text,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  cardTheme: const CardThemeData(
    color: mantle,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
      side: BorderSide(color: surface0),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: square,
      backgroundColor: yellow,
      foregroundColor: text,
      minimumSize: const Size.fromHeight(48),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: surface0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: surface0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: yellow, width: 2),
    ),
    floatingLabelStyle: TextStyle(color: yellow),
  ),
  textSelectionTheme: const TextSelectionThemeData(cursorColor: yellow),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: text),
);

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Minimal app',
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: const HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.client});

  /// Injectable for tests; a real client is created when omitted.
  final http.Client? client;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _apiUrl = TextEditingController(text: 'http://10.0.2.2:8080');
  final _name = TextEditingController();
  late final http.Client _client = widget.client ?? http.Client();
  String? _message;
  String? _error;
  bool _loading = false;

  Future<void> _send() async {
    final base = _apiUrl.text.trim().replaceFirst(RegExp(r'/+$'), '');
    final uri = Uri.tryParse('$base/api/hello');
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      setState(() {
        _message = null;
        _error = 'Enter a valid API URL, e.g. http://10.0.2.2:8080';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await _client
          .get(uri.replace(queryParameters: {'name': _name.text}))
          .timeout(const Duration(seconds: 5));
      if (res.statusCode != 200) throw 'HTTP ${res.statusCode}';
      _message = jsonDecode(res.body)['message'] as String;
    } catch (e) {
      _message = null;
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _apiUrl.dispose();
    _name.dispose();
    if (widget.client == null) _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Rust + Flutter')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Talk to the backend', style: t.titleLarge),
                    const SizedBox(height: 16),
                    TextField(
                      key: const Key('apiUrlField'),
                      controller: _apiUrl,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'API URL',
                        hintText: 'http://10.0.2.2:8080',
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      key: const Key('nameField'),
                      controller: _name,
                      decoration: const InputDecoration(labelText: 'Your name'),
                      onSubmitted: (_) => _send(),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _loading ? null : _send,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Say hello'),
                    ),
                    if (_message != null || _error != null) ...[
                      const SizedBox(height: 24),
                      Text(
                        _message ?? 'Error: $_error',
                        textAlign: TextAlign.center,
                        style: t.titleMedium?.copyWith(
                          color: _error != null ? red : null,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
