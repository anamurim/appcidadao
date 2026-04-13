// 🧪 EXEMPLOS DE TESTE DO FIRESTORE
// 
// Use o serviço FirestoreDebugServico para verificar dados
// Todos os resultados são exibidos no Debug Console
//
// Para abrir o Debug Console no VS Code:
// Ctrl + Alt + D (ou Menu: View > Debug Console)


// ═══════════════════════════════════════════════════════════════════
// OPÇÃO 1: Chamar do debug console (flutter run)
// ═══════════════════════════════════════════════════════════════════
// 
// No terminal após `flutter run`:
// > FirestoreDebugServico.verificarReportes()
// > FirestoreDebugServico.verificarUsuarioAtual()
// > FirestoreDebugServico.verificarEstatisticas()
// 

// ═══════════════════════════════════════════════════════════════════
// OPÇÃO 2: Adicionar widget de teste na UI (temporário)
// ═══════════════════════════════════════════════════════════════════
//
// Edite a tela onde quer testar e adicione um FloatingActionButton:
//
// import 'package:appcidadao/core/debug/firestore_debug_widget.dart';
//
// class MinhaTelaWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Minha Tela')),
//       body: ...,
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//             context: context,
//             builder: (_) => FirestoreDebugWidget(),
//           );
//         },
//         tooltip: 'Debug Firestore',
//         child: Icon(Icons.bug_report),
//       ),
//     );
//   }
// }
//

// ═══════════════════════════════════════════════════════════════════
// OPÇÃO 3: Chamar em um teste/script
// ═══════════════════════════════════════════════════════════════════
//
// Crie um arquivo test_firestore.dart:
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:appcidadao/core/debug/firestore_debug_servico.dart';
//
// void main() {
//   test('Verificar reportes no Firestore', () async {
//     await FirestoreDebugServico.verificarReportes();
//   });
// }
//

// ═══════════════════════════════════════════════════════════════════
// FUNÇÕES DISPONÍVEIS
// ═══════════════════════════════════════════════════════════════════
//
// 1. verificarReportes()
//    └─ Exibe TODOS os reportes do usuário logado
//       Mostra: ID, tipo, status, endereço, descrição, mídias (com URLs)
//
// 2. verificarUsuarioAtual()
//    └─ Exibe dados do usuário logado
//       Mostra: UID, email, nome, telefone, CPF, CEP, endereço
//
// 3. verificarEstatisticas()
//    └─ Exibe resumo/estatísticas
//       Mostra: Total de reportes, mídias, reportes por status
//
// 4. limparReportes(confirmar: true)
//    └─ ⚠️  DELETA TODOS os reportes do usuário! Use com cuidado!
//       Precisa confirmar como parâmetro para executar
//

// ═══════════════════════════════════════════════════════════════════
// EXEMPLO PRÁTICO
// ═══════════════════════════════════════════════════════════════════
//
// Suponha que você criou um reporte com 2 fotos.
// Depois de clicar em "Enviar", você quer verificar se foi salvo:
//
// 1. Rode o app: flutter run
// 2. Crie e envie um reporte (com fotos)
// 3. Abra o Debug Console
// 4. No prompt do debugger, digite:
//    FirestoreDebugServico.verificarReportes()
//
// Você verá algo como:
// ════════════════════════════════════════════════════════════════
// 🔍 VERIFICANDO REPORTES NO FIRESTORE
// ════════════════════════════════════════════════════════════════
// 👤 Usuário: seu-email@example.com (UID: abc123...)
// ────────────────────────────────────────────────────────────────
// ✅ Total de reportes: 1
//
// ━━━ REPORTE #1 ━━━
//    ID: uuid-abc123
//    Tipo: veiculo
//    Status: enviado
//    Endereço: Rua X, 123, Cidade
//    Descrição: Veículo pane...
//    Data Criação: 2026-04-08T14:30:00
//    📸 Mídias (2):
//       [0] Tipo: image, Nome: foto_1_...
//           URL: https://firebasestorage.googleapis.com/.../foto_1.jpg
//       [1] Tipo: image, Nome: foto_2_...
//           URL: https://firebasestorage.googleapis.com/.../foto_2.jpg
// ════════════════════════════════════════════════════════════════
//

// ═══════════════════════════════════════════════════════════════════
// RESOLUÇÃO DE PROBLEMAS
// ═══════════════════════════════════════════════════════════════════
//
// ❌ "Nenhum usuário logado!"
//    └─ Você precisa fazer LOGIN primeiro
//       Faça: Email + Senha ou Google Sign-In
//
// ❌ "Nenhum reporte encontrado!"
//    └─ Você ainda não criou/enviou nenhum reporte
//       Crie um novo reporte e tente novamente
//
// ❌ "Perfil não encontrado no Firestore!"
//    └─ Seu usuário foi criado no Firebase Auth mas não tem
//       documento no Firestore ainda
//       Solução: Faça logout e login novamente
//
// ❌ Erros de permissão (permission-denied)
//    └─ Suas regras do Firestore podem estar bloqueando
//       Verifique: Firebase Console → Firestore → Regras
//
// ⚠️  URLs das mídias apontam para file:///...
//    └─ Significa que o upload falhou
//       Verifique: Regras do Firebase Storage,
//                  Logs do app (⚠️ Upload falhou...)
//

void main() {
  // Este arquivo é apenas para documentação e exemplos
  // Não há código executável aqui
}
