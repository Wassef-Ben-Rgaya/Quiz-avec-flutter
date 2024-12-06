import 'package:flutter/material.dart';
import 'package:quiz_app/database/resultas_db.dart';

class ResultTableScreen extends StatefulWidget {
  @override
  _ResultTableScreenState createState() => _ResultTableScreenState();
}

class _ResultTableScreenState extends State<ResultTableScreen> {
  late List<Map<String, dynamic>> dataList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats du quiz'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ResultatDB().readData("SELECT * FROM Resultat"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          } else {
            dataList = snapshot.data ?? [];

            return DataTable(
              columnSpacing: 40,
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Nom')),
                DataColumn(label: Text('Score')),
                DataColumn(label: Text('Actions')),
              ],
              rows: dataList.map((data) {
                TextEditingController nameController =
                    TextEditingController(text: data['Nom']);
                TextEditingController scoreController =
                    TextEditingController(text: data['score'].toString());

                return DataRow(cells: [
                  DataCell(Center(child: Text(data['id'].toString()))),
                  DataCell(
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  DataCell(
                    TextField(
                      controller: scoreController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _saveChanges(
                            data['id'],
                            nameController.text,
                            double.parse(scoreController.text),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          int idToDelete = data['id'];
                          await ResultatDB().deleteData(idToDelete);
                          _refreshData();
                          print('Delete pressed for item ${data['id']}');
                        },
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            );
          }
        },
      ),
    );
  }

  void _saveChanges(int id, String name, double score) async {
    await ResultatDB().updateData(id, name, score);
    _refreshData();
    print('Changes saved for item $id');
  }

  void _refreshData() {
    setState(() {});
  }
}
