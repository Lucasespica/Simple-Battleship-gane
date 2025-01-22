TITLE BATALHA NAVAL
.MODEL SMALL
.STACK 100h
.DATA
;macros
LIMPA_TELA MACRO
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX  
    MOV AH, 06              ;macro para limpar a tela
    MOV BH, 07
    MOV CX, 0000H           ;Exelente para deixar o projeto mais estético
    MOV DX, 184FH
    INT 10H
    POP DX
    POP CX
    POP BX
    POP AX
ENDM

NOVA_LINHA MACRO            ;macro para pular de linha
    PUSH AX
    PUSH DX
   
    MOV AH, 2
    MOV DL, 10
    INT 21h  


    POP AX
    POP DX
ENDM

IMPRIME MACRO MSG           ;macro para imprimir msgs
    PUSH DX
    PUSH AX


    LEA DX, MSG      
    MOV AH, 9      
    INT 21h


    POP AX
    POP DX        
ENDM

ESPACO MACRO                ;macro de espaço
    PUSH AX
    PUSH DX

    MOV DX,32
    MOV AH,02
    INT 21H

    POP DX
    POP AX
ENDM

    MSG_INICIO DB 10,13,' Bem-vindo(a) A batalha naval, seu objetivo sera destruir as 6 embarcacoes. A agua sera representada por (W) e, ao acertar uma embarcacao, (X).$'
    MSG_INICIO2 DB 10,10,13,' Uma matriz sera gerada aleatoriamente, possuindo os valores de onde estao os barcos.$'
    MSG_INICIO3 DB 10,10,13,' Para atirar, selecione o valor da coluna e depois da linha, tendo como base os numeros indicados na tela da matriz.$'
    MSG_INICIO4 DB 10,10,13,' Boa sorte!$'
    MSG_INICIO5 DB 10,10,13,' O projeto foi feito por Lucas Espica Rezende, Antonio Magalhaes Roquete Macedo e Gabriel Henrique Pozeti de Faria. $'
    MSG_INICIO6 DB 10,10,13,' OBS: PARA SAIR DO JOGO A QUALQUER MOMENTO, DIGITE (X).$'
    MSG1 DB 10,13,10,10,10,"                       --> PRESSIONE ENTER PARA JOGAR <--$"
    TIROC DB 10,13," Digite o numero da coluna desejada: $"
    TIROL DB 10,13," Digite o numero da linha desejada: $"
    VENCE DB 10,13,"                           !! === VOCE VENCEU === !! $"
    CINVALIDA DB 10,13," Cordenada invalida, tente novamente: $"
    CJAFOI  DB 10,13," Essa cordenada ja foi escolhida anteriormente, tente novamente: $"
    ENC_MSG DB 10,13, " Voce eliminou um encouracado! $"
    FRAGATA_MSG DB 10,13," Voce eliminou uma fragata! $"
    SUB_MSG DB 10,13," Voce eliminou um submarino! $"
    HIDRO_MSG DB 10,13," Voce eliminou um hidroaviao! $"
    AGUA_MSG DB 10,13," ERROU! Acertou a agua! $"
    ACERTOU_MSG DB 10,13," ACERTOU! $"

    NUM_MATRIZ EQU 154      ;Matriz 14x11, logo, repete 154 vezes
    ESCOLHA_RANDOMIZER DW ?
    LINHA_CORD DW ?
    COLUNA_CORD DW ?

    ENC_AFUNDA DB 4
    FRAGATA_AFUNDA DB 3
    SUB_AFUNDA1 DB 2                ;Quantidade de cada navio para verificação de afundar, e ganhar.
    HIDRO_AFUNDA1 DB 4
    SUB_AFUNDA2 DB 2
    HIDRO_AFUNDA2 DB 4

