import 'package:get_it/get_it.dart';
import 'package:test_todo/core/cubit/theme/theme_cubit.dart';
import 'package:test_todo/core/helpers/database_helper.dart';

final sl = GetIt.instance;

Future<void> serviceLocator() async {
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}
