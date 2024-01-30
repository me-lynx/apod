# Projeto APOD - Versão do Flutter: 3.19.0-9.0.pre.155

Este projeto é uma aplicação Flutter que utiliza a API Astronomy Picture of the Day (APOD) da NASA para exibir imagens astronômicas diárias e suas descrições.

## Cobertura de testes
Ainda em desenvolvimento, cobertura atual: 31.88%.

## Arquitetura

O projeto segue alguns conceitos da Clean Architecture, o que significa que ele é dividido em camadas, cada uma com uma responsabilidade específica. Isso torna o código mais fácil de manter e testar.

As camadas são as seguintes:

- **Camada de Dados**: Responsável pela comunicação com fontes de dados externas, como a API APOD da NASA.
- **Camada de Domínio**: Contém a lógica de negócios da aplicação. Esta camada é independente de outras camadas.
- **Camada de Apresentação**: Responsável pela exibição dos dados ao usuário e pela manipulação das interações do usuário.
- **Helpers**: Responsaveis por validar e ajudar na aplicação

## Cubit

Para gerenciar o estado da aplicação, este projeto utiliza a biblioteca Cubit. Cubit é uma biblioteca de gerenciamento de estado mais simples e mais leve que o BLoC, mas que ainda segue os mesmos princípios: os eventos entram e os estados saem.

Cada Cubit aceita eventos, processa-os produzindo um novo estado e então emite esse novo estado.

## Como executar

Para executar este projeto, você precisa ter o Flutter instalado e configurado em sua máquina. Depois de clonar o repositório, você pode executar o projeto com o comando `flutter run`.

## Contribuição

Contribuições são bem-vindas! Se você encontrar um bug ou quiser adicionar uma nova funcionalidade, sinta-se à vontade para criar uma issue ou um pull request.

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.


## Images 

<img src="https://raw.githubusercontent.com/me-lynx/apod/main/screenshots/Screenshot_1706572152.png?token=GHSAT0AAAAAACNC5KOH2M3EFMOIADWVEB7MZNYIGNQ" width="200">
<img src="(https://raw.githubusercontent.com/me-lynx/apod/main/screenshots/Screenshot_1706572157.png?token=GHSAT0AAAAAACNC5KOGCO74NFQUWJMQKNYCZNYIGUQ" width="200">
