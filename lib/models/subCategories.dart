class SubCategories {
  String id;
  String name;
  List<Options> options;

  SubCategories({this.id, this.name, this.options});
  factory SubCategories.fromMap(Map<dynamic, dynamic> data) {
    if (data.isEmpty) return null;

    return SubCategories(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      options: getOptions(data['options'] ?? {}) ?? {},
    );
  }
  static List<Options> getOptions(dynamic data) {
    List<Options> options = [];
    if (data != {}) {
      data.forEach((k, v) {
        Options opt = Options.fromMap(v);
        options.add(opt);
      });
    }
    return options;
  }
}

class Options {
  String id;
  bool isDropDown;
  bool isNumaric;
  String name;
  List<String> values;
  Options({this.id, this.isDropDown, this.name, this.values, this.isNumaric});
  factory Options.fromMap(Map<dynamic, dynamic> data) {
    if (data.isEmpty) return null;

    return Options(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      isDropDown: data['isDropdown'] ?? '',
      isNumaric: data['isNumaric'] ?? '',
      values: List.from(data['values'] ?? []) ?? [],
    );
  }
}
