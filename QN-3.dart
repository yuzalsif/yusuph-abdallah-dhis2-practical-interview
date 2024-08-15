void main() {
  var hierarchy = {
    "id": "UDSMDHIS2LB",
    "name": "UDSM DHIS2 Lab",
    "parent": {
      "id": "CSE12345678",
      "name": "CSE",
      "parent": {
        "id": "CoICT78767",
        "name": "CoICT",
        "parent": {"id": "UDSM1234567", "name": "UDSM"}
      }
    }
  };

  String buildHierarchyString(Map<String, dynamic> node) {
    if (node.containsKey('parent')) {
      return '${node["name"]}/${buildHierarchyString(node["parent"])}';
    } else {
      return node["name"];
    }
  }

  String hierarchyString = buildHierarchyString(hierarchy);
  print(hierarchyString);
}
