[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/BFiToOGQ)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=18724063&assignment_repo_type=AssignmentRepo)

# Calculadora RPN

Neste projeto, vamos implementar uma calculadora de expressões aritméticas
em **Notação Polonesa Reversa (Reverse Polish Notation - RPN)**.

## Objetivo

Construir um programa para a MVN que implementa uma
calculadora que lê expressões aritméticas em RPN do Disco 0
e armazena seu resultado em um endereço específico da memória.

## Definições

A **RPN** é uma forma de escrever expressões matemáticas em que os operadores vêm **depois** dos operandos, eliminando a necessidade de parênteses para indicar a precedência das operações.

Na RPN, as expressões são avaliadas usando uma **pilha (stack)**. Os números são colocados na pilha à medida que aparecem e, quando um operador é encontrado, ele opera sobre os últimos valores inseridos.

### Exemplo 1: Expressão Infixa → RPN

Considere a expressão tradicional (**infixa**):

```
3 + 4
```

Em **notação polonesa reversa**, fica:

```
3 4 +
```

**Passo a passo de execução usando uma pilha**:

1. Insere `3` na pilha → `[3]`
2. Insere `4` na pilha → `[3, 4]`
3. Encontra `+`, remove os dois últimos números (`3` e `4`), soma e coloca o resultado na pilha → `[7]`

Resultado final: **7**

### Exemplo 2: Expressão com Múltiplos Operadores

Para a expressão infixa:

```
(6 - 2) * (8 + 3)
```

A conversão para **RPN**:

```
6 2 - 8 3 + *
```

**Passo a passo**:

1. `6` e `2` na pilha → `[6, 2]`
2. `-` remove `6` e `2`, calcula `6 - 2 = 4` → `[4]`
3. `8` e `3` na pilha → `[4, 8, 3]`
4. `+` remove `8` e `3`, calcula `8 + 3 = 11` → `[4, 11]`
5. `*` remove `4` e `11`, calcula `4 * 11 = 44` → `[44]`

Resultado final: **44**

### Vantagens da RPN

1. **Elimina ambiguidade** – Parênteses não são necessários, pois a ordem de avaliação é definida pela posição dos operadores.
2. **Fácil de processar** – É ideal para implementação em calculadoras e compiladores, pois a pilha gerencia a ordem de execução.
3. **Evita erros comuns de precedência** – Não há necessidade de seguir regras complicadas como na notação infixa.

### Onde a RPN é usada?

- Calculadoras HP programáveis (muito populares entre engenheiros e matemáticos).
- Linguagens de programação como **PostScript e Forth**.
- Implementação de expressões em compiladores.

A notação polonesa reversa pode parecer estranha à primeira vista, mas depois de um pouco de prática, se torna intuitiva e eficiente!

## Entregáveis

Sua pasta `submission/` já contém um arquivo `main.asm` que chama a subrotina de cálculo da expressão RPN.
**Este arquivo NÃO deverá ser modificado!**

Além disso, a pasta deve conter também os seguintes arquivos:

### 1. `le_byte.asm`

Como a instrução `GD` lê uma palavra do disco, (i.e., _dois_ bytes),
é necessário separar os bytes lidos para poder tratá-los individualmente. Neste arquivo, você deve:

- Implementar e exportar a subrotina `SUB_LE_BYTE`, que retorna um único byte lido do disco.
  - Na primeira vez em que a subrotina é chamada, ela lê dois bytes do disco e retorna o primeiro (i.e., o byte mais à esquerda).
  - Na segunda vez, ela deve retornar o byte seguinte lido anteriormente (i.e., o byte mais à direita).
  - Repetir quantas vezes necessário.
