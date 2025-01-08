final String superSecretAPIKey = "16309e007f0f40a5a80123044221507";

class Prediction {
  final String locId;

  const Prediction({
    required this.locId,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      locId: json['zip or whatever'],
    );
  }
}
