import 'dart:convert';

class FilterItem {
  final String name;
  final dynamic value;
  FilterItem(this.name, this.value);
}

class MonthOpts {
  final int value;
  final String title;

  MonthOpts(this.value, this.title);
}

class Filtering {
  List<FilterItem> filters = [];

  void addFilter(String name, dynamic value) {
    if (value is int) {
      value = value.toString();
    }
    FilterItem filter = FilterItem(name, value);
    filters.add(filter);
  }

  void reset() {
    filters.clear();
  }

  String generateJson() {
    return jsonEncode(generateMap());
  }

  Map<String, dynamic> generateMap() {
    Map<String, dynamic> map = {};
    filters.forEach((filter) => map[filter.name] = filter.value);
    return map;
  }

  String generateQueryParams() {
    return Uri(queryParameters: generateMap()).query;
  }
}
