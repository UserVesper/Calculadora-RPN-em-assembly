; Símbolos exportados
> SUB_LE_BYTE       ; Subrotina de leitura de um único byte do disco
> LE_BYTE_ARG       ; Endereço do argumento da subrotina
> LE_BYTE_RESULT    ; Endereço do resultado da subrotina


@ /300
SUB_LE_BYTE     K =0    ; Entrada da subrotina
                JP START
LE_BYTE_RESULT  K /0000 ; Resultado da subrotina
LE_BYTE_ARG     K /0000 ; Por padrão, lê do disco zero


OP_LEITURA  GD /300     ; Instrução de leitura do disco 0 (usaremos para construir a instrução completa)


DADO_TEMP   K /0000
CENTENA      K /0100
MENOR       K /0000
MAIOR       K /0000
CONTADOR    K /0001
CONST1         K /0001; lebyte

NEXT        LD CONTADOR
            AD CONST1
            MM CONTADOR

            LD MENOR
            ML CENTENA  
            MM MAIOR

            LD DADO_TEMP
            SB MAIOR
            JP END


START       LD CONTADOR
            JZ NEXT

            LD OP_LEITURA
            AD LE_BYTE_ARG
            MM INSTRUCAO

INSTRUCAO   K =0
            MM DADO_TEMP
            DV CENTENA  
            JZ END

            MM MENOR

            LD CONTADOR
            SB CONST1
            MM CONTADOR

            LD MENOR
            JP END


END         MM LE_BYTE_RESULT
            RS SUB_LE_BYTE