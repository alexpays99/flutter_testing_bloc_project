import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc_project/models.dart';

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchNotes;

  // initial state of app if all of properties is null and isLoading = false.
  // set initial app state as null doesn't make sence because if we have all of properties as null we automatically have state null.
  // therefore, we can create a constructor with all of properties as null and consider it as initial state.
  const AppState.empty()
      : isLoading = false,
        loginError = null,
        loginHandle = null,
        fetchNotes = null;

  const AppState({
    required this.isLoading,
    required this.loginError,
    required this.loginHandle,
    required this.fetchNotes,
  });

  // that's a nice way to make toString and show it as a map with a classes if it's a lot of properties in class
  @override
  String toString() => {
        'isLoading': isLoading,
        'loginError': loginError,
        'loginHandle': loginHandle,
        'fetchNotes': fetchNotes,
      }.toString();
}