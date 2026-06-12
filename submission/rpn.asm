; Símbolos exportados
> SUB_RPN       ; Subrotina de cálculo da expressão RPN
> RPN_RESULT    ; Endereço do resultado de RPN

; Símbolos importados
< SUB_PUSH
< SUB_POP
< SUB_LE_BYTE
< PUSH_ARG
< POP_RESULT
< LE_BYTE_ARG
< LE_BYTE_RESULT

@ /900
SUB_RPN       K =0
              JP INICIO
RPN_RESULT    K /1234
ERRO          HM ERRO

; Variáveis
TEMP_VAL      K /0000
BYTE_LIDO     K /0000
PILHA_TAM     K /0000
NUM_OPERANDOS K /0000
DIGITO_LIDO   K /0000
NUM_FINAL     K /0000
SOMA          K /002B
SUBTRACAO     K /002D
MULTIPLICACAO K /002A
DIVISAO       K /002F
ESPACO        K /0020
DEZ           K /000A
UM            K /0001
ASCII_ZERO    K /0030
CONTROLE      K /0001

SOMA_OP       SC SUB_POP
              LD PILHA_TAM
              SB UM
              MM PILHA_TAM
              LD POP_RESULT
              MM TEMP_VAL

              SC SUB_POP
              LD PILHA_TAM
              SB UM
              MM PILHA_TAM
              LD POP_RESULT
              AD TEMP_VAL
              MM PUSH_ARG
              SC SUB_PUSH
              LD PILHA_TAM
              AD UM
              MM PILHA_TAM

              LD CONTROLE
              SB UM
              MM CONTROLE
              LD NUM_OPERANDOS
              AD UM
              MM NUM_OPERANDOS
              JP INICIO

SUBTRACAO_OP  SC SUB_POP
              LD PILHA_TAM
              SB UM
              MM PILHA_TAM
              LD POP_RESULT
              MM TEMP_VAL

              SC SUB_POP
              LD PILHA_TAM
              SB UM
              MM PILHA_TAM
              LD POP_RESULT
              SB TEMP_VAL
              MM PUSH_ARG
              SC SUB_PUSH
              LD PILHA_TAM
              AD UM
              MM PILHA_TAM

              LD CONTROLE
              SB UM
              MM CONTROLE
              LD NUM_OPERANDOS
              AD UM
              MM NUM_OPERANDOS
              JP INICIO

MULT_OP       SC SUB_POP
              LD PILHA_TAM
              SB UM
              MM PILHA_TAM
              LD POP_RESULT
              MM TEMP_VAL

              SC SUB_POP
              LD PILHA_TAM
              SB UM
              MM PILHA_TAM
              LD POP_RESULT
              ML TEMP_VAL
              MM PUSH_ARG
              SC SUB_PUSH
              LD PILHA_TAM
              AD UM
              MM PILHA_TAM

              LD CONTROLE
              SB UM
              MM CONTROLE
              LD NUM_OPERANDOS
              AD UM
              MM NUM_OPERANDOS
              JP INICIO

DIV_OP        SC SUB_POP
              LD PILHA_TAM
              SB UM
              MM PILHA_TAM
              LD POP_RESULT
              MM TEMP_VAL

              SC SUB_POP
              LD PILHA_TAM
              SB UM
              MM PILHA_TAM
              LD POP_RESULT
              DV TEMP_VAL
              MM PUSH_ARG
              SC SUB_PUSH
              LD PILHA_TAM
              AD UM
              MM PILHA_TAM

              LD CONTROLE
              SB UM
              MM CONTROLE
              LD NUM_OPERANDOS
              AD UM
              MM NUM_OPERANDOS
              JP INICIO

CHECK1        LD NUM_OPERANDOS
              JZ CHECK4

              LD BYTE_LIDO
              SB ASCII_ZERO
              JN CHECK5
              JP ERRO

CHECK2        LD CONTROLE
              JZ CHECK3

              LD NUM_FINAL
              MM PUSH_ARG
              SC SUB_PUSH
              LD PILHA_TAM
              AD UM
              MM PILHA_TAM
              JP INICIO

CHECK3        AD UM
              MM CONTROLE
              JP INICIO

CHECK4        LD NUM_FINAL
              MM RPN_RESULT
              LD PILHA_TAM
              JZ FIM
              JP ERRO

CHECK5        SC SUB_POP
              LD POP_RESULT
              MM RPN_RESULT
              LD PILHA_TAM
              SB UM
              JZ FIM
              JP ERRO

; Início da subrotina

INICIO        LV /123
              LV /0000
              MM NUM_FINAL

LEITURA       SC SUB_LE_BYTE
              LD LE_BYTE_RESULT
              JZ CHECK1
              SB DEZ
              JZ CHECK1
              AD DEZ
              SB ESPACO
              JZ CHECK2
              AD ESPACO

              LD LE_BYTE_RESULT
              MM BYTE_LIDO

              SB SOMA
              JZ SOMA_OP
              AD SOMA
              SB SUBTRACAO
              JZ SUBTRACAO_OP
              AD SUBTRACAO
              SB MULTIPLICACAO
              JZ MULT_OP
              AD MULTIPLICACAO
              SB DIVISAO
              JZ DIV_OP
              AD DIVISAO

              SB ASCII_ZERO
              MM DIGITO_LIDO
              LD NUM_FINAL
              ML DEZ
              AD DIGITO_LIDO
              MM NUM_FINAL
              JP LEITURA

FIM           RS SUB_RPN