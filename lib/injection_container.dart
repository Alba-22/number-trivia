import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/core/utils/input_converter.dart';
import 'package:number_trivia/modules/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:number_trivia/modules/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:number_trivia/modules/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/modules/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/modules/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:number_trivia/modules/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:number_trivia/modules/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final sl = GetIt.I;

Future<void> init() async {
  //! Modules - Number Trivia
  // Bloc
  sl.registerFactory(() => NumberTriviaBloc(sl.get(), sl.get(), sl.get()));

  // Usecases
  sl.registerLazySingleton(() => GetConcreteNumberTriviaUsecase(sl.get()));
  sl.registerLazySingleton(() => GetRandomNumberTriviaUsecase(sl.get()));

  // Repositories
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDatasource: sl.get(),
      localDatasource: sl.get(),
      networkInfo: sl.get(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<NumberTriviaRemoteDatasource>(() => NumberTriviaRemoteDatasourceImpl(sl.get()));
  sl.registerLazySingleton<NumberTriviaLocalDatasource>(() => NumberTriviaLocalDatasourceImpl(sl.get()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl.get()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
