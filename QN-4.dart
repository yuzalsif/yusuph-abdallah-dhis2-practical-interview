import 'dart:convert';

void main() {
  String jsonString = '''
 [
{
  "studentName": "John Doe",
  "studentId": "393494",
"courseResults": {
   "courseWork": [
     {
          "subject": "Pascal",
        "score": 34
          },
          {
            "subject": "C Programming",
            "score": 24
         }
        ],
        "ue": [
          {
            "subject": "Pascal",
            "score": 56
          },
        {
            "subject": "C Programming",
            "score": 40
          }
        ]
      }
    },
    {
      "studentName": "Jane Robert",
      "studentId": "439493",
      "courseResults": {
        "courseWork": [
          {
            "subject": "Pascal",
         "score": 28
         },
          {
            "subject": "C Programming",
            "score": 24
          }
        ],
        "ue": [
          {
            "subject": "Pascal",
            "score": 56
          },
          {
            "subject": "C Programming",
           "score": 50
          }
        ]
      }
    }
  ]
  ''';

  List<dynamic> students = jsonDecode(jsonString);
  List<Map<String, dynamic>> totalScores = [];

  for (var student in students) {
    double totalScore = 0;
    for (var course in student['courseResults']['courseWork']) {
      totalScore += course['score'];
    }
    for (var ue in student['courseResults']['ue']) {
      totalScore += ue['score'];
    }
    totalScores
        .add({'studentName': student['studentName'], 'totalScore': totalScore});
  }

  String resultJson = jsonEncode(totalScores);
  print("resultJson");
}
