; Símbolos exportados
> SUB_PUSH  ; Subrotina de PUSH na pilha
> SUB_POP   ; Subrotina de POP da pilha
> PUSH_ARG      ; Endereço do argumento de PUSH
> POP_RESULT    ; Endereço do resultado de POP


@ /500
SUB_PUSH    K =0    
            JP START1
PUSH_ARG    K /0000
ERRO1       HM ERRO1

START1      LV /123
            LD STACK_POINTER 
            SB PUSH_MAX 
            JZ ERRO1 
            AD PUSH_MAX
            SB DOIS 
            MM STACK_POINTER 
            AD MEMORY_MOVE
            MM SALVA 
            LD PUSH_ARG
SALVA        K /0000
            RS SUB_PUSH

@ /700
SUB_POP     K =0    
            JP START2
POP_RESULT  K /0000
ERRO2       HM ERRO2

START2      LV /123
            LD STACK_POINTER
            SB POP_MAX 
            JZ ERRO2 
            AD POP_MAX
            AD LOAD 
            MM SALVA1
SALVA1       K =0
            MM POP_RESULT 
            LD STACK_POINTER 
            AD DOIS 
            MM STACK_POINTER
            RS SUB_POP

DOIS         K /0002
MEMORY_MOVE K /9000
LOAD        K /8000
PUSH_MAX    K /0F00
POP_MAX     K /0FFE



@ /FFE
STACK_POINTER   K STACK_POINTER