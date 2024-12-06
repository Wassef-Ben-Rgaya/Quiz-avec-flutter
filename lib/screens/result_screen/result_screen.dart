import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/controllers/quiz_controller.dart';
import 'package:quiz_app/database/result.dart';
import 'package:quiz_app/database/resultas_db.dart';

import '../../constants.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);
  static const routeName = '/result_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: GetBuilder<QuizController>(
              init: Get.find<QuizController>(),
              builder: (controller) =>
                  QuizResultsWidget(controller: controller),
            ),
          ),
        ],
      ),
    );
  }
}

class QuizResultsWidget extends StatelessWidget {
  final QuizController controller;

  const QuizResultsWidget({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Align(
          // Aligner l'icône en haut à droite
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: () {
              Get.to(() => ResultTableScreen());
            },
            icon: Icon(Icons.table_chart),
            iconSize: 50,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 50),
        Text(
          'Félicitations !',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 30),
        Text(
          '${controller.name}',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: KPrimaryColor,
              ),
        ),
        const SizedBox(height: 50),
        Text(
          'Votre score est',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          '${controller.scoreResult.round()} / ${controller.countOfQuestion}',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: KPrimaryColor,
              ),
        ),
        const SizedBox(height: 50),
        Text(
          'Questions correctes : ${controller.countOfCorrectAnswers}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.green,
              ),
        ),
        SizedBox(height: 20),
        Text(
          'Questions incorrectes : ${controller.countOfIncorrectAnswers}',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.red,
              ),
        ),
        const SizedBox(height: 50),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () {
                      controller.startAgain();
                    },
                    label: Text('Recommencer'),
                    icon: Icon(Icons.repeat),
                    backgroundColor: KPrimaryColor,
                  ),
                  FloatingActionButton.extended(
                    onPressed: () async {
                      var result = await ResultatDB().insertData(
                        controller.name,
                        controller.scoreResult,
                      );

                      if (result != 0) {
                        _showSnackbar(
                          context,
                          'Résultats enregistrés avec succès',
                          Colors.green,
                        );
                      } else {
                        _showSnackbar(
                          context,
                          'Échec de l\'enregistrement des résultats',
                          Colors.red,
                        );
                      }
                      Get.back();
                    },
                    label: Text('Enregistrer'),
                    icon: Icon(Icons.save),
                    backgroundColor: KPrimaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSnackbar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
