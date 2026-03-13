# Melhorias Implementadas — App Cidadão

> Documento gerado em 11/03/2026 descrevendo as 14 melhorias aplicadas ao projeto.

---

## 1. 🔴 Inicialização do Firebase (`main.dart`)

**Problema:** O Firebase nunca era inicializado, fazendo todos os serviços (Auth, Firestore, Storage) falharem silenciosamente e caírem no modo offline.

**Solução:** Adicionado `await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` no `main()`.

**Arquivo:** `lib/main.dart`

---

## 2. 🔴 Repositórios ComFallback nos Controllers

**Problema:** `ReporteController` e `UsuarioController` usavam `ReporteRepositorioLocal` por padrão, perdendo todos os dados ao fechar o app.

**Solução:** Alterado o default para `ReporteRepositorioComFallback` e `UsuarioRepositorioComFallback`, que tentam Firebase primeiro e caem no local se offline.

**Arquivos:**
- `lib/funcionalidades/home/controladores/reporte_controller.dart`
- `lib/funcionalidades/home/controladores/usuario_controller.dart`

---

## 3. ✅ Testes Unitários

**Adicionados 3 arquivos de teste:**

| Arquivo | Testes | Cobertura |
|---------|--------|-----------|
| `test/controladores/reporte_controller_test.dart` | 6 testes | CRUD + estado de loading |
| `test/controladores/usuario_controller_test.dart` | 5 testes | Carregamento + atualização de perfil |
| `test/utilitarios/validators_test.dart` | 26 testes | Todos os validators |

**Como rodar:**
```bash
flutter test test/utilitarios/validators_test.dart
flutter test test/controladores/
```

---

## 4. 🧩 Formulário Base de Reporte (`ReporteFormularioBase`)

**Problema:** As 6 páginas de reporte tinham ~70% de código duplicado (endereço, geolocalização, mídia, submit, inputStyle).

**Solução:** Criado widget `ReporteFormularioBase` em `lib/core/widgets/reporte_formulario_base.dart` que encapsula:
- Campos comuns (endereço com geolocalização, ponto de referência, descrição)
- Seletor de mídia integrado
- Dropdown de categorias (configurável)
- Botão de submit com dialog de confirmação
- Aceita `camposExtras` para campos específicos de cada tipo

As páginas existentes podem ser simplificadas para usar este widget base.

---

## 5. 🔧 Refatoração do Seletor de Mídia

**Problema:** `seletor_midia_widget.dart` tinha 408 linhas com lógica de captura, preview e UI juntas.

**Solução:** Extraído em 3 componentes:
- **`SeletorMidiaWidget`** — mantém botões de captura, delega preview ao componente abaixo
- **`MediaPreviewGrid`** (`lib/core/widgets/media_preview_grid.dart`) — thumbnails com tap-to-fullscreen
- **`MediaFullscreenViewer`** (`lib/core/widgets/media_fullscreen_viewer.dart`) — visualização fullscreen com pinch-to-zoom

---

## 6. 🗺️ Roteamento Centralizado (`AppRotas`)

**Problema:** Apenas 4 rotas hardcoded em `main.dart`, navegação interna via `Navigator.push` direto.

**Solução:** Criado `lib/core/rotas/app_rotas.dart` com:
- 15 rotas nomeadas como constantes (`AppRotas.login`, `AppRotas.home`, etc.)
- Método `gerarRota()` usado como `onGenerateRoute` no MaterialApp
- Rota 404 de fallback

---

## 7. 📡 Monitoramento de Conectividade

**Problema:** Sem monitoramento ativo de rede — quando voltava online, os dados locais não eram sincronizados.

**Solução:**
- Adicionado `connectivity_plus: ^6.1.4` ao `pubspec.yaml`
- Criado `lib/core/servicos/conectividade_service.dart` — singleton que monitora mudanças de rede e notifica ouvintes
- Inicializado no `main()`

---

## 8. ✅ Validators Reutilizáveis

**Criado:** `lib/core/utilitarios/validators.dart`

**Funções disponíveis:**
- `Validators.campoObrigatorio(valor, [nomeCampo])`
- `Validators.email(valor)`
- `Validators.cpf(valor)` — inclui validação dos dígitos verificadores
- `Validators.cep(valor)`
- `Validators.telefone(valor)`
- `Validators.senha(valor)`
- `Validators.confirmarSenha(valor, senhaOriginal)`

Todos aceitam valores com ou sem máscara e retornam mensagens em português.

---

## 9. 🔔 Notificações Push (Firebase Messaging)

**Criado:** `lib/core/servicos/notificacao_service.dart`

**Funcionalidades:**
- Solicita permissão de notificação ao usuário
- Obtém e loga o token FCM (para envio de notificações do backend)
- Escuta mensagens em foreground e background
- Detecta abertura do app via notificação

**Dependência:** `firebase_messaging: ^15.2.0`

> **Nota:** Para enviar notificações, é necessário configurar o backend (Cloud Functions ou servidor) para enviar mensagens via FCM usando o token.

---

## 10. 🗺️ Mapa Interativo

**Criado:** `lib/funcionalidades/home/apresentacao/paginas/mapa_reportes_pagina.dart`