;matriz principal(tela)
TABULEIRO_PRINCIPAL DW 32, 32, 32, 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 32
                    DW 32, 30H, 32, 10 DUP(30H), 32
                    DW 32, 31H, 32, 10 DUP(30H), 32
                    DW 32, 32H, 32, 10 DUP(30H), 32
                    DW 32, 33H, 32, 10 DUP(30H), 32
                    DW 32, 34H, 32, 10 DUP(30H), 32
                    DW 32, 35H, 32, 10 DUP(30H), 32
                    DW 32, 36H, 32, 10 DUP(30H), 32
                    DW 32, 37H, 32, 10 DUP(30H), 32
                    DW 32, 38H, 32, 10 DUP(30H), 32
                    DW 32, 39H, 32, 10 DUP(30H), 32

               ;TABULEIRO _VERDADE serve como um auxiliar, que pega a matriz aleatória escolhida pelo relógio
TABULEIRO_VERDADE  DW 32, 32, 32, 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 32
                   DW 32, 30H, 32, 10 DUP(0), 32
                   DW 32, 31H, 32, 10 DUP(0), 32
                   DW 32, 32H, 32, 10 DUP(0), 32
                   DW 32, 33H, 32, 10 DUP(0), 32
                   DW 32, 34H, 32, 10 DUP(0), 32
                   DW 32, 35H, 32, 10 DUP(0), 32
                   DW 32, 36H, 32, 10 DUP(0), 32
                   DW 32, 37H, 32, 10 DUP(0), 32
                   DW 32, 38H, 32, 10 DUP(0), 32
                   DW 32, 39H, 32, 10 DUP(0), 32

;Tabuleiros de 0 a 9 para escolha da matriz aleatória
TABULEIRO0    DW 32, 32, 32, 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 32
               DW 32, 30H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 31H, 32, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 32
               DW 32, 32H, 32, 0, 0, 0, 0, 0, 0, 2, 2, 2, 0, 32
               DW 32, 33H, 32, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 32
               DW 32, 34H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 35H, 32, 0, 0, 0, 0, 5, 5, 0, 6, 0, 0, 32
               DW 32, 36H, 32, 0, 0, 0, 0, 0, 0, 0, 6, 6, 0, 32
               DW 32, 37H, 32, 0, 0, 4, 0, 0, 0, 0, 6, 0, 0, 32
               DW 32, 38H, 32, 0, 0, 4, 4, 0, 0, 0, 0, 0, 0, 32
               DW 32, 39H, 32, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 32

TABULEIRO1    DW 32, 32, 32, 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 32
               DW 32, 30H, 32, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 32
               DW 32, 31H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 32H, 32, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 32
               DW 32, 33H, 32, 0, 5, 5, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 34H, 32, 0, 0, 0, 0, 3, 3, 0, 4, 0, 0, 32
               DW 32, 35H, 32, 0, 0, 0, 0, 0, 0, 0, 4, 4, 0, 32
               DW 32, 36H, 32, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 32
               DW 32, 37H, 32, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 38H, 32, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 39H, 32, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32

TABULEIRO2    DW 32, 32, 32, 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 32
               DW 32, 30H, 32, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 32
               DW 32, 31H, 32, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 32
               DW 32, 32H, 32, 0, 5, 5, 0, 0, 0, 0, 6, 6, 0, 32
               DW 32, 33H, 32, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 32
               DW 32, 34H, 32, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 35H, 32, 0, 4, 4, 4, 0, 0, 0, 0, 3, 3, 32
               DW 32, 36H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 37H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 38H, 32, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 32
               DW 32, 39H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32

TABULEIRO3    DW 32, 32, 32, 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 32
               DW 32, 30H, 32, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 32
               DW 32, 31H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 32H, 32, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 32
               DW 32, 33H, 32, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 32
               DW 32, 34H, 32, 0, 3, 3, 0, 0, 0, 0, 4, 4, 0, 32
               DW 32, 35H, 32, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 32
               DW 32, 36H, 32, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 37H, 32, 0, 0, 6, 6, 0, 5, 5, 0, 0, 0, 32
               DW 32, 38H, 32, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 39H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32

