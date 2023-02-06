import 'package:dartz/dartz.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_graph/utilities/failure.dart';

abstract class SpeechToTextService {
  Future<Either<Failure, bool>> initializeSpeechToText({
    required Function(SpeechRecognitionError)? errorListener,
    required Function(String) statusListener,
  });

  SpeechToText getSpeechToTextInstance();

  Future<List<LocaleName>> getLocaleNames();

  Future<LocaleName?> getSystemLocale();
}

class SpeechToTextServiceImp implements SpeechToTextService {
  late SpeechToText speechToText;

  @override
  Future<Either<Failure, bool>> initializeSpeechToText({
    required Function(SpeechRecognitionError)? errorListener,
    required Function(String) statusListener,
  }) async {
    try {
      var hasSpeech = await speechToText.initialize(
        onError: errorListener,
        onStatus: statusListener,
      );
      return Right(hasSpeech);
    } catch (e) {
      return Left(UnableToInitializeFailure(e.toString()));
    }
  }

  @override
  SpeechToText getSpeechToTextInstance() => speechToText;

  @override
  Future<List<LocaleName>> getLocaleNames() async => await speechToText.locales();

  @override
  Future<LocaleName?> getSystemLocale() => speechToText.systemLocale();
}
