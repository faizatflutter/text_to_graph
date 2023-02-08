import 'package:get_it/get_it.dart';
import 'package:text_to_graph/repositories/main_repo.dart';
import 'package:text_to_graph/services/logger_service.dart';
import 'package:text_to_graph/services/navigation_service.dart';
import 'package:text_to_graph/services/speech_to_text_service.dart';
import 'package:text_to_graph/views/main_view/main_vm.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  //Registering Services
  locator.registerLazySingleton(() => NavigationService());

  locator.registerLazySingleton<SpeechToTextService>(() => SpeechToTextServiceImp());
  locator.registerLazySingleton<LoggerService>(() => LoggerServiceImp());

  //Registering Repositories
  locator.registerLazySingleton<MainRepo>(() => MainRepoImp(speechToTextService: locator()));

  //Registering ViewModels
  locator.registerLazySingleton(() => MainVM(mainRepo: locator()));
}
