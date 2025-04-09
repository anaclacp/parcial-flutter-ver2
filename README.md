# Diário do Motociclista 🏍️

O Diário do Motociclista é um aplicativo Flutter projetado para ajudar entusiastas de motocicletas a acompanhar suas viagens, gerenciar a manutenção do veículo e registrar o consumo de combustível, tudo em um só lugar. Inspirado no aplicativo Yamaha Connected.

## ✨ Requisitos Funcionais

Este aplicativo implementa os seguintes requisitos funcionais e funcionalidades específicas:

*   **Autenticação Completa:**
    *   Login com Email e Senha (RF001)
    *   Validação de campos e formato de email.
    *   Cadastro de Novos Usuários (Nome, Email, Telefone, Senha) (RF002)
    *   Validação de todos os campos e confirmação de senha.
    *   Recuperação de Senha via Email (RF003)

*   **Funcionalidades Específicas (RF005):** O aplicativo implementa 5 funcionalidades principais distintas, cada uma em sua interface, além das telas de autenticação e sobre:
    1.  **Dashboard de Viagens (`trip_dashboard_page.dart`):** Lista as viagens registradas pelo usuário, utilizando `ListView` (RF007).
    2.  **Detalhes da Viagem (`trip_detail_page.dart`):** Exibe informações completas de uma viagem selecionada, incluindo opções como gravação de rota.
    3.  **Galeria de Fotos (`photo_gallery_page.dart`):** Mostra as fotos associadas a uma viagem em formato de grade, utilizando `GridView` (RF007). Permite adicionar/excluir fotos.
    4.  **Controle de Consumo (`fuel_consumption_page.dart`):** Permite o registro e visualização do histórico de abastecimentos, podendo incluir estatísticas.
    5.  **Lembretes de Manutenção (`maintenance_reminder_page.dart`):** Possibilita o cadastro e visualização de lembretes para serviços da motocicleta.

*   **Informações:**
    *   **Tela Sobre (`about_page.dart`):** Apresenta o objetivo do aplicativo e os nomes dos integrantes da equipe (RF004).

*   **Feedback ao Usuário (RF006):**
    *   Uso de `AlertDialog` para confirmações importantes (ex: exclusão).
    *   Uso de `SnackBar` para mensagens de sucesso (ex: cadastro, envio de email) e erros (ex: login inválido).
*   **Listagem de dados (RF007):**
    *   Uso de ListView e GridView nas telas `trip_dashboard_page.dart`, `photo_gallery_page.dart`.

