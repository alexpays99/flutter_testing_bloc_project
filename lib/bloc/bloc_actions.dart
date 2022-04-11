import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc_project/bloc/person.dart';

const persons1Url = 'http://10.0.2.2:5500/lib/api/persons1.json';
const persons2Url = 'http://10.0.2.2:5500/lib/api/persons2.json';

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonsLoader loader;
  const LoadPersonsAction({required this.url, required this.loader}) : super();
}