- Caso os dados do disco terminem (ex., você já leu todo o conteúdo de um arquivo txt), a instrução `GD` retornará um byte nulo (0x00), e a subrotina também.
- A subrotina retorna seu resultado em um endereço de memória específico (ver tabela abaixo).
- A subrotina aceita um parâmetro opcional que define o identificador do disco a ser lido.
  - Exemplo: se o parâmetro tiver valor "0001", será lido o disco 1 através da instrução `GD /301`.
  - Por padrão, a subrotina lerá dados do disco 0.
  - Este parâmetro também tem um endereço específico (ver tabela).
  - Obs: Isto já está implementado no código fornecido e você pode utilizar para facilitar em seus testes.

### 2. `pilha.asm`

Vamos implementar uma pilha com duas operações:
**PUSH**, que adiciona um valor à pilha, e **POP**, que remove o valor no topo da pilha e o retorna.

Para armazenar os valores da pilha, vamos utilizar a região final da memória da seguinte maneira:

- O último endereço (0xFFE) é o **stack pointer**, que armazena o endereço do topo da pilha.
- Os endereços anteriores armazenam o conteúdo da pilha, por exemplo:

```
0FF6 0004 ; Topo da pilha - último item inserido
0FF8 0003
0FFA 0002
0FFC 0001 ; Primeiro item da pilha (primeiro item que foi inserido)
0FFE 0FF6 ; Stack pointer: contém o endereço do topo da pilha
```

A partir do estado acima, uma chamada a `POP` retornaria o valor 0x0004 atualizaria o stack pointer para 0x0FF8,
mas uma chamada a `PUSH` adicionaria um novo valor no endereço 0x0FF4 e atualizaria o stack pointer também para 0x0FF4.
Observe que, em caso de pilha vazia, o stack pointer referencia a si mesmo (0x0FFE).

Neste arquivo, você deve:

- Implementar e exportar uma subrotina `SUB_PUSH`, que adiciona um valor à pilha.
  - Este valor é recebido como parâmetro em um endereço de memória específico (ver tabela abaixo).
- Implementar e exportar uma subrotina `SUB_POP`, que remove o valor do topo da pilha e o retorna.
  - O resultado é retornado em um endereço de memória específico (ver tabela abaixo).
- O tamanho máximo da pilha é de 127 itens (isto é, o último endereço de memória que você pode utilizar é 0xF00).
- Em caso de pilha lotada na subrotina `SUB_PUSH`, seu programa deve dar jump para um endereço específico, de acordo com a tabela abaixo.
- Em caso de pilha vazia na subrotina `SUB_POP`, seu programa deve dar jump para um endereço específico, de acordo com a tabela abaixo.
- Ao remover um item da pilha, não é necessário limpar a memória, basta atualizar o stack pointer.

### 3. `rpn.asm`

Neste arquivo, você deve:

- Implementar e exportar a subrotina `SUB_RPN`, que será chamada pelo programa principal.
- O resultado final da expressão deve ser retornado em uma posição de memória específica (ver tabela abaixo).
  - Para expressões RPN válidas, a pilha conterá um único valor ao final da execução. Este valor é o resultado final da expressão aritmética.
- Você pode e deve utilizar as subrotinas auxiliares da pilha e de leitura do disco.
- Você **NÃO** precisa validar as expressões RPN. Assuma que receberá apenas expressões válidas.
  - Como desafio valendo um ponto extra, você pode implementar essa validação. Neste caso, seu programa deve dar jump para um endereço específico, de acordo com a tabela abaixo.

### Endereços de memória relevantes

