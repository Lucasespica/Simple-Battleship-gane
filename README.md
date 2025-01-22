# Simple-Battleship-game
---
Descrição: 

O programa se trata do jogo “Batalha Naval”, feito via programação em linguagem Assembly (MASM), reproduzindo uma matriz 10x10 que contém embarcações posicionadas de maneira aleatória cujo usuário deverá acertar por meio de “tiros”. 

Como executar o programa:

Para executar o programa, é necessário o uso do Visual Studio Code, aliado a extensão MASM/TASM, disponibilizada para download na aba “extensions” da IDE

Após o download e instalação da IDE/Extensão, basta abrir o arquivo e, após isso, clicar com o botão direito do mouse em qualquer linha do código e selecionar a opção “Run ASM code”

Como jogar:

Iniciando o programa, o usuário poderá optar entre iniciar o jogo, teclando “ENTER” ou sair do mesmo, digitando a letra “X”. 
Caso tecle “ENTER” o jogo iniciará, imprimindo na tela uma matriz 10x10 representando o tabuleiro do jogo, sendo a posição das embarcações escolhida de maneira aleatória dentre dez modelos de matriz pré definidos.
Após isso, será solicitado que o usuário digite o valor referente à posição da “coluna” e, logo após, fará a mesma coisa em relação à posição da linha, sendo  tais posições escolhidas exclusivamente números de 0 a 9.
Caso o usuário digite um valor diferente do solicitado, a mensagem “coordenada inválida” será exibida. Caso a posição já tenha sido escolhida anteriormente, o usuário também será avisado.
Em sequência, o jogo irá verificar se a posição escolhida possui ou não uma embarcação, indicando então ao usuário se o mesmo acertou a “água” ou se acertou alguma embarcação.
Após destruir todas as partes de uma mesma embarcação, o jogador será informado por mensagem sobre qual embarcação foi destruída.
 Após descobrir todas as embarcações, o usuário será direcionado para a tela de vitória. 
A qualquer momento durante o jogo, caso o usuário não queira mais jogar, poderá então apertar a tecla “X” para finalizar o programa.

Como o programa é formado:

O programa contém todos os macros e procedimentos necessários para a execução, macros para limpar a tela, executar uma mensagem na tela, pular linha e dar espaço. O código possui 8 procedimentos, todos bem organizados com suas devidas funções.
---
