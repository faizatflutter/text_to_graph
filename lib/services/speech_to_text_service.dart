import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

abstract class SpeechToTextService {
  SpeechToText getSpeechToTextInstance();

  Future<List<LocaleName>> getLocaleNames();

  Future<LocaleName?> getSystemLocale();

  Future<bool> initializeSpeechToText({
    required Function(SpeechRecognitionError)? errorListener,
    required Function(String) statusListener,
  });

  Future<void> startListening({
    required void Function(SpeechRecognitionResult)? resultListener,
    required dynamic Function(double)? onSoundLevelChange,
    required int? listenFor,
    required int? pauseFor,
    required String currentLocaleId,
  });

  Future<void> stopListening();

  Future<void> cancelListening();
}

class SpeechToTextServiceImp implements SpeechToTextService {
  late SpeechToText speechToText;

  @override
  SpeechToText getSpeechToTextInstance() => speechToText;

  @override
  Future<List<LocaleName>> getLocaleNames() async => await speechToText.locales();

  @override
  Future<LocaleName?> getSystemLocale() => speechToText.systemLocale();

  @override
  Future<bool> initializeSpeechToText({
    required Function(SpeechRecognitionError)? errorListener,
    required Function(String) statusListener,
  }) async {
    return await speechToText.initialize(onError: errorListener, onStatus: statusListener);
  }

  @override
  Future<void> startListening({
    required void Function(SpeechRecognitionResult)? resultListener,
    required dynamic Function(double)? onSoundLevelChange,
    required int? listenFor,
    required int? pauseFor,
    required String currentLocaleId,
  }) {
    return speechToText.listen(
      onResult: resultListener,
      listenFor: Duration(seconds: listenFor ?? 30),
      pauseFor: Duration(seconds: pauseFor ?? 3),
      onSoundLevelChange: onSoundLevelChange,
      partialResults: true,
      localeId: currentLocaleId,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
      onDevice: false,
    );
  }

  @override
  Future<void> stopListening() {
    return speechToText.stop();
  }

  @override
  Future<void> cancelListening() {
    return speechToText.cancel();
  }
}
