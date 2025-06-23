class EngineCertificateHashesModel {
  const EngineCertificateHashesModel({
    required this.base64,
    required this.hex,
  });

  final String base64;
  final String hex;

  @override
  String toString() =>
      'EngineCertificateHashesModel('
      'base64: $base64, '
      'hex: $hex)';
}
