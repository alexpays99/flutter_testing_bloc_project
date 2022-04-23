import 'package:testing_bloc_project/bloc/app_bloc.dart';

class TopBloc extends AppBloc {
  Duration? waitBeforeLoading;
  TopBloc({
    required Iterable<String> urls,
    required this.waitBeforeLoading,
  }) : super(
          waitBeforeLoading: waitBeforeLoading,
          urls: urls,
        );
}
