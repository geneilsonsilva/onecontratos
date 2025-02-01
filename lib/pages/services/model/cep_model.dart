class CepModel {
  final String cep;
  final String logradouro;
  final String bairro;
  final String localidade;
  final String estado;
  final String uf;

  CepModel({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.estado,
    required this.uf,
  });

  factory CepModel.fromJson(Map<String, dynamic> json) {
    return CepModel(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      estado: json['estado'] ??'',
      uf: json['uf'] ?? '',
    );
  }
}
