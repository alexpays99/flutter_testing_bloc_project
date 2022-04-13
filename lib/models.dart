import 'package:flutter/foundation.dart' show immutable;

@immutable
class LoginHandle {
  final String token;

  const LoginHandle({required this.token});

  const LoginHandle.fooBar() : token = 'foobar';

  @override
  bool operator ==(covariant LoginHandle other) => token == other.token;

  @override
  int get hashCode => token.hashCode;

  @override
  String toString() => 'LoginHandle (token = $token)';
}

enum LoginErrors {
  invalidHandle,
}

@immutable
class Note {
  final String title;

  const Note({required this.title});
  // if you're login something into debug console you should se what it's clearly what this guy actually doing
  @override
  String toString() => 'Note (title = $title)';
}

final mockedNotes = Iterable.generate(3, (i) => Note(title: 'Note ${i + 1}'));
