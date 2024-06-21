# Aplicativo Cliente-Servidor de Captura de Tela

Este projeto implementa um aplicativo cliente-servidor para capturar e transmitir capturas de tela. O cliente captura a tela de um monitor especificado e envia para o servidor. O servidor recebe a captura de tela, exibe-a e a salva em um diretório temporário.

## Funcionalidades

- **Cliente**: Captura capturas de tela de monitores especificados e as envia para o servidor.
- **Servidor**: Recebe as capturas de tela, exibe-as e as salva em um diretório temporário.

## Requisitos

- IDE Delphi
- Sistema Operacional Windows

## Instalação

1. **Clonar o Repositório:**
    ```bash
    git clone https://github.com/mrlonmra/DesktopStreamingTCP-Pascal.git
    cd DesktopStreamingTCP-Pascal
    ```

2. **Abrir o Projeto:**
    - Abra a IDE Delphi.
    - Abra o arquivo de projeto do cliente (`Client.dproj`) e do servidor (`Server.dproj`).

3. **Compilar e Executar:**
    - Compile e execute primeiro o projeto do servidor.
    - Compile e execute o projeto do cliente.

## Uso

1. **Servidor:**
    - Ao iniciar, o servidor estará ativo e aguardando conexões dos clientes.
    - Ele exibirá uma mensagem indicando que está ativo.

2. **Cliente:**
    - O cliente tentará se conectar ao servidor especificado no código.
    - Quando conectado, o cliente poderá capturar e enviar capturas de tela de monitores especificados.

## Estrutura do Código

### Cliente

- `FormCreate`: Inicializa o socket do cliente.
- `ConnectionTimerTimer`: Tenta conectar ao servidor periodicamente.
- `ClientSocket1Connect`: Habilita o timer principal ao conectar.
- `ClientSocket1Disconnect`: Desabilita o timer principal ao desconectar.
- `ClientSocket1Read`: Lê dados recebidos do servidor.
- `HandleCommand`: Processa comandos recebidos do servidor.
- `GetScreenShot`: Captura uma captura de tela de um monitor especificado.
- `SaveReceivedImageToTemp`: Salva a imagem recebida em um diretório temporário.

### Servidor

- `FormCreate`: Inicializa o socket do servidor.
- `ServerSocket1ClientConnect`: Exibe uma mensagem ao conectar um cliente.
- `ServerSocket1ClientDisconnect`: Exibe uma mensagem ao desconectar um cliente.
- `ServerSocket1ClientRead`: Lê dados recebidos do cliente.
- `HandleCommand`: Processa comandos recebidos do cliente.
- `SaveReceivedImageToTemp`: Salva a imagem recebida em um diretório temporário.

## Contribuição

Se você quiser contribuir com o projeto, sinta-se à vontade para abrir um pull request ou relatar problemas na página de issues do repositório.
