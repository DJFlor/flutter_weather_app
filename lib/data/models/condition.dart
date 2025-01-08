class Condition {
  final String? text;
  final String? iconURL;
  final int code;

  const Condition({
    this.text,
    this.iconURL,
    required this.code,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'],
      iconURL: json['icon'],
      code: json['code'],
    );
  }
}
