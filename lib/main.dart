import 'dart:async';
import 'dart:developer';

void main() async {
  Bloc.observer = AppBlocObserver();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  runZonedGuarded(
        () => runApp(
        App(
          authenticationRepository: AuthenticationRepository(),
          userRepository: UserRepository(),
        )
    ),
        (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}