| Endereço        | Rótulo           | Descrição                                                                    |
| --------------- | ---------------- | ---------------------------------------------------------------------------- |
| 0x0000 a 0x02FF | -                | Memória reservada, proibido utilizar                                         |
| 0x0300          | `SUB_LE_BYTE`    | Entrada da subrotina `SUB_LE_BYTE`. Pode ser chamada com "SC /300" ou "A300" |
| 0x0304          | `LE_BYTE_RESULT` | Endereço de armazenamento do resultado da subrotina `SUB_LE_BYTE`            |
| 0x0306          | `LE_BYTE_ARG`    | Endereço de armazenamento do argumento opcional da subrotina `SUB_LE_BYTE`   |
| 0x0500          | `SUB_PUSH`       | Entrada da subrotina `SUB_PUSH`. Pode ser chamada com "SC /500" ou "A500"    |
| 0x0504          | `PUSH_ARG`       | Endereço de armazenamento do argumento da subrotina `SUB_PUSH`               |
| 0x0506          | -                | Endereço de parada em caso de erro na subrotina `SUB_PUSH`                   |
| 0x0700          | `SUB_POP`        | Entrada da subrotina `SUB_POP`. Pode ser chamada com "SC /700" ou "A700"     |
| 0x0704          | `POP_RESULT`     | Endereço de armazenamento do resultado da subrotina `SUB_POP`                |
| 0x0706          | -                | Endereço de parada em caso de erro na subrotina `SUB_POP`                    |
| 0x0900          | `SUB_RPN`        | Entrada da subrotina `SUB_RPN`. Pode ser chamada com "SC /900" ou "A900"     |
| 0x0904          | `RPN_RESULT`     | Endereço de armazenamento do resultado da subrotina `SUB_RPN`                |
| 0x0906          | -                | Endereço de parada em caso de erro na subrotina `SUB_RPN`                    |
| 0x0F00 a 0x0FFD | -                | Memória reservada para o conteúdo da pilha                                   |
| 0x0FFE          | `STACK_POINTER`  | Endereço de memória onde armazenamos o endereço atual do topo da pilha       |

## Outras informações

- Os números estão em decimal, mas internamente você trabalhará com base hexadecimal.
  - Exemplo: a expressão "8 2 +" resulta no valor decimal "10", e seu programa deverá conter o valor 0x000A no endereço especificado.
- Os números podem ter quantidades arbitrárias de dígitos.
  - Você não precisa se preocupar com overflow (números grandes demais).
  - Em nossos testes, o maior valor possível será 32767 = 0x7FFF.
- Os números das expressões serão sempre **positivos**, mas o resultado final poderá ser negativo.
  - Números negativos serão expressos em complemento de 2.
  - Exemplo: a expressão "10 11 -" resulta em -1 e seu programa deverá conter 0xFFFF no endereço especificado.
- As operações aritméticas e seus operadores são: adição ("`+`"), subtração ("`-`"), multiplicação ("`*`") e divisão ("`/`").
- Os números e operadores aritméticos **sempre** serão separados por um ou mais espaços.
- O final da expressão é denotado pelo caracter nulo (0x00) ou quebra de linha (0x0A).

## Pontuação

1. `le_byte.asm`: 1 ponto.
1. `pilha.asm`: 3 pontos.
   1. `SUB_PUSH`: 1 ponto.
   1. `SUB_POP`: 1 ponto.
   1. `SUB_PUSH` e `SUB_POP` integradas: 1 ponto.
1. `rpn.asm`: 5 pontos.
   1. Leitura de números: 2 pontos.
      - Exemplo: execução de expressões simples RPN como "8", "123" e "32767".
   1. Execução completa: 3 pontos.
1. Tratamento de erros: 1 ponto + 1 ponto extra.
   1. Pilha vazia: 0,5 ponto.
   1. Pilha cheia: 0,5 ponto.
   1. (Opcional) Expressão RPN inválida: 1 ponto extra.

## Exemplos

O diretório `examples/` contém arquivos de texto com expressões RPN válidas que você pode utilizar para testar seu programa. O diretório raiz também contém um arquivo `disp.lst` declarando dispositivos de I/O para o simulador MVN.

É fornecido também um script Python de exemplo de implementação de calculadora RPN.
Você pode utilizá-lo como referência em seu projeto.
Execute-o através do comando:

```
python examples/rpn.py
```

## Run

Um Makefile foi fornecido para ajudar nos seus testes.

```
make        # Cria o arquivo submission/program.mvn a partir dos .asm
make clean  # Para limpar sua pasta submission/
```
