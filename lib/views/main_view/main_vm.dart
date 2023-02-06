import 'package:flutter/cupertino.dart';
import 'package:text_to_graph/repositories/main_repo.dart';

class MainVM extends ChangeNotifier {
  final MainRepo mainRepo;

  MainVM({required this.mainRepo});
}