**Funcionalidades:**
- Mapa OpenStreetMap via `flutter_map` (sem necessidade de API key do Google)
- Marcadores coloridos por status do reporte (laranja=pendente, azul=enviado, amarelo=em análise, verde=resolvido)
- Bottom sheet com detalhes ao tocar no marcador
- Legenda de cores e contador total
- Centralizado em São Luís, MA (sede da Equatorial)

**Dependências:** `flutter_map: ^7.0.2`, `latlong2: ^0.9.1`

---

## 11. 📸 Galeria de Fotos com Zoom/Fullscreen

**Criado:** `lib/core/widgets/media_fullscreen_viewer.dart`

**Funcionalidades:**
- `InteractiveViewer` com pinch-to-zoom (0.5x a 4x)
- `PageView` para navegar entre múltiplas mídias (swipe horizontal)
- Indicador de página (dots animados)
- Método estático `MediaFullscreenViewer.abrir()` para uso fácil

**Integrado em:**
- `MediaPreviewGrid` — tap em thumbnail abre fullscreen
- `HistoricoReportesPagina` — mídias nos detalhes do reporte

---

## 12. 🔍 Filtro e Busca no Histórico

**Reescrito:** `lib/funcionalidades/home/apresentacao/paginas/historico_reportes_pagina.dart`

**Mudanças:**
- Usa `ReporteController` via Provider (antes usava repositório local direto)
- **Barra de busca** — filtra por endereço, descrição, tipo ou ID
- **Filtros por tipo** — chips dinâmicos gerados a partir dos reportes existentes
- **Filtros por status** — chips para Pendente, Enviado, Em Análise, Resolvido
- **Ícones por tipo** — cada tipo tem ícone distinto (lâmpada, semáforo, placa, etc.)
- **Status coloridos** — badges com cor do status
- **Data de criação** — exibida no card
- **Botão "Limpar filtros"** — quando há filtros ativos
- **Galeria de mídias** — nos detalhes, com suporte a fullscreen

---

## 13. 💾 Cache Local Persistente (Hive)

**Criado:** `lib/core/servicos/hive_service.dart`

**Funcionalidades:**
- 3 boxes Hive: `reportes`, `usuario`, `configuracoes`
- CRUD completo para reportes e usuário
- Método genérico `getConfig`/`setConfig` para preferências
- Inicialização automática via `HiveService().inicializar()`

**Dependências:** `hive: ^2.2.3`, `hive_flutter: ^1.1.0`

---

## 14. 🌐 Internacionalização (i18n)

**Criado:**
- `l10n.yaml` — configuração do gerador
- `lib/l10n/app_pt.arb` — 47 strings em português (idioma base)
- `lib/l10n/app_en.arb` — 47 strings em inglês

**Configurado em `main.dart`:**
- `localizationsDelegates` com Material, Widgets e Cupertino
- `supportedLocales` com pt-BR e en-US
- `locale` padrão pt-BR

**Dependências:** `flutter_localizations` (SDK), `intl: ^0.19.0`

**Para gerar o código l10n:**
```bash
flutter gen-l10n
```

---

## Resumo de Arquivos

### Arquivos Novos (15)
| Arquivo | Recomendação |
|---------|-------------|
| `lib/core/utilitarios/validators.dart` | 8 |
| `lib/core/rotas/app_rotas.dart` | 6 |
| `lib/core/servicos/conectividade_service.dart` | 7 |
| `lib/core/servicos/notificacao_service.dart` | 9 |
| `lib/core/servicos/hive_service.dart` | 13 |
| `lib/core/widgets/reporte_formulario_base.dart` | 4 |
| `lib/core/widgets/media_fullscreen_viewer.dart` | 11 |
| `lib/core/widgets/media_preview_grid.dart` | 5 |
| `lib/funcionalidades/home/apresentacao/paginas/mapa_reportes_pagina.dart` | 10 |
| `lib/l10n/app_pt.arb` | 14 |
| `lib/l10n/app_en.arb` | 14 |
| `l10n.yaml` | 14 |
| `test/controladores/reporte_controller_test.dart` | 3 |
| `test/controladores/usuario_controller_test.dart` | 3 |
| `test/utilitarios/validators_test.dart` | 3 |

### Arquivos Modificados (7)
| Arquivo | Recomendação |
|---------|-------------|
| `lib/main.dart` | 1, 6, 7, 14 |
| `lib/funcionalidades/home/controladores/reporte_controller.dart` | 2 |
| `lib/funcionalidades/home/controladores/usuario_controller.dart` | 2 |
| `lib/core/widgets/seletor_midia_widget.dart` | 5 |
| `lib/funcionalidades/home/apresentacao/paginas/historico_reportes_pagina.dart` | 12 |
| `lib/core/modelos/usuario.dart` | Limpeza |
| `pubspec.yaml` | 7, 9, 10, 13, 14 |
| `test/widget_test.dart` | 3 |

### Dependências Adicionadas (8)
| Pacote | Versão | Uso |
|--------|--------|-----|
| `connectivity_plus` | ^6.1.4 | Monitoramento de rede |
| `firebase_messaging` | ^15.2.0 | Notificações push |
| `flutter_map` | ^7.0.2 | Mapa OpenStreetMap |
| `latlong2` | ^0.9.1 | Coordenadas geográficas |
| `hive` | ^2.2.3 | Cache local |
| `hive_flutter` | ^1.1.0 | Integração Hive + Flutter |
| `flutter_localizations` | SDK | i18n |
| `intl` | ^0.19.0 | Formatação i18n |

---

