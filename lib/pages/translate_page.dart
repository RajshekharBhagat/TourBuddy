import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class translate_page extends StatefulWidget {
  const translate_page({super.key});

  @override
  State<translate_page> createState() => _translate_pageState();
}

class _translate_pageState extends State<translate_page> {
  String translated = 'Translation';
  String selectedLanguage = 'en'; // Default language is English
  final translator = GoogleTranslator();

  List<Map<String, String>> languageOptions = [
    {'code': 'hi', 'name': 'हिन्दी'}, // Hindi
    {'code': 'en', 'name': 'English'}, // English
    {'code': 'mr', 'name': 'मराठी'}, // Marathi
    {'code': 'bn', 'name': 'বাংলা'}, // Bengali
    {'code': 'te', 'name': 'తెలుగు'}, // Telugu
    {'code': 'ta', 'name': 'தமிழ்'}, // Tamil
    {'code': 'ur', 'name': 'اردو'}, // Urdu
    {'code': 'gu', 'name': 'ગુજરાતી'}, // Gujarati
    {'code': 'kn', 'name': 'ಕನ್ನಡ'}, // Kannada
    {'code': 'or', 'name': 'ଓଡ଼ିଆ'}, // Odia
    {'code': 'pa', 'name': 'ਪੰਜਾਬੀ'}, // Punjabi
    {'code': 'ml', 'name': 'മലയാളം'}, // Malayalam
    {'code': 'as', 'name': 'অসমীয়া'}, // Assamese
  ];

  void translateText(String text) async {
    if (text.isEmpty) {
      setState(() {
        translated = ''; // Clear translation if no text entered
      });
      return; // No need to proceed with translation
    }
    final translation = await translator.translate(
      text,
      from: 'auto',
      to: selectedLanguage,
    );
    setState(() {
      translated = translation.text!;
    });
  }

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.blue[100],
    child: Column(
      children: [
        SizedBox(height: 50),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(10, 5),
                blurRadius: 30,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-10, -10),
                blurRadius: 30,
                spreadRadius: 1,
              ),
            ],
            color: Colors.blue[200],
          ),
          child: TextField(
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'Enter Text',
            ),
            onChanged: (text) {
              translateText(text);
            },
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(10, 5),
                blurRadius: 30,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-10, -10),
                blurRadius: 30,
                spreadRadius: 1,
              ),
            ],
            color: Colors.blue[200],
          ),
          child: DropdownButton<String>(
            value: selectedLanguage,
            items: languageOptions.map((option) {
              return DropdownMenuItem<String>(
                value: option['code']!,
                child: Text(option['name']!),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedLanguage = newValue!;
              });
              // Pass the currently entered text for translation
              translateText(translated); // Pass the translated text to ensure translation is updated
            },


          ),
        ),
        SizedBox(height: 20),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(10, 5),
                blurRadius: 30,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-10, -10),
                blurRadius: 30,
                spreadRadius: 1,
              ),
            ],
            color: Colors.blue[200],
          ),
          child: Text(
            translated == '' ? '' : translated,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        )
      ],
    ),
  );
}