# 🔧 Guia de Configuração Firebase — Passo a Passo

Este guia explica **como configurar o Firebase** para que o App Cidadão funcione com back-end real. Escrito para qualquer pessoa, mesmo sem experiência técnica.

---

## Índice

1. [O que é o Firebase?](#1-o-que-é-o-firebase)
2. [Criar uma Conta Google](#2-criar-uma-conta-google)
3. [Criar o Projeto no Firebase](#3-criar-o-projeto-no-firebase)
4. [Habilitar Autenticação](#4-habilitar-autenticação)
5. [Habilitar o Banco de Dados (Firestore)](#5-habilitar-o-banco-de-dados-firestore)
6. [Habilitar o Armazenamento de Arquivos (Storage)](#6-habilitar-o-armazenamento-de-arquivos-storage)
7. [Conectar o App ao Firebase (FlutterFire CLI)](#7-conectar-o-app-ao-firebase-flutterfire-cli)
8. [Testar se tudo funciona](#8-testar-se-tudo-funciona)
9. [Regras de Segurança](#9-regras-de-segurança)
10. [Problemas Comuns](#10-problemas-comuns)

---

## 1. O que é o Firebase?

Firebase é uma plataforma gratuita do Google que fornece serviços de back-end para aplicativos, como:

- **Autenticação** — sistema de login seguro (email/senha, Google, etc.)
- **Firestore** — banco de dados na nuvem onde ficam salvos os reportes e perfis
- **Storage** — armazenamento de arquivos (fotos e vídeos dos reportes)

O plano gratuito (**Spark**) é mais que suficiente para desenvolvimento e testes:
- 50.000 leituras/dia no Firestore
- 20.000 escritas/dia
- 5 GB no Storage
- Autenticação de até 10.000 usuários/mês

---

## 2. Criar uma Conta Google

Se você já tem Gmail, já tem uma conta Google. Caso contrário:

1. Acesse [accounts.google.com/signup](https://accounts.google.com/signup)
2. Preencha nome, email e senha
3. Confirme o email

---

## 3. Criar o Projeto no Firebase

1. Acesse o **Firebase Console**: [console.firebase.google.com](https://console.firebase.google.com)
2. Clique em **"Adicionar projeto"** (ou "Add project")
3. Dê um nome ao projeto: `app-cidadao`
4. Na etapa do Google Analytics:
   - Para simplificar, **desabilite** o Google Analytics (pode habilitar depois)
5. Clique em **"Criar projeto"**
6. Aguarde a criação (leva uns 30 segundos)
7. Clique em **"Continuar"**

Pronto! Você agora tem um projeto Firebase.

---

## 4. Habilitar Autenticação

A autenticação permite que os usuários façam login e cadastro com segurança.

1. No menu lateral do Firebase Console, clique em **"Authentication"** (ou "Autenticação")
2. Clique em **"Começar"** (ou "Get started")
3. Na aba **"Método de login"** (Sign-in method), clique em **"E-mail/senha"**
4. **Habilite** o switch "E-mail/senha"
5. Clique em **"Salvar"**

Agora o Firebase aceita login e cadastro por email e senha.

---

## 5. Habilitar o Banco de Dados (Firestore)

O Firestore é onde ficam salvos os reportes e perfis dos usuários.

1. No menu lateral, clique em **"Firestore Database"**
2. Clique em **"Criar banco de dados"** (ou "Create database")
3. Escolha o local do servidor:
   - Recomendado: **southamerica-east1** (São Paulo) para menor latência no Brasil
4. Em "Regras de segurança", escolha **"Iniciar no modo de teste"**
   - Isso permite ler e escrever livremente por 30 dias (vamos ajustar depois)
5. Clique em **"Criar"**

O Firestore está ativo! As coleções `reportes` e `usuarios` serão criadas automaticamente quando o app salvar o primeiro dado.

---

## 6. Habilitar o Armazenamento de Arquivos (Storage)

O Storage é onde ficam as fotos e vídeos anexados aos reportes.

1. No menu lateral, clique em **"Storage"**
2. Clique em **"Começar"** (ou "Get started")
3. Em "Regras de segurança", aceite o modo de teste padrão
4. Escolha o local: **southamerica-east1** (mesmo do Firestore)
5. Clique em **"Concluído"**

---

## 7. Conectar o App ao Firebase (FlutterFire CLI)

Esta é a parte que conecta o código do app ao projeto Firebase que você acabou de criar.

### Pré-requisitos

Você precisa ter instalado:
- **Flutter** (já tem, se roda o app)
- **Node.js** — baixe em [nodejs.org](https://nodejs.org) se não tiver
- **Firebase CLI** — instale com o comando abaixo

### Passo a passo

Abra o **terminal** (Prompt de Comando ou PowerShell) e execute:

#### 7.1. Instalar o Firebase CLI

```bash
npm install -g firebase-tools
```

#### 7.2. Fazer login no Firebase

```bash
firebase login
```

Isso abre o navegador para autenticar com sua conta Google.

#### 7.3. Instalar o FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

#### 7.4. Configurar o projeto

Navegue até a pasta do projeto e execute:

```bash
cd c:\Users\ResTIC16\Documents\GitHub\appcidadao
flutterfire configure
```

O CLI vai:
1. Perguntar qual projeto Firebase usar → selecione `app-cidadao`
2. Perguntar quais plataformas → selecione **Android** (e iOS se for usar)
3. Gerar **automaticamente** o arquivo `lib/firebase_options.dart` com as credenciais reais
4. Configurar os arquivos nativos necessários (Android: `google-services.json`)

#### 7.5. Instalar as dependências

```bash
flutter pub get
```

---

## 8. Testar se tudo funciona

1. Rode o app no emulador ou dispositivo:

```bash
flutter run
```

2. **Teste o cadastro**: Crie uma conta com email e senha
3. **Verifique no Firebase Console**:
   - Vá em **Authentication** → deve aparecer o novo usuário
4. **Teste o login**: Faça login com a conta criada
5. **Envie um reporte**: Preencha qualquer formulário de reporte e envie
6. **Verifique no Firestore**:
   - Vá em **Firestore Database** → deve aparecer a coleção `reportes` com o documento
7. **Teste o modo offline**:
   - Desconecte a internet
   - O app deve mostrar um aviso laranja e continuar funcionando com dados locais

---

## 9. Regras de Segurança

O modo de teste expira em 30 dias. Antes disso, configure regras adequadas:

### Firestore

No Firebase Console → Firestore → **Regras**, substitua o conteúdo por:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Reportes: usuário só lê e escreve os PRÓPRIOS reportes
    match /reportes/{reporteId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null;
    }

    // Perfil: usuário só lê e escreve o PRÓPRIO perfil
    match /usuarios/{userId} {
      allow read, write: if request.auth != null
                         && request.auth.uid == userId;
    }
  }
}
```

### Storage

No Firebase Console → Storage → **Regras**, substitua por:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /reportes/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

Clique em **"Publicar"** em cada um.

---

## 10. Problemas Comuns

### "Firebase não inicializado"
**Causa**: O `firebase_options.dart` ainda está com valores placeholder.
**Solução**: Execute `flutterfire configure` conforme a seção 7.

### "Nenhuma conta encontrada" ao cadastrar
**Causa**: A autenticação por email/senha não foi habilitada.
**Solução**: Verifique a seção 4.

### "Permissão negada" ao salvar reporte
**Causa**: As regras de segurança do Firestore não permitem escrita.
**Solução**: Verifique se está no modo de teste ou se as regras da seção 9 estão aplicadas.

### "Sem conexão com o servidor"
**Causa**: Sem internet ou Firebase não configurado.
**Comportamento esperado**: O app exibe aviso laranja e funciona em modo local.

### Erro de build no Android
Se der erro ao compilar para Android, verifique:
1. `android/app/build.gradle` deve ter `minSdkVersion 21` ou superior
2. O `google-services.json` deve estar em `android/app/`
3. Execute `flutter clean && flutter pub get && flutter run`

---

> **Resumo**: Depois de seguir este guia, seu app terá login real, dados salvos na nuvem, e upload de fotos funcionando. Tudo isso de graça no plano Spark do Firebase. 🎉
