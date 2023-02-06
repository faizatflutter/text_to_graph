import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_to_graph/constants/app_constants.dart';
import 'package:text_to_graph/dependency_injection/dependency_injection.dart';
import 'package:text_to_graph/repositories/main_repo.dart';
import 'package:text_to_graph/routes/routes.dart';
import 'package:text_to_graph/services/navigation_service.dart';
import 'package:text_to_graph/views/main_view/main_view.dart';
import 'package:text_to_graph/views/main_view/main_vm.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<MainVM>(
        create: (_) => MainVM(mainRepo: locator<MainRepo>()),
      ),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final navigatorService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorService.rootNavKey,
      title: AppConstants.appName,
      onGenerateRoute: AppRoutes.generateRoute,
      theme: ThemeData(),
    );
  }
}
