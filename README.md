# 🏙️ App Cidadão - Gestão Urbana na Palma da Mão

O **App Cidadão** é uma plataforma mobile desenvolvida em Flutter que permite aos moradores da cidade reportar problemas urbanos diretamente para a gestão municipal. O foco é a praticidade, utilizando uma interface moderna com tema "Dark Mode" e cores neon para alta visibilidade.

## 🚀 Funcionalidades Atuais

O aplicativo conta com diversos módulos de reporte, cada um com campos específicos e validações robustas:

*  Interferência na Via:** Reporte de buracos, lixo descartado ou obstruções.
*  Semáforos:** Notificação de luzes queimadas ou problemas de sincronia.
*  Veículos Abandonados:** Registro de carros quebrados ou abandonados em via pública.
*  Estacionamento Irregular:** Denúncia de infrações de trânsito.
*  Sinalização:** Alerta sobre placas danificadas ou faixas apagadas.
*  Iluminação Pública:** Solicitação de reparos em postes de luz.

##  Tecnologias Utilizadas

* **Linguagem:** Dart
* **Framework:** [Flutter](https://flutter.dev) (v3.x+)
* **Gerenciamento de Estado:** StatefulWidget (Pronto para implementação de Provider/Bloc/Riverpod)
* **UI/UX:** Design customizado com foco em usabilidade noturna e acessibilidade.

## 📂 Estrutura de Pastas

```text
lib/
├── core/
│   └── constantes/       # Definições de cores (AppCores) e estilos globais.
├── funcionalidades/
│   ├── home/             # Tela principal e lista de funcionalidades.
│   ├── ajustes/          # Configurações do perfil e app.
│   └── [modulos]/        # Telas de reporte específicas (Dart files).
└── main.dart             # Ponto de entrada do aplicativo.
