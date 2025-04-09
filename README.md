# Diário do Motociclista 🏍️

O Diário do Motociclista é um aplicativo Flutter projetado para ajudar entusiastas de motocicletas a acompanhar suas viagens, gerenciar a manutenção do veículo e registrar o consumo de combustível, tudo em um só lugar. Inspirado no aplicativo Yamaha Connected.

## ✨ Funcionalidades Principais

Este aplicativo implementa os seguintes requisitos funcionais e funcionalidades específicas:

*   **Autenticação Completa:**
    *   Login com Email e Senha (RF001)
    *   Validação de campos e formato de email.
    *   Cadastro de Novos Usuários (Nome, Email, Telefone, Senha) (RF002)
    *   Validação de todos os campos e confirmação de senha.
    *   Recuperação de Senha via Email (RF003)
*   **Gerenciamento de Viagens:**
    *   **Dashboard:** Lista de viagens registradas (`ListView` - RF007).
    *   **Detalhes da Viagem:** Informações completas sobre uma viagem específica (duração, distância, etc.).
    *   **Gravação de Rota:** Funcionalidade para iniciar e parar a gravação de uma viagem.
*   **Mídia:**
    *   **Galeria de Fotos:** Visualização das fotos associadas a uma viagem em formato de grade (`GridView` - RF007).
    *   Adicionar/Excluir fotos.
*   **Gerenciamento do Veículo:**
    *   **Consumo de Combustível:** Registro e visualização do histórico de abastecimentos.
    *   **Lembretes de Manutenção:** Cadastro e visualização de lembretes para serviços (troca de óleo, revisão, etc.).
*   **Informações:**
    *   **Tela Sobre:** Apresenta o objetivo do aplicativo e os nomes dos integrantes da equipe (RF004).
*   **Feedback ao Usuário:**
    *   Uso de `AlertDialog` e `SnackBar` para mensagens de confirmação, sucesso e erro (RF006).

## 💻 Tecnologias Utilizadas

*   **Flutter:** Framework principal para desenvolvimento multiplataforma.
*   **Dart:** Linguagem de programação.
*   **BLoC/flutter_bloc:** Para gerenciamento de estado de forma reativa e organizada.
*   **Material Design:** Diretrizes de design da interface, utilizando widgets nativos do Flutter.
*   **intl:** Para formatação de datas e números.
*   [Adicionar outros pacotes importantes que você usou, ex: `cached_network_image`, `google_maps_flutter`, etc.]

## 🏗️ Estrutura do Projeto

O projeto segue uma arquitetura baseada em camadas para melhor organização e manutenção:
