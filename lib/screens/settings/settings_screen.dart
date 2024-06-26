import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zad/shared/localization/localizations.dart';
import 'package:zad/shared/presentation/navigator_pop.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Screen',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 16.0;
  Color _fontColor = Colors.black;
  Color _backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _saveFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', _fontSize);
  }

  Future<void> _saveColor(String key, Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, color.value);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('fontSize') ?? _fontSize;
      _fontColor = Color(prefs.getInt('fontColor') ?? _fontColor.value);
      _backgroundColor =
          Color(prefs.getInt('backgroundColor') ?? _backgroundColor.value);
    });
  }

  showColorPickerDialog(
    Color color,
    ValueChanged<Color> onColorChanged,
  ) {
    showDialog(
      builder: (context) => AlertDialog(
        title: Text(
          localizations.pick_color,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color,
            onColorChanged: onColorChanged,
            colorPickerWidth: 300,
            pickerAreaHeightPercent: 0.7,
            enableAlpha: true,
            displayThumbColor: true,
            showLabel: true,
            paletteType: PaletteType.hsl,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              localizations.done,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              setState(() {});
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(localizations.settings),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: _backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          localizations.basmalah,
                          style: TextStyle(
                            fontSize: _fontSize,
                            color: _fontColor,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  const Image(
                    image: AssetImage('assets/images/ic_size.png'),
                    height: 25,
                    width: 25,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    localizations.change_font_size_description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Slider(
                value: _fontSize,
                min: 10.0,
                max: 30.0,
                divisions: 30,
                label: _fontSize.toStringAsFixed(0),
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                  });
                  Future.delayed(
                      const Duration(milliseconds: 500), _saveFontSize);
                },
              ),
              const SizedBox(height: 5.0),
              Divider(
                color: Colors.grey.withOpacity(0.5),
                thickness: 1.0,
              ),
              const SizedBox(height: 16.0),
              _colorPickerView(
                localizations.change_font_color_description,
                _fontColor,
                (newColor) {
                  setState(() => _fontColor = newColor);
                  _saveColor('fontColor', newColor);
                },
              ),
              const SizedBox(height: 25.0),
              Divider(
                color: Colors.grey.withOpacity(0.5),
                thickness: 1.0,
              ),
              const SizedBox(height: 25.0),
              _colorPickerView(
                localizations.background_color,
                _backgroundColor,
                (newColor) {
                  setState(() => _backgroundColor = newColor);
                  _saveColor('backgroundColor', newColor);
                },
              ),
            ],
          ),
        ));
  }

  // DRY
  // Don't Repeat Yourself
  Widget _colorPickerView(
    String title,
    Color color,
    ValueChanged<Color> onColorChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Image(
              image: AssetImage('assets/images/ic_color.png'),
              height: 25,
              width: 25,
              fit: BoxFit.fill,
            ),
            const SizedBox(width: 10.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        GestureDetector(
          onTap: () {
            showColorPickerDialog(color, onColorChanged);
          },
          child: SizedBox(
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
