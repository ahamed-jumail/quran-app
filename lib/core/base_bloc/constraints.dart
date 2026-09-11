class Constraints {
  Constraints({this.constraints});

  factory Constraints.fromMap(Map<String, dynamic> json) => Constraints(
    constraints: json['constraints'] == null
        ? <Item>[]
        : List<Item>.from(
            (json['constraints'] as List<dynamic>?)?.map(
                  (dynamic x) => Item.fromMap(x as Map<String, dynamic>),
                ) ??
                <Item>[],
          ),
  );

  static bool contains(Constraints? constraints, String path) {
    return constraints?.constraints?.any(
          (Item constrant) => constrant.path == path,
        ) ??
        false;
  }

  static String? getMessage(Constraints? constraints, String path) {
    return constraints?.constraints
        ?.where((Item constrant) => constrant.path == path)
        .firstOrNull
        ?.message;
  }

  final List<Item>? constraints;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'constraints': constraints == null
        ? <Item>[]
        : List<dynamic>.from(constraints!.map((Item x) => x.toMap())),
  };
}

class Item {
  Item({this.path, this.message});

  factory Item.fromMap(Map<String, dynamic> json) =>
      Item(path: json['path'] as String?, message: json['message'] as String?);
  final String? path;
  final String? message;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'path': path,
    'message': message,
  };
}
