/// Modelo de dados do usuário do aplicativo.
class Usuario {
  final String avatar;
  final String nome;
  final String email;
  //final String conta;
  final String? cpf;
  final String? telefone;
  final String? cep;
  final String? endereco;

  const Usuario({
    required this.avatar,
    required this.nome,
    required this.email,
    //required this.conta,
    this.cpf,
    required this.telefone,
    this.cep,
    this.endereco,
  });

  /// Cria uma cópia do usuário com os campos alterados.
  Usuario copyWith({
    String? avatar,
    String? nome,
    String? email,
    //String? conta,
    String? cpf,
    String? telefone,
    String? cep,
    String? endereco,
  }) {
    return Usuario(
      avatar: avatar ?? this.avatar,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      //conta: conta ?? this.conta,
      cpf: cpf ?? this.cpf,
      telefone: telefone ?? this.telefone,
      cep: cep ?? this.cep,
      endereco: endereco ?? this.endereco,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'avatar': avatar,
      'nome': nome,
      'email': email,
      //'conta': conta,
      'cpf': cpf,
      'telefone': telefone,
      'cep': cep,
      'endereco': endereco,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      avatar: map['avatar'] as String,
      nome: map['nome'] as String,
      email: map['email'] as String,
      //conta: map['conta'] as String,
      cpf: map['cpf'] as String?,
      telefone: map['telefone'] as String?,
      cep: map['cep'] as String?,
      endereco: map['endereco'] as String?,
    );
  }
}
