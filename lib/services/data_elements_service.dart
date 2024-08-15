import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yusuph_abdallah_dhis2_practical_interview/models/data_element.dart';

class DataaElementsService {

  Future<List<DataElement>> fetchDataElements() async {
    var headersList = {
      'Accept': '*/*',
      'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      'Authorization': 'Basic ZGV2ZWxvcGVyOkRldmVsb3BlckAxMjM='
    };
    var url = Uri.parse('https://training.dhis2.udsm.ac.tz/api/dataElements.json?fields=id%2Cname%2CformName%2CvalueType%2CdomainType&filter=domainType%3Aeq%3AAGGREGATE');

    var req = http.Request('GET', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final List<DataElement> dataElements = [];
      print(resBody);
      final results = jsonDecode(resBody);
      for (var dataElement in results["dataElements"]) {
        dataElements.add(DataElement(
          id: dataElement['id'],
          dataElementName: dataElement['name'],
        ));
      }
      return dataElements;
    }
    else {
      print(res.reasonPhrase);
      throw Exception('Failed to load data elements');
    }
  }
}