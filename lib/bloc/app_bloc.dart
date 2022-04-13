import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_project/apis/login_api.dart';
import 'package:testing_bloc_project/apis/notes_api.dart';
import 'package:testing_bloc_project/bloc/actions.dart';
import 'package:testing_bloc_project/bloc/app_state.dart';
import 'package:testing_bloc_project/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  // we'll not bound concrete implementations of apis, we should bring here an interface of LoginApiProtocol and NotesApiProtocol
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>((event, emit) async {
      // start loading
      emit(
        const AppState(
          isLoading: true,
          loginError: null,
          loginHandle: null,
          fetchNotes: null,
        ),
      );
      // log the user in
      final loginHandle = await loginApi.login(
        email: event.email,
        password: event.password,
      );
      emit(
        AppState(
          isLoading: false,
          loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
          loginHandle: loginHandle,
          fetchNotes: null,
        ),
      );
    });
    on<LoadNotesAction>((event, emit) async {
      // start loading
      emit(
        AppState(
          isLoading: true,
          loginError: null,
          loginHandle: state.loginHandle, // it's state that any bloc holds on.
          fetchNotes: null,
        ),
      );

      // get the login handle
      final loginHandle = state.loginHandle;
      if (loginHandle != const LoginHandle.fooBar()) {
        emit(
          AppState(
            isLoading: false,
            loginError: LoginErrors.invalidHandle,
            loginHandle: loginHandle, // it's state that any bloc holds on
            fetchNotes: null,
          ),
        );
        return;
      }

      // we have a valid login handle and want to fetch notes
      final notes = await notesApi.getNotes(loginHandle: loginHandle!);
      emit(
        AppState(
          isLoading: false,
          loginError: state.loginError,
          loginHandle: loginHandle, // it's state that any bloc holds on
          fetchNotes: notes,
        ),
      );
    });
  }
}
