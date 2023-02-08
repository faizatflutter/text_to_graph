import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:text_to_graph/repositories/main_repo.dart';

class MainVM extends ChangeNotifier {
  final MainRepo mainRepo;

  String currentLocaleId = "";

  int pauseFor = 3;
  int listenFor = 30;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;

  double currentSoundLevel = 0.0;

  String resultWords = "";

  String resultError = "";

  String resultStatus = "";

  bool isSpeechInitialized = false;
  bool isListening = false;

  List<LocaleName> localeNames = [];

  MainVM({required this.mainRepo});

  Future initializeSpeechToText() async {
    var initStatuesEither = await mainRepo.initializeSpeechToText(errorListener: errorListener, statusListener: statusListener);
    if (initStatuesEither.isLeft()) {
      print("Not initialized()");
      return;
    }
    isSpeechInitialized = initStatuesEither.fold((l) => false, (r) => true);
    localeNames = await mainRepo.getLocaleNames();
    var systemLocale = await mainRepo.getSystemLocale();
    currentLocaleId = systemLocale?.localeId ?? '';
    notifyListeners();
  }

  Future startListening() async {
    await mainRepo.startListeningToSpeech(
      resultListener: resultListener,
      listenFor: listenFor,
      pauseFor: pauseFor,
      currentLocaleId: currentLocaleId,
      onSoundLevelChange: soundLevelListener,
    );
  }

  void stopListening() {
    mainRepo.stopListeningToSpeech();
  }

  void cancelListening() {
    mainRepo.cancelListeningToSpeech();
  }

  /// This callback is invoked each time new recognition results are
  /// available after `listen` is called.
  void resultListener(SpeechRecognitionResult result) {
    resultWords = result.recognizedWords;
    notifyListeners();
  }

  void errorListener(SpeechRecognitionError error) {
    resultError = '${error.errorMsg} - ${error.permanent}';
    notifyListeners();
  }

  void statusListener(String status) {
    resultStatus = status;
    if (status == 'listening') {
      isListening = true;
    }
    notifyListeners();
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    currentSoundLevel = level;
    notifyListeners();
  }

  void switchLanguage(selectedVal) {
    currentLocaleId = selectedVal;
    notifyListeners();
  }

  void resetMainVM() {
    resultStatus = "";
    resultError = "";
    resultWords = "";
    currentLocaleId = "";

    notifyListeners();
  }
}
