/// Modelo de dados do usuário do aplicativo.
class Usuario {
  final String nome;
  final String email;
  final String conta;
  final String avatar;
  final String? telefone;
  final String? cpf;

  const Usuario({
    required this.nome,
    required this.email,
    required this.conta,
    required this.avatar,
    this.telefone,
    this.cpf,
  });

  /// Cria uma cópia do usuário com os campos alterados.
  Usuario copyWith({
    String? nome,
    String? email,
    String? conta,
    String? avatar,
    String? telefone,
    String? cpf,
  }) {
    return Usuario(
      nome: nome ?? this.nome,
      email: email ?? this.email,
      conta: conta ?? this.conta,
      avatar: avatar ?? this.avatar,
      telefone: telefone ?? this.telefone,
      cpf: cpf ?? this.cpf,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'conta': conta,
      'avatar': avatar,
      'telefone': telefone,
      'cpf': cpf,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      nome: map['nome'] as String,
      email: map['email'] as String,
      conta: map['conta'] as String,
      avatar: map['avatar'] as String,
      telefone: map['telefone'] as String?,
      cpf: map['cpf'] as String?,
    );
  }
}
