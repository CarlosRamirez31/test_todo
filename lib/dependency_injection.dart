import 'package:get_it/get_it.dart';
import 'package:test_todo/core/cubit/theme/theme_cubit.dart';
import 'package:test_todo/core/helpers/database_helper.dart';
import 'package:test_todo/domain/repositories/todo_repository.dart';
import 'package:test_todo/infrastructure/datasources/todo_datasource.dart';
import 'package:test_todo/infrastructure/repositories/todo_repository_impl.dart';
import 'package:test_todo/presentation/todo/cubits/get_todo/get_todo_cubit.dart';
import 'package:test_todo/presentation/todo/cubits/todo_form/todo_form_cubit.dart';
import 'package:test_todo/presentation/todo/cubits/todo_filter/todo_filter_cubit.dart';

final sl = GetIt.instance;

Future<void> serviceLocator() async {
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // Datasource
  sl.registerLazySingleton<TodoDatasource>(() => TodoDatasourceImpl(sl()));

  // Repository
  sl.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(sl()));

  //Cubits
  sl
    ..registerLazySingleton<TodoFilterCubit>(() => TodoFilterCubit())
    ..registerFactory<TodoFormCubit>(() => TodoFormCubit())
    ..registerFactory<GetTodoCubit>(() => GetTodoCubit(sl(), sl()));
}
