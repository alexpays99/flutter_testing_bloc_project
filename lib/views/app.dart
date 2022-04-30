import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testing_bloc_project/bloc/app_bloc.dart';
import 'package:testing_bloc_project/bloc/app_event.dart';
import 'package:testing_bloc_project/bloc/app_state.dart';
import 'package:testing_bloc_project/dialogs/show_auth_error.dart';
import 'package:testing_bloc_project/loading/loading_screen.dart';
import 'package:testing_bloc_project/views/login_view.dart';
import 'package:testing_bloc_project/views/photo_gallery_view.dart';
import 'package:testing_bloc_project/views/registration_view.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        title: 'Photo Library',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingSCreen.instance().show(
                context: context,
                text: 'Loading...',
              );
            } else {
              LoadingSCreen.instance().hide();
            }
            final authError = appState.authError;
            if (authError != null) {
              showAuthError(authError: authError, context: context);
            }
          },
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginvieW();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateIsInRegistrationView) {
              return const RegistervieW();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
