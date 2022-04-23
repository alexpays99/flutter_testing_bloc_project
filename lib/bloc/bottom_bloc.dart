import 'package:testing_bloc_project/bloc/app_bloc.dart';

class BottomBloc extends AppBloc {
  Duration? waitBeforeLoading;
  BottomBloc({
    required Iterable<String> urls,
    required this.waitBeforeLoading,
  }) : super(
          waitBeforeLoading: waitBeforeLoading,
          urls: urls,
        );
}
