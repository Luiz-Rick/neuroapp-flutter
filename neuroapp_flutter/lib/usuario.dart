enum PerfilTipo { usuario, cuidador }

class Usuario {
  final int id;
  final String nome;
  final String email;
  final PerfilTipo perfil;
  final bool ativo;
  final String criadoEm;
  final int? cuidadorId;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.perfil,
    required this.ativo,
    required this.criadoEm,
    this.cuidadorId,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      perfil: json['perfil'] == 'cuidador'
          ? PerfilTipo.cuidador
          : PerfilTipo.usuario,
      ativo: json['ativo'] as bool,
      criadoEm: json['criado_em'] as String,
      cuidadorId: json['cuidador_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'perfil': perfil.name,
        'ativo': ativo,
        'criado_em': criadoEm,
        'cuidador_id': cuidadorId,
      };

  bool get isCuidador => perfil == PerfilTipo.cuidador;
  bool get isUsuario => perfil == PerfilTipo.usuario;
}
