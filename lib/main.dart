import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/config/router/app_route.dart';
import 'core/config/theme/app_theme.dart';
import 'dependency_injection.dart';
import 'core/cubit/theme/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await serviceLocator();

  await initializeDateFormatting('es', null);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => GetIt.I<ThemeCubit>())],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return MaterialApp.router(
            routerConfig: AppRoute.router,
            title: 'Todo App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          );
        },
      ),
    );
  }
}
