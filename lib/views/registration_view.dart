import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:testing_bloc_project/bloc/app_bloc.dart';
import 'package:testing_bloc_project/bloc/app_event.dart';
import 'package:testing_bloc_project/extensions/if_debbuging.dart';

class RegistervieW extends HookWidget {
  const RegistervieW({Key? key}) : super(key: key);
  // final emailController =
  //     useTextEditingController(text: 'potus@gmail.com'.ifDebugging);
  // final passwordController =
  //     useTextEditingController(text: 'foobarbaz'.ifDebugging);

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: 'potus@gmail.com'.ifDebugging);
    final passwordController =
        useTextEditingController(text: 'foobarbaz'.ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Regiser',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email here...',
              ),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter your password here...',
              ),
              keyboardAppearance: Brightness.dark,
              obscureText: true,
              obscuringCharacter: '*',
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                context.read<AppBloc>().add(
                      AppEventRegister(
                        email: email,
                        password: password,
                      ),
                    );
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(
                      const AppEventGoToLogIn(),
                    );
              },
              child: const Text('Already registered? Log in here!'),
            ),
          ],
        ),
      ),
    );
  }
}