TABULEIRO4    DW 32, 32, 32, 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 32
               DW 32, 30H, 32, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 32
               DW 32, 31H, 32, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 32
               DW 32, 32H, 32, 0, 0, 0, 0, 0, 0, 0, 5, 5, 0, 32
               DW 32, 33H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 34H, 32, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 32
               DW 32, 35H, 32, 0, 0, 3, 3, 0, 0, 6, 6, 0, 0, 32
               DW 32, 36H, 32, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 32
               DW 32, 37H, 32, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 32
               DW 32, 38H, 32, 0, 0, 0, 0, 4, 4, 0, 0, 0, 0, 32
               DW 32, 39H, 32, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 32

TABULEIRO5    DW 32, 32, 32, 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 32
               DW 32, 30H, 32, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 31H, 32, 6, 6, 0, 0, 1, 1, 1, 1, 0, 0, 32
               DW 32, 32H, 32, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 33H, 32, 0, 0, 0, 3, 3, 0, 0, 2, 2, 2, 32
               DW 32, 34H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 35H, 32, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 32
               DW 32, 36H, 32, 0, 0, 0, 4, 4, 0, 0, 5, 5, 0, 32
               DW 32, 37H, 32, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 32
               DW 32, 38H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 39H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32

TABULEIRO6    DW 32, 32, 32, 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 32
               DW 32, 30H, 32, 0, 0, 1, 1, 1, 1, 0, 2, 2, 2, 32
               DW 32, 31H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 32H, 32, 0, 3, 3, 0, 0, 4, 0, 0, 0, 0, 32
               DW 32, 33H, 32, 0, 0, 0, 0, 0, 4, 4, 0, 0, 0, 32
               DW 32, 34H, 32, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 32
               DW 32, 35H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 36H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 37H, 32, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 32
               DW 32, 38H, 32, 0, 5, 5, 0, 0, 0, 0, 6, 6, 0, 32
               DW 32, 39H, 32, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 32

TABULEIRO7    DW 32, 32, 32, 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 32
               DW 32, 30H, 32, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 32
               DW 32, 31H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 32H, 32, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 32
               DW 32, 33H, 32, 0, 0, 0, 0, 0, 0, 4, 4, 0, 0, 32
               DW 32, 34H, 32, 6, 0, 0, 0, 0, 0, 4, 0, 0, 0, 32
               DW 32, 35H, 32, 6, 6, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 36H, 32, 6, 0, 0, 1, 1, 1, 1, 0, 0, 0, 32
               DW 32, 37H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 38H, 32, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 32
               DW 32, 39H, 32, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 32

TABULEIRO8    DW 32, 32, 32, 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 32
               DW 32, 30H, 32, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 32
               DW 32, 31H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 32H, 32, 0, 0, 0, 0, 4, 0, 0, 0, 2, 2, 32
               DW 32, 33H, 32, 0, 0, 0, 4, 4, 4, 0, 0, 0, 0, 32
               DW 32, 34H, 32, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 32
               DW 32, 35H, 32, 0, 0, 0, 0, 3, 3, 0, 6, 6, 0, 32
               DW 32, 36H, 32, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 32
               DW 32, 37H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 38H, 32, 0, 5, 5, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 39H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32

TABULEIRO9    DW 32, 32, 32, 30H, 31H, 32H, 33H, 34H, 35H, 36H, 37H, 38H, 39H, 32
               DW 32, 30H, 32, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 32
               DW 32, 31H, 32, 0, 0, 0, 0, 6, 6, 0, 0, 0, 0, 32
               DW 32, 32H, 32, 0, 0, 0, 0, 6, 0, 0, 0, 4, 0, 32
               DW 32, 33H, 32, 0, 5, 5, 0, 0, 0, 0, 0, 4, 4, 32
               DW 32, 34H, 32, 0, 0, 0, 0, 0, 3, 3, 0, 4, 0, 32
               DW 32, 35H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 36H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32
               DW 32, 37H, 32, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 32
               DW 32, 38H, 32, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 32
               DW 32, 39H, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32

.CODE
MAIN PROC
    MOV AX,@DATA    
    MOV DS,AX               ;Segmento de dados
    MOV ES,AX
    LIMPA_TELA
    IMPRIME MSG_INICIO
    IMPRIME MSG_INICIO2
    IMPRIME MSG_INICIO3
    IMPRIME MSG_INICIO4                 ;Apresentação inicial
    IMPRIME MSG_INICIO5
    IMPRIME MSG_INICIO6
    IMPRIME MSG1
    MOV AH,7            ;Tecla para ler, sem echo
    INT 21h
    CMP AL,'X'
    JE OUT_OF_RANGE              ;X como condição de saída
    CMP AL, 'x'
    JE OUT_OF_RANGE
    LIMPA_TELA

    CALL TABULEIRO_RANDOM       ;Chama o procedimento de randomizar a matriz
    APOS_TIRO:                  ;Apos o tiro, o processo se repete
    CALL PRINTA_MATRIZ          ;Printa a matriz

    CALL TIROS                  ;chama o procedimento para dar os tiros, na coluna e linha
    OUT_OF_RANGE:               ;Problema de out_of_range insistindo, entao tivemos de fazer isso
    CMP AL, 'X'     ;Se o usuário quiser sair ele digita x, quando for dar o tiro
    JE SAIDA_X
    CMP AL, 'x'
    JE SAIDA_X
    LIMPA_TELA      ;limpa a tela para mostrar a matriz novamente, e ver se acertou algo

    CALL CONFERE_TIROS      ;chama o procedimento confere tiros, para ver se foi na agua ou no barco

    CALL CONFERE_GANHOU     ;chama o procedimento confere ganhou, para ver se todos os barcos foram deletados
    OR CX,CX                ;CX como condição de CONFERE_GANHOU
    JNE SAIDA_FINAL         ;se foram, pula para o final

    JMP APOS_TIRO           ;senao, voltam para o ciclo

    SAIDA_FINAL:
    LIMPA_TELA
    IMPRIME VENCE           ;imprime tela "VENCEU" apos vencer
    MOV CX,10
    DAR_ESPAÇO:
    NOVA_LINHA
    LOOP DAR_ESPAÇO

    SAIDA_X:                ;saída final
    MOV AH,4Ch
    INT 21h
MAIN ENDP
TABULEIRO_RANDOM PROC
    CALL RANDOMIZER     ;chama o procedimento que randomiza a matriz
    MOV AX, ESCOLHA_RANDOMIZER

    CMP AX, 0           ;Pega o numero aleatório do randomizer e vai comparando para copiar para a matriz verdade
    JZ SE_0
    CMP AX, 1
    JE SE_1
    CMP AX, 2
    JE SE_2
    CMP AX, 3
    JE SE_3
    CMP AX, 4
    JE SE_4
    CMP AX, 5
    JE SE_5
    CMP AX, 6
    JE SE_6
    CMP AX, 7
    JE SE_7
    CMP AX, 8
    JE SE_8
    CMP AX, 9
    JE SE_9

    SE_0:
    MOV CX, NUM_MATRIZ            ;A função REP repete toda a matriz, e MOVSW move DW de SI para DI
    LEA SI, TABULEIRO0            ;MOVSW vai passando o valor de SI para DI e somando 2(DW) para fazer novamente
    LEA DI, TABULEIRO_VERDADE

    REP MOVSW
    JMP FIM_RANDOMIZER

SE_1:                               ;E vai passar a matriz aleatoria escolhida de 0 a 9 para o tabuleiro verdade
    MOV CX, NUM_MATRIZ
    LEA SI, TABULEIRO1
    LEA DI, TABULEIRO_VERDADE

    REP MOVSW
    JMP FIM_RANDOMIZER

SE_2:
    MOV CX, NUM_MATRIZ
    LEA SI, TABULEIRO2
    LEA DI, TABULEIRO_VERDADE

    REP MOVSW
    JMP FIM_RANDOMIZER

SE_3:
    MOV CX, NUM_MATRIZ
    LEA SI, TABULEIRO3
    LEA DI, TABULEIRO_VERDADE

    REP MOVSW
    JMP FIM_RANDOMIZER

SE_4:
    MOV CX, NUM_MATRIZ
    LEA SI, TABULEIRO4
    LEA DI, TABULEIRO_VERDADE

    REP MOVSW
    JMP FIM_RANDOMIZER
SE_5:
    MOV CX, NUM_MATRIZ
    LEA SI, TABULEIRO5
    LEA DI, TABULEIRO_VERDADE

    REP MOVSW
    JMP FIM_RANDOMIZER

SE_6:
    MOV CX, NUM_MATRIZ
    LEA SI, TABULEIRO6
    LEA DI, TABULEIRO_VERDADE

    REP MOVSW
    JMP FIM_RANDOMIZER

SE_7:
    MOV CX, NUM_MATRIZ
    LEA SI, TABULEIRO7
    LEA DI, TABULEIRO_VERDADE

    REP MOVSW
    JMP FIM_RANDOMIZER

SE_8:
    MOV CX, NUM_MATRIZ
    LEA SI, TABULEIRO8
    LEA DI, TABULEIRO_VERDADE

    REP MOVSW
    JMP FIM_RANDOMIZER

SE_9:
    MOV CX, NUM_MATRIZ
    LEA SI, TABULEIRO9
    LEA DI, TABULEIRO_VERDADE

    REP MOVSW

    FIM_RANDOMIZER:             ;Após as repetições de MOVSW, pula para o fim do randomizador
    RET
TABULEIRO_RANDOM ENDP
RANDOMIZER PROC
    MOV AH, 0H                     ;funcão para ler o tempo do relógio do sistema para DX
    INT 1AH

    MOV AX, DX                    ;passa para AX para poder fazer a divisao e passar o valor aleatório para DX
    MOV DX, 0                  
    MOV CX, 10                    ;Divide por 10 para ter o resto de 0 a 9
    DIV CX                        
    MOV ESCOLHA_RANDOMIZER, DX    ;O valor do resto é passado para um vetor, para poder fazer a escolha da matriz

    RET
RANDOMIZER ENDP
PRINTA_MATRIZ PROC
    NOVA_LINHA
    NOVA_LINHA
    XOR DX, DX
    XOR BX, BX          ;zera os valores para realizar o procedimento de printar a matriz
    XOR SI, SI
    MOV CX, NUM_MATRIZ  ;Loop de si

    MOSTRA_MATRIZ:
    MOV DX, TABULEIRO_PRINCIPAL[BX][SI]     ;move o valor para dx para conseguir imprimir

    MOV AH, 2               ;função imprimir
    INT 21H
    ESPACO                  ;macro de espaço para deixar visualmente melhor
    ADD SI, 2               ;DW, a soma é de 2 em 2

    CMP SI, 26              ;final da linha
    JA NEW_LINE             ;se for maior que o final, adiciona 28 em BX para nova linha da matriz

    LOOP MOSTRA_MATRIZ

    NEW_LINE:
    NOVA_LINHA
    ADD BX, 28              ;Adiciona em BX
    XOR SI, SI              ;Zera SI para refazer o loop da linha
    CMP BX, 306             ;Ultimo numero da matriz

    JA FIM_PRINT            ;se for maior que o ultimo numero da matriz, quer dizer que acabou
    JMP MOSTRA_MATRIZ       ;senao, volta para printar

    FIM_PRINT:
    RET
PRINTA_MATRIZ ENDP
TIROS PROC
    IMPRIME TIROC
    MOV AH, 01H                         ;Função caractere
    INT 21H
    CMP AL, 'X'                     ;Confere se o usuario quer sair
    JE FIM_RET
    CMP AL, 'x'
    JE FIM_RET

    CMP AL, "0"
    JL CORD_INV                     ;Coluna não pode ser menor q '0'
    CMP AL, "9"
    JG CORD_INV                     ;Nem maior que '9'

    AND AX, 0FH                        

    ADD AL, 3                 ;Começa na coluna [0,6]
    MOV BX, 2                 ;Multiplica (0+3)*2 para chegar no valor desejado da coluna
    MUL BX
    MOV COLUNA_CORD, AX      ;Passa para o vetor temporário COLUNA_CORD

    XOR AX, AX
    XOR BX, BX                 ;zera para pegar o valor da linha

    IMPRIME TIROL
    MOV AH, 01H                        
    INT 21h

    CMP AL, "0"
    JL CORD_INV                     ;Linha não pode ser menor q '0'
    CMP AL, "9"
    JG CORD_INV                     ;Nem maior que '9'

    AND AX,0FH
    ADD AL, 1                       ;Primeira Linha da matriz começa em [28,6]                          
                                   
    MOV BX, 28                      ;Então (0+1)*28 = 28, (1+1)*28 = 56, ...
    MUL BX                        
    MOV LINHA_CORD, AX      ;Passa para o vetor temporário LINHA_CORD
    JMP FIM_RET

    CORD_INV:
    IMPRIME CINVALIDA       ;Se for invalida, printa a mensagem
    JMP TIROS               ;volta para o começo do procedimento

    FIM_RET:
    RET
TIROS ENDP
CONFERE_TIROS PROC
    PUSH DI                 ;Salva a matriz em DI
    XOR DI,DI               ;zera para conferir os tiros
    MOV AX, LINHA_CORD      ;passa os valores da matriz para ax
    ADD AX, COLUNA_CORD    
         
    ADD SI, AX               ;valores da matriz sao passados para si e di para verificar os tiros
    ADD DI, AX
    MOV BX, TABULEIRO_VERDADE[DI]       ;passa o valor para BX
    MOV DX, TABULEIRO_PRINCIPAL[SI]     ;passa o valor para DX, para verificar se o ataque é repetido
    CMP DX,'W'                          ;Como W é water(agua) e o X é acerto em barco, quer dizer que a cordenada ja foi ativa
    JE JA_FOI
    CMP DX,'X'
    JE JA_FOI

    CMP BX,1                ;compara o valor da matriz em BX com o numero da embarcação
    JE ACERTOU
    CMP BX,2
    JE ACERTOU
    CMP BX,3
    JE ACERTOU
    CMP BX,4
    JE ACERTOU
    CMP BX,5
    JE ACERTOU
    CMP BX,6
    JE ACERTOU

    ACERTOU_AGUA:
    MOV TABULEIRO_PRINCIPAL[SI],'W'     ;se nao acertou nenhum numero, quer dizer que foi na agua
    IMPRIME AGUA_MSG
    JMP FINAL_CONFERE                   ;para de conferir

    ACERTOU:
    MOV TABULEIRO_PRINCIPAL[SI],'X'     ;se acertou, "X" vai para a matriz principal
    IMPRIME ACERTOU_MSG


    CALL AFUNDOU_CONFERE                ;chama o procedimento para verificar se afundou
    JMP FINAL_CONFERE                   ;pula para o final do procedimento, por conta de JA_FOI:

    JA_FOI:
    IMPRIME CJAFOI
    FINAL_CONFERE:
    POP DI                  ;recupera DI
    RET
CONFERE_TIROS ENDP
AFUNDOU_CONFERE PROC
    XOR AX,AX               ;Zera AX para pegar novamente o valor da matriz
    PUSH DI    
    XOR DI,DI
    MOV AX, LINHA_CORD         ;passa novamente os valores da matriz
    ADD AX, COLUNA_CORD

    XOR BX, BX
    ADD DI, AX                  ;passa para BX, o valor da matriz principal
    MOV BX, TABULEIRO_VERDADE[DI]
 
    CMP BX, 1
    JE SUB_AFUNDA_1
    CMP BX, 2
    JE SUB_AFUNDA_2
    CMP BX, 3                       ;se for embarcação, da o JE
    JE SUB_AFUNDA_3
    CMP BX, 4
    JE SUB_AFUNDA_4
    CMP BX, 5
    JE SUB_AFUNDA_5
    CMP BX, 6
    JE SUB_AFUNDA_6

    JMP FIM_AFUNDA
    SUB_AFUNDA_1:
     JMP AFUNDA_1
    SUB_AFUNDA_2:                   ;Problema de Out of range resultou nisso
     JMP AFUNDA_2
    SUB_AFUNDA_3:
     JMP AFUNDA_3
    SUB_AFUNDA_4:
     JMP AFUNDA_4
    SUB_AFUNDA_5:
     JMP AFUNDA_5
    SUB_AFUNDA_6:
     JMP AFUNDA_6

    AFUNDA_1:
    DEC ENC_AFUNDA
    CMP ENC_AFUNDA,0
    JE IMPRIME_ENC_MSG              ;AFUNDA decrementa do vetor, e compara com 0, se for maior que 0, ainda tem embarcação do tipo envolvido
    JMP FIM_AFUNDA                  ;como nesse exemplo, o encouraçado
    IMPRIME_ENC_MSG:
    IMPRIME ENC_MSG
    JMP FIM_AFUNDA                  ;JMP para nao ver as outras funções de afundamento

    AFUNDA_2:
    DEC FRAGATA_AFUNDA
    CMP FRAGATA_AFUNDA,0
    JE IMPRIME_FRAGATA_MSG
    JMP FIM_AFUNDA
    IMPRIME_FRAGATA_MSG:
    IMPRIME FRAGATA_MSG
    JMP FIM_AFUNDA

    AFUNDA_3:
    DEC SUB_AFUNDA1
    CMP SUB_AFUNDA1,0
    JE IMPRIME_SUB1_MSG
    JMP FIM_AFUNDA
    IMPRIME_SUB1_MSG:
    IMPRIME SUB_MSG
    JMP FIM_AFUNDA

    AFUNDA_4:
    DEC HIDRO_AFUNDA1
    CMP HIDRO_AFUNDA1,0
    JE IMRPIME_HIDRO1_MSG
    JMP FIM_AFUNDA
    IMRPIME_HIDRO1_MSG:
    IMPRIME HIDRO_MSG
    JMP FIM_AFUNDA

    AFUNDA_5:
    DEC SUB_AFUNDA2
    CMP SUB_AFUNDA2,0
    JE IMPRIME_SUB2_MSG
    JMP FIM_AFUNDA
    IMPRIME_SUB2_MSG:
    IMPRIME SUB_MSG
    JMP FIM_AFUNDA

    AFUNDA_6:
    DEC HIDRO_AFUNDA2
    CMP HIDRO_AFUNDA2,0
    JE IMPRIME_HIDRO2_MSG
    JMP FIM_AFUNDA
    IMPRIME_HIDRO2_MSG:
    IMPRIME HIDRO_MSG

    FIM_AFUNDA:         ;Fim do procedimento

    POP DI
    RET
AFUNDOU_CONFERE ENDP
CONFERE_GANHOU PROC
    XOR CX,CX           ;CX vai funcionar como condição, se for 1 ao incrementar, voce ganhou
    CMP ENC_AFUNDA,0    ;compara com 0 para ver se ja foi afundado
    JNE NAO_GANHOU      ;se nao foi, ja pula para nao ganhou
    JMP PROXIMO_1       ;se ja foi, vai para o proximo
    PROXIMO_1:
    CMP FRAGATA_AFUNDA,0    ;assim vai seguindo ate todos serem afundados e todas as condições forem verdadeira
    JNE NAO_GANHOU
    JMP PROXIMO_2
    PROXIMO_2:
    CMP SUB_AFUNDA1,0
    JNE NAO_GANHOU
    JMP PROXIMO_3
    PROXIMO_3:
    CMP HIDRO_AFUNDA1,0
    JNE NAO_GANHOU
    JMP PROXIMO_4
    PROXIMO_4:
    CMP SUB_AFUNDA2,0
    JNE NAO_GANHOU
    JMP PROXIMO_5
    PROXIMO_5:
    CMP HIDRO_AFUNDA2,0
    JNE NAO_GANHOU


    INC CX          ;então, CX é incrementado como condição de vitoria
    NAO_GANHOU:     ;pulo para caso nao tenha afundado tudo ainda
    RET
CONFERE_GANHOU ENDP
END MAIN