import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  bool _isAvailable = false;

  bool get isListening => _isListening;
  bool get isAvailable => _isAvailable;

  Future<bool> initialize() async {
    try {
      final permission = await Permission.microphone.status;
      if (permission.isDenied) {
        final result = await Permission.microphone.request();
        if (!result.isGranted) {
          return false;
        }
      }

      _isAvailable = await _speech.initialize(
        onError: (error) => print('Speech error: $error'),
        onStatus: (status) => print('Speech status: $status'),
      );

      return _isAvailable;
    } catch (e) {
      print('Speech initialization error: $e');
      return false;
    }
  }

  Future<void> startListening({
    required Function(String) onResult,
    required Function() onStartListening,
    required Function() onStopListening,
  }) async {
    if (!_isAvailable) return;

    _isListening = true;
    onStartListening();

    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
          _isListening = false;
          onStopListening();
        }
      },
      listenFor: const Duration(seconds: 30), // Maksimum dinleme süresi
      pauseFor: const Duration(seconds: 5), // 5 saniye duraksamada bile kapatma
      partialResults: false,
      localeId: 'tr_TR',
    );
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speech.stop();
      _isListening = false;
    }
  }

  void dispose() {
    _speech.cancel();
  }
}
