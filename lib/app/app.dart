import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:whiteproject/app/auth/bloc/authentication_bloc.dart';
import 'package:whiteproject/app/auth/view/login_page.dart';
import 'package:whiteproject/app/home/view/home_page.dart';
import '../../../../_Flutter_Projects/base_flutter_project/lib/navigation_service.dart';
import 'package:whiteproject/app/splash/view/splash_page.dart';
import 'package:whiteproject/datakit/repository/user/authentication_repository.dart';
import 'package:whiteproject/datakit/repository/user/user_repository.dart';
import 'package:whiteproject/locator.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
    required this.userRepository,
  }) : super(key: key);
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {

    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        )..add(AppLoaded()),
        child: AppView(
          key: key,
        ),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  Preference<bool>? logoutListener = null;
  AuthenticationRepository authenticationRepository = AuthenticationRepository();

  @override
  void initState() {
    super.initState();
    setupLocator();
    BlocProvider.of<AuthenticationBloc>(context).add(RefreshUserToken());
    _initPreferenceListener();
  }

  @override
  void dispose() {
    logoutListener = null;
    super.dispose();
  }

  void _initPreferenceListener() async {
    final preferences = await StreamingSharedPreferences.instance;
    logoutListener = preferences.getBool('LOGOUT', defaultValue: false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: locator<NavigationService>().navigatorKey,
      theme: ThemeData(
        textTheme:
        GoogleFonts.montserratTextTheme(Theme.of(context).textTheme),
      ),
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) async {
            if (state is AuthenticationAuthenticated) {
              await authenticationRepository.getUserData();
              locator<NavigationService>().pushAndRemoveUntil(HomePage.route());
            } else if (state is AuthenticationNotAuthenticated) {
              locator<NavigationService>()
                  .pushAndRemoveUntil(LoginPage.route());
            } else if (state is AuthenticationRefreshed) {
              locator<NavigationService>().pushAndRemoveUntil(HomePage.route());
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
