import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:testing_bloc_project/auth/auth_error.dart';
import 'package:testing_bloc_project/bloc/app_event.dart';
import 'package:testing_bloc_project/bloc/app_state.dart';
import 'package:testing_bloc_project/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  // by deafut initial state of bloc is should be AppStateLoggedOut.
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    // handle registration screen event
    on<AppEventGoToRegistration>((event, emit) {
      emit(const AppStateIsInRegistrationView(isLoading: false));
    });

    // handle log in event
    on<AppEventLogIn>((event, emit) async {
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );
      // log the user in
      try {
        final email = event.email;
        final password = event.password;
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // get images for user
        final user = userCredential.user!;
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedOut(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    on<AppEventGoToLogIn>((event, emit) {
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    });

    on<AppEventRegister>((event, emit) async {
      emit(
        const AppStateIsInRegistrationView(
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;

      try {
        // create the user
        final credentials =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        //get user images
        emit(
          AppStateLoggedIn(
            user: credentials.user!,
            images: const [],
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInRegistrationView(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    // handle initial state. if current user null we see AppStateLoggedOut view, else we show user's uploaded images
    on<AppEventInitialize>((event, emit) async {
      //get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      } else {
        // go grab the user's uploaded images
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
            user: user,
            images: images,
            isLoading: false,
          ),
        );
      }
    });
    // handle user log out event
    on<AppEventLogOut>((event, emit) async {
      // start loading
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      ); // log the user out
      await FirebaseAuth.instance.signOut();
      //log the user out in the UI as well
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    });

    // handle acount deletion
    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      // log the user out if we don't have a current user
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
        return;
      }
      // start loading
      emit(
        AppStateLoggedIn(
          user: user,
          images: state.images ?? [],
          isLoading: true,
        ),
      );
      // delete the user folder
      try {
        // delete user folder
        final folderContents =
            await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final item in folderContents.items) {
          await item.delete().catchError((_) {});
        }
        // delete the folder itself
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {});
        //delete the user
        await user.delete();
        // log the user out
        await FirebaseAuth.instance.signOut();
        //log the user out in the UI as well
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      } on FirebaseException {
        // we might not be able to delete the folder
        // log the user out
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      }
    });

    // handle uploading images
    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;
      // log user out if we don't have an actual user in app state
      if (user == null) {
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
        return;
      }
      // start the loading process
      emit(
        AppStateLoggedIn(
          user: user,
          images: state.images ?? [],
          isLoading: true,
        ),
      );
      // upload the file
      final file = File(event.filePathToUpload);
      await uploadImage(file: file, userId: user.uid);
      // after upload is completed grab the latest file references
      final images = await _getImages(user.uid);
      // emit the new images and turn off loading
      emit(AppStateLoggedIn(user: user, images: images, isLoading: false));
    });
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
