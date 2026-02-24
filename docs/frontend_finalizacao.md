# Front-End — Finalização (23/02/2026)

Resumo das alterações feitas para completar o front-end do App Cidadão.

---

## Arquivos Modificados

### 1. `tela_perfil.dart`
- Convertido de `StatelessWidget` para `StatefulWidget`
- Conectado ao `UsuarioController` via `Consumer<UsuarioController>`
- Campos de texto pré-preenchidos com dados reais do usuário (nome, email, telefone, CPF)
- Avatar carregado via `NetworkImage` (URL do modelo `Usuario`)
- Botão "Salvar" chama `UsuarioController.atualizarUsuario()` com loading state e SnackBar de sucesso

### 2. `tela_cadastro_usuario.dart`
- Importado `mask_text_input_formatter`
- Removido `_searchController` (declarado mas nunca usado)
- Adicionadas máscaras de input:
  - **CPF**: `###.###.###-##`
  - **Telefone**: `(##) #####-####`
  - **CEP**: `#####-###`
- Adicionado parâmetro `keyboardType` e `inputFormatters` ao método `_buildTextField`

### 3. `ajustes_pagina.dart`
- "Sobre o App" agora abre `showAboutDialog()` com: nome, versão 1.0.0, ícone e descrição do app
- Adicionado subtítulo "Versão e informações"

### 4. `notificacoes_aplicativo_pagina.dart`
- Botão "Restaurar padrões" agora reseta todas as variáveis booleanas para valores iniciais e exibe SnackBar de confirmação

### 5. `seguranca_pagina.dart`
- "Desativar minha conta" agora abre `AlertDialog` de confirmação com aviso sobre perda de dados
- Ação de desativação exibe SnackBar "Solicitação de desativação enviada"

### 6. `suporte_pagina.dart`
- "Chat via WhatsApp" abre link `wa.me` via `url_launcher`
- "Enviar E-mail" abre app de email via scheme `mailto:`
- "Termos de Uso" navega para `TelaTermosUso`
- "Política de Privacidade" navega para `TelaPoliticaPrivacidade`
- Ambos com fallback/SnackBar de erro caso não consiga abrir

### 7. `pubspec.yaml`
- Adicionado `url_launcher: ^6.2.4`

---

## Arquivos Novos

### 8. `termos_uso_pagina.dart`
Tela completa com 7 seções: Aceitação, Descrição do Serviço, Cadastro, Uso Adequado, Propriedade Intelectual, Limitação de Responsabilidade e Contato.

### 9. `politica_privacidade_pagina.dart`
Tela completa (LGPD) com 7 seções: Coleta de Dados, Uso dos Dados, Compartilhamento, Armazenamento, Direitos do Usuário, Cookies e Contato do DPO.

---

## O que ainda falta (Backend)

Estas mudanças são **somente front-end**. Ainda é necessário:

- Substituir `Future.delayed` por chamadas reais de API na autenticação
- Implementar repositórios com persistência real (API/SQLite)
- Upload real de mídia (Firebase Storage, S3, etc.)
- Push notifications via Firebase Cloud Messaging
- Testes unitários e de integração

---

> **Dica**: Rode `flutter pub get` para instalar o `url_launcher` antes de compilar.
