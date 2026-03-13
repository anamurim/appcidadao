/// Modelo de dados do usuário do aplicativo.
class Usuario {
  final String nome;
  final String email;
  final String conta;
  final String avatar;
  final String? telefone;
  final String? cpf;
  final String? cep;
<<<<<<< HEAD
  final String? endereco;
=======
  final String? endereco; // Novo campo
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f

  const Usuario({
    required this.nome,
    required this.email,
    required this.conta,
    required this.avatar,
    this.telefone,
    this.cpf,
    this.cep,
<<<<<<< HEAD
    this.endereco,
=======
    this.endereco, // Novo campo
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
  });

  /// Cria uma cópia do usuário com os campos alterados.
  Usuario copyWith({
    String? nome,
    String? email,
    String? conta,
    String? avatar,
    String? telefone,
    String? cpf,
    String? cep,
<<<<<<< HEAD
    String? endereco,
=======
    String? endereco, // Novo campo
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
  }) {
    return Usuario(
      nome: nome ?? this.nome,
      email: email ?? this.email,
      conta: conta ?? this.conta,
      avatar: avatar ?? this.avatar,
      telefone: telefone ?? this.telefone,
      cpf: cpf ?? this.cpf,
      cep: cep ?? this.cep,
<<<<<<< HEAD
      endereco: endereco ?? this.endereco,
=======
      endereco: endereco ?? this.endereco, // Novo campo
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
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
      'cep': cep,
<<<<<<< HEAD
      'endereco': endereco,
=======
      'endereco': endereco, // Novo campo
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
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
      cep: map['cep'] as String?,
<<<<<<< HEAD
      endereco: map['endereco'] as String?,
=======
      endereco: map['endereco'] as String?, // Novo campo
>>>>>>> 23606f392c94415bb105836d348e665346fbd86f
    );
  }
}
