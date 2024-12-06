import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';
import 'package:quiz_app/widgets/progress_timer.dart';
import 'package:quiz_app/widgets/question_card.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);
  static const routeName = '/quiz_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: const BoxDecoration(color: Color(0xDDFCFBFB)),
          ),
          SafeArea(
            child: GetBuilder<QuizController>(
              init: QuizController(),
              builder: (controller) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Question ',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(color: Color(0xFF000000)),
                            children: [
                              TextSpan(
                                text: controller.numberOfQuestion
                                    .round()
                                    .toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: Color(0xFF000000)),
                              ),
                              TextSpan(
                                text: '/',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: Color(0xFF000000)),
                              ),
                              TextSpan(
                                text: controller.countOfQuestion.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(color: Color(0xFF000000)),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/images/ssf.png',
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                        Spacer(),
                        ProgressTimer(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: SizedBox(
                      height: 550,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => QuestionCard(
                          questionModel: controller.questionsList[index],
                        ),
                        controller: controller.pageController,
                        itemCount: controller.questionsList.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: GetBuilder<QuizController>(
        init: QuizController(),
        builder: (controller) => Row(
          children: [
            Spacer(),
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Abandonner le quiz ?'),
                      content:
                          Text('Êtes-vous sûr de vouloir abandonner le quiz ?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Fermer le dialogue
                            Navigator.of(context).pop();
                          },
                          child: Text('Non'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Naviguer vers la page d'accueil
                            controller.startAgain();
                          },
                          child: Text('Oui'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.home),
            ),
            Spacer(),
            FloatingActionButton(
                onPressed: () => controller.previousPage(),
                child: Icon(Icons.arrow_back),
                backgroundColor: const Color.fromARGB(255, 28, 153, 255)),
            Spacer(),
            FloatingActionButton.extended(
              onPressed: () => controller.submitAnswers(),
              icon: Icon(Icons.check),
              label: Text(
                "soumettre",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              backgroundColor: KPrimaryColor,
            ),
            Spacer(),
            FloatingActionButton(
                onPressed: () => controller.nextQuestion(),
                child: Icon(Icons.arrow_forward),
                backgroundColor: const Color.fromARGB(255, 28, 153, 255)),
          ],
        ),
      ),
    );
  }
}
