# Agenda - Flutter Contact Manager

Este é um projeto de uma aplicação de agenda criada com Flutter. O aplicativo permite gerenciar contatos, oferecendo funcionalidades para listar, adicionar, editar e remover contatos, além de validação de dados e persistência local.

## Funcionalidades

- **Listagem de Contatos:** Exibe uma lista de contatos com nome, telefone e e-mail.
- **Cadastro e Edição de Contatos:** Permite inserir ou atualizar as informações de um contato, com validações para os campos de nome, telefone e e-mail.
- **Exclusão de Contatos:** Contatos podem ser excluídos da tela de edição.
- **Validação de Dados:** 
  - Nome é um campo obrigatório.
  - O telefone é validado para seguir o formato (XX) XXXX-XXXX.
  - O e-mail é validado para garantir um formato adequado.
- **Persistência de Dados Local:** Armazenamento dos contatos em memória (dados não persistem após reiniciar o app).
- **Máscara de Telefone:** O campo de telefone aplica uma máscara automática no formato (XX) XXXX-XXXX.

## Tecnologias Utilizadas

- **Flutter**: Framework para o desenvolvimento de interfaces multiplataforma (iOS, Android).
- **Provider**: Gerenciamento de estado.
- **Shared Preferences**: Para simulação de persistência de dados.
- **flutter_masked_text2**: Aplicação de máscara no campo de telefone.
