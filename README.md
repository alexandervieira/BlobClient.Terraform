## Perfil

Consulte o meu perfil <a href="https://github.com/alexandervsilva/alexandervsilva/blob/master/README.md">aqui</a>.

<h1 align="center" style="font-weight: bold;">BlobClient 💻</h1>

## Índice

- [Índice](#índice)
- [Começo rápido](#começo-rápido)
- [Estrutura do repositório](#estrutura-do-repositório)
- [Erros e solicitações de recursos](#erros-e-solicitações-de-recursos)
- [Contribuição](#contribuição)
- [Criador](#criador)
- [Agradecimentos](#agradecimentos)
- [Direitos e licença](#direitos-e-licença)

## Começo rápido

Consulte a lista de comandos úteis do GIT <a href="https://github.com/alexandervieira/Repositorio.Default/blob/master/git.md">aqui</a>.

## Estrutura do repositório

```
BlobClient.Terraform/
├── src/
│   ├── frontend/
│   │   └── AVS.Webapp/                      # Frontend ASP.NET Core MVC application
│   └── backend/
│       └── AzureFunctions/
│           └── AVS.BlobClient.FunctionApp/  # Azure Functions (.NET 9 Isolated)
├── infra/
│   ├── main.tf                              # Main Terraform configuration
│   ├── variables.tf                         # Variable definitions
│   ├── provider.tf                          # Azure provider configuration
│   ├── outputs.tf                           # Output definitions
│   └── locals.tf                            # Local variables
│    
├── .gitignore
└── README.md
```

### Descrição dos componentes:

- **Frontend**: Aplicação web ASP.NET Core MVC
- **Backend**: Azure Functions em .NET 9 (Isolated)
- **Infra**: Configurações Terraform para provisionamento da infraestrutura Azure
  - Storage Account
  - Key Vault
  - App Service Plan
  - Azure Web App
  - Azure Function App

## Erros e solicitações de recursos
Tem um bug ou uma solicitação de recurso? Leia primeiro as [diretrizes do problema](https://reponame/blob/master/CONTRIBUTING.md)  e pesquise os problemas existentes e encerrados. [abra um novo problema](https://github.com/alexandervieira/Repositorio.Default/issues).

## Contribuição

Por favor, leia nossas [diretrizes de contribuição](https://reponame/blob/master/CONTRIBUTING.md). Estão incluídas instruções para abrir questões, padrões de codificação e notas sobre o desenvolvimento.

## Criador

- <https://github.com/alexandervsilva>

## Agradecimentos

Obrigado por consultar, divulgar ou contribuir.

## Direitos e licença

Código e documentação com copyright 2021 dos autores. Código divulgado sob a [MIT License](https://github.com/alexandervieira/Repositorio.Default/blob/master/LICENSE).

<h3>Documentações que podem ajudar</h3>

[📝 Como criar um Pull Request](https://www.atlassian.com/br/git/tutorials/making-a-pull-request)

[💾 Commit pattern](https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716)
