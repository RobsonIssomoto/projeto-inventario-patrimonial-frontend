# 📱 Sistema de Gestão e Inventário Patrimonial — Aplicativo Mobile

Aplicativo mobile do sistema de controle e inventário patrimonial desenvolvido para o Projeto Integrador. O aplicativo permite consultar patrimônios, acessar a funcionalidade de escaneamento, registrar observações e iniciar o processo de transferência de bens.

## 🏗️ Objetivo

Disponibilizar uma interface mobile para apoiar a conferência física e a gestão de patrimônios. O aplicativo é desenvolvido em Flutter e foi estruturado para se integrar à API REST do sistema.

## 🛠️ Tecnologias

- Flutter.
- Dart.
- Material Design.
- Git e GitHub para versionamento.

## 📌 Estrutura

```text
lib/       # Código-fonte do aplicativo
assets/    # Imagens e recursos estáticos
android/   # Configurações específicas para Android
ios/       # Configurações específicas para iOS
web/       # Configurações específicas para Web
test/      # Testes automatizados
```

## Funcionalidades

- Navegação principal por menu inferior.
- Seções de início, inventário e perfil.
- Acesso à tela de scanner por rota separada.
- Botão para acessar a transferência de patrimônio.
- Campo de observação para informações adicionais sobre o patrimônio.

> Algumas funcionalidades ainda estão em desenvolvimento.

## Pré-requisitos

- Flutter SDK instalado.
- Dart SDK compatível com a versão definida no `pubspec.yaml`.
- Android Studio, VS Code ou outro editor com suporte ao Flutter.
- Emulador Android/iOS, dispositivo físico ou navegador para execução Web.
- Git, caso o projeto seja clonado do GitHub.

## 🚀 Instalação

Clone o repositório e instale as dependências:

```bash
git clone https://github.com/RobsonIssomoto/projeto-inventario-patrimonial-frontend.git
cd projeto-inventario-patrimonial-frontend
flutter pub get
```

## Execução

Para executar em um dispositivo ou emulador Android:

```bash
flutter run
```

Para executar no navegador:

```bash
flutter run -d chrome
```

Para listar os dispositivos disponíveis:

```bash
flutter devices
```

## 🗺️ Status do projeto

- Estrutura inicial do aplicativo Flutter criada.
- Navegação principal implementada com menu inferior.
- Tela de scanner acessada por rota separada.
- Botão de transferência adicionado à interface.
- Campo de observação adicionado à interface.
- Integração com a API back-end em desenvolvimento.

## Próximos passos

- Integrar o aplicativo à API REST.
- Implementar autenticação e autorização.
- Implementar consulta e atualização de patrimônios.
- Implementar registro de conferências e transferências.
- Adicionar testes automatizados.
- Publicar versões para Android e iOS.

## Repositório back-end

A API REST do sistema é mantida em um repositório separado.
