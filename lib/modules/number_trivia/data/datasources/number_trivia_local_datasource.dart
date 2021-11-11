import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:number_trivia/core/error/exceptions.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  /// Gets the cached [NumberTriviaModel] which has gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const cachedNumberTriviaKey = "CACHED_NUMBER_TRIVIA";

class NumberTriviaLocalDatasourceImpl implements NumberTriviaLocalDatasource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDatasourceImpl(this.sharedPreferences);

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final jsonString = sharedPreferences.getString(cachedNumberTriviaKey);
    if (jsonString != null) {
      return NumberTriviaModel.fromMap(jsonDecode(jsonString));
    }
    throw CacheException();
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    await sharedPreferences.setString(cachedNumberTriviaKey, jsonEncode(triviaToCache.toMap()));
  }
}
