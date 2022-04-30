import 'package:flutter/foundation.dart';

// alias of function to close dialog
typedef CLoseLoadingScreen = bool Function();

//alias of function to update loading screen
typedef UpdateLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CLoseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}
