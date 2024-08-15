import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yusuph_abdallah_dhis2_practical_interview/models/data_element.dart';

import '../services/data_elements_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Map<String, TextEditingController> inputControllers = {};
  final Map<String, double> dataPercentages = {};


  @override
  void dispose() {
    inputControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('DHIS2 Practical Interview'),
        ),
        body: FutureBuilder<List<Dhis2DataElement>>(
          future: DataElementsService.fetchDataElements(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              List<Dhis2DataElement> data = snapshot.data!;
              for (var item in data) {
                inputControllers[item.dataElementName] =
                    TextEditingController();
                dataPercentages[item.dataElementName] = 0.0;
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Color(0xFFE5EEFF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: const Text(
                          "Note: Scroll the table horizontally\nto view all data elements. 'Value' fields are\ninputs field that you can enter data and\nthe percentage will be calculated\nautomatically",
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        color: const Color(0xFFE5EEFF).withOpacity(0.4),
                        child: DataTable(
                          showBottomBorder: true,
                          border: TableBorder.all(color: Colors.black),
                          columns: const [
                            DataColumn(label: Text('Data Element Name')),
                            DataColumn(label: Text('Value')),
                            DataColumn(
                                label:
                                    Text('Percentage = \n(Value / 40) * 100')),
                          ],
                          rows: data.map((item) {
                            String name = item.dataElementName;
                            return DataRow(cells: [
                              DataCell(Text(name)),
                              DataCell(
                                TextField(
                                  controller: inputControllers[name],
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) =>
                                      _updatePercentage(name, value),
                                ),
                              ),
                              DataCell(Text(
                                  '${dataPercentages[name]?.toStringAsFixed(2)}%')),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }

  void _updatePercentage(String name, String value) {
    setState(() {
      double val = double.tryParse(value) ?? 0.0;
      dataPercentages[name] = (val / 40) * 100;
    });
  }
}
