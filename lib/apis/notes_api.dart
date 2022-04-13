import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc_project/models.dart';

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();

  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle});
}

@immutable
class NotesApi extends NotesApiProtocol {
  const NotesApi();

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => loginHandle == const LoginHandle.fooBar() ? mockedNotes : null,
      );
}
