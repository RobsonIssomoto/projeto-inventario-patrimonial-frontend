# 📱 Sistema de Gestão e Inventário Patrimonial — Aplicativo Mobile

Aplicativo mobile do sistema de controle e inventário patrimonial desenvolvido para o Projeto Integrador. O aplicativo permite autenticar usuários, consultar e atualizar patrimônios, registrar observações, acompanhar o histórico de movimentações e gerenciar o fluxo de transferência e recebimento de bens entre salas e secretarias.

## 🏗️ Objetivo

Disponibilizar uma interface mobile para apoiar a conferência física e a gestão de patrimônios. O aplicativo é desenvolvido em Flutter, utiliza o Firebase Authentication para autenticação e se comunica com a API REST do sistema.

## 🛠️ Tecnologias

- Flutter.
- Dart.
- Material Design.
- Firebase Authentication (`firebase_core` e `firebase_auth`).
- Dio para requisições HTTP.
- Git e GitHub para versionamento.

## 🧱 Arquitetura

O projeto segue uma organização em camadas inspirada no padrão MVVM:

- **Views** — páginas e widgets da interface.
- **ViewModels** — estado e regras de apresentação de cada tela.
- **Repositories** — intermediam o acesso aos dados pelos ViewModels.
- **Services** — chamadas aos endpoints da API.
- **ApiRequester** — camada central de requisições HTTP com Dio, responsável por anexar o token do Firebase e padronizar o tratamento de erros.

## 📌 Estrutura

```text
lib/
├── data/network/   # ApiRequester (requisições HTTP centralizadas)
├── models/         # Modelos: patrimônio, sala, secretaria, usuário, movimentação
├── repositories/   # Repositórios de acesso aos dados
├── services/       # Serviços de comunicação com a API e configuração base
├── viewmodels/     # ViewModels das telas
├── views/
│   ├── pages/      # Telas do aplicativo
│   ├── widgets/    # Componentes reutilizáveis
│   └── cores.dart  # Paleta de cores (AppCores)
├── firebase_options.dart
└── main.dart
assets/    # Imagens e recursos estáticos
android/   # Configurações específicas para Android
ios/       # Configurações específicas para iOS
web/       # Configurações específicas para Web
test/      # Testes automatizados
```

## Funcionalidades

### Autenticação e perfil

- Splash screen e tema visual com paleta própria.
- Login integrado ao Firebase Authentication.
- Criação de senha no primeiro acesso.
- Exibição dos dados do usuário autenticado.
- Alteração de senha e logout.

### Patrimônios

- Navegação principal por menu inferior (Início, Scanner e Inventário).
- Listagem de patrimônios consumida da API autenticada.
- Busca, filtros por sala e categoria e ordenação por descrição ou número.
- Tela de detalhes com card de validação e campo de observação.
- Atualização do patrimônio, incluindo troca de sala.

### Movimentações

- Histórico de movimentações do patrimônio.
- Criação de transferência pendente para outra sala/secretaria.
- Cancelamento de transferência pelo histórico.
- Tela de recebimentos para confirmar transferências recebidas, escolhendo a sala de destino (disponível para usuários com perfil **gerente** ou **administrador**).

### Scanner

- Tela de scanner acessada por rota separada (área da câmera ainda em desenvolvimento).
  > Algumas funcionalidades ainda estão em desenvolvimento.

## Pré-requisitos

- Flutter SDK instalado.
- Dart SDK compatível com a versão definida no `pubspec.yaml`.
- Android Studio, VS Code ou outro editor com suporte ao Flutter.
- Emulador Android/iOS, dispositivo físico ou navegador para execução Web.
- API back-end em execução (ver seção [Repositório back-end](#repositório-back-end)).
- Git, caso o projeto seja clonado do GitHub.

## 🚀 Instalação

Clone o repositório e instale as dependências:

```bash
git clone https://github.com/RobsonIssomoto/projeto-inventario-patrimonial-frontend.git
cd projeto-inventario-patrimonial-frontend
flutter pub get
```

## ⚙️ Configuração

O endereço da API é definido em `lib/services/api_config.dart`:

```dart
const String apiBaseUrl = 'http://localhost:3000/api/v1';
```

Ajuste esse valor conforme o ambiente. No emulador Android, `localhost` aponta para o próprio emulador; nesse caso use `http://10.0.2.2:3000/api/v1`. Em dispositivo físico, use o IP da máquina onde a API está rodando.

A configuração do Firebase já está em `lib/firebase_options.dart` e `firebase.json`.

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

- Estrutura do aplicativo Flutter organizada em camadas (MVVM).
- Splash, tema e identidade visual implementados.
- Autenticação com Firebase (login, primeiro acesso, alteração de senha e logout).
- Integração com a API REST via Dio e `ApiRequester` centralizado.
- Listagem, busca, filtros e ordenação de patrimônios.
- Detalhes e atualização de patrimônio, com troca de sala.
- Histórico de movimentações.
- Criação, cancelamento e recebimento de transferências.
- Tela de scanner criada; leitura pela câmera em desenvolvimento.

## Próximos passos

- Implementar a leitura de código pela câmera na tela de scanner.
- Implementar o registro de conferências patrimoniais.
- Tornar o endereço da API configurável por ambiente.
- Adicionar testes automatizados (o teste atual ainda é o modelo padrão do Flutter).
- Publicar versões para Android e iOS.

## Repositório back-end

A API REST do sistema é mantida em:
https://github.com/RobsonIssomoto/projeto-inventario-patrimonial-backend
