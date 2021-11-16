import 'package:flutter/material.dart';

import '../../domain/entities/number_trivia_entity.dart';

class TriviaDisplayWidget extends StatelessWidget {
  final NumberTriviaEntity trivia;

  const TriviaDisplayWidget({
    Key? key,
    required this.trivia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Text(
            trivia.number.toString(),
            style: const TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  trivia.text,
                  style: const TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
