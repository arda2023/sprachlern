import 'package:flutter_tts/flutter_tts.dart';

abstract interface class WordListSpeech {
  Future<void> speak(String text);
}

class FlutterTtsWordListSpeech implements WordListSpeech {
  FlutterTtsWordListSpeech() {
    _languageReady = _tts.setLanguage('en-US').then((_) {});
  }

  final FlutterTts _tts = FlutterTts();
  late final Future<void> _languageReady;

  @override
  Future<void> speak(String text) async {
    await _languageReady;
    await _tts.speak(text);
  }
}
