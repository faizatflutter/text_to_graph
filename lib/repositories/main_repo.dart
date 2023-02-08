import 'package:dartz/dartz.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_graph/services/speech_to_text_service.dart';
import 'package:text_to_graph/utilities/failure.dart';

abstract class MainRepo {
  SpeechToText getSpeechToTextInstance();

  Future<List<LocaleName>> getLocaleNames();

  Future<LocaleName?> getSystemLocale();

  Future<Either<Failure, bool>> initializeSpeechToText({
    required Function(SpeechRecognitionError)? errorListener,
    required Function(String) statusListener,
  });

  Future<Either<Failure, void>> startListeningToSpeech({
    required void Function(SpeechRecognitionResult p1)? resultListener,
    required dynamic Function(double)? onSoundLevelChange,
    required int listenFor,
    required int pauseFor,
    required String currentLocaleId,
  });

  Future<Either<Failure, void>> stopListeningToSpeech();

  Either<Failure, void> cancelListeningToSpeech();
}

class MainRepoImp implements MainRepo {
  final SpeechToTextService speechToTextService;

  MainRepoImp({required this.speechToTextService});

  @override
  Future<List<LocaleName>> getLocaleNames() {
    return speechToTextService.getLocaleNames();
  }

  @override
  SpeechToText getSpeechToTextInstance() {
    return speechToTextService.getSpeechToTextInstance();
  }

  @override
  Future<LocaleName?> getSystemLocale() {
    return speechToTextService.getSystemLocale();
  }

  @override
  Future<Either<Failure, bool>> initializeSpeechToText({
    required Function(SpeechRecognitionError p1)? errorListener,
    required Function(String p1) statusListener,
  }) async {
    try {
      bool hasSpeech = await speechToTextService.initializeSpeechToText(errorListener: errorListener, statusListener: statusListener);
      if (hasSpeech) {
        return Right(hasSpeech);
      } else {
        return const Left(UnableToInitializeFailure("ERROR"));
      }
    } catch (e) {
      return Left(UnableToInitializeFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> startListeningToSpeech({
    required void Function(SpeechRecognitionResult p1)? resultListener,
    required dynamic Function(double)? onSoundLevelChange,
    required int listenFor,
    required int pauseFor,
    required String currentLocaleId,
  }) async {
    try {
      return Right(await speechToTextService.startListening(
        resultListener: resultListener,
        listenFor: listenFor,
        pauseFor: pauseFor,
        currentLocaleId: currentLocaleId,
        onSoundLevelChange: onSoundLevelChange,
      ));
    } catch (e) {
      return Left(UnableToListen(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopListeningToSpeech() async {
    try {
      return Right(await speechToTextService.stopListening());
    } catch (e) {
      return Left(UnableToListen(e.toString()));
    }
  }

  @override
  Either<Failure, void> cancelListeningToSpeech() {
    try {
      return Right(speechToTextService.cancelListening());
    } catch (e) {
      return Left(UnableToListen(e.toString()));
    }
  }
}
