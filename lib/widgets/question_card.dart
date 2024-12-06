import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';

import 'answer_option.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel questionModel;

  const QuestionCard({
    Key? key,
    required this.questionModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                questionModel.question,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 15),
              ...List.generate(
                questionModel.options.length,
                (index) => Column(
                  children: [
                    AnswerOption(
                      questionId: questionModel.id,
                      text: questionModel.options[index],
                      index: index,
                      onPressed: () => Get.find<QuizController>()
                          .checkAnswer(questionModel, index),
                    ),
                    if (index != questionModel.options.length - 1)
                      const SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
