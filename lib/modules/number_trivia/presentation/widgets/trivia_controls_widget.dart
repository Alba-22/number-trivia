import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControlsWidget extends StatefulWidget {
  const TriviaControlsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<TriviaControlsWidget> createState() => _TriviaControlsWidgetState();
}

class _TriviaControlsWidgetState extends State<TriviaControlsWidget> {
  String inputString = "";
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Input a number",
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            inputString = value;
          },
          onSubmitted: (_) => requestConcrete(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => requestConcrete(),
                child: const Text("Search"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () => requestRandom(),
                child: Text(
                  "Random",
                  style: TextStyle(
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void requestConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumberEvent(inputString));
  }

  void requestRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumberEvent());
  }
}
