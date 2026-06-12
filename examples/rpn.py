"""RPN - Reverse Polish Notation

Avalia expressões em Notação Polonesa Reversa (RPN).
"""

def evaluate_rpn(expression):
    """
    Avalia uma expressão em Notação Polonesa Reversa (RPN).
    :param expression: String contendo a expressão RPN separada por espaços.
    :return: Resultado da avaliação da expressão.
    """
    stack = []
    tokens = expression.split()

    for token in tokens:
        if token.isdigit() or (token[1:].isdigit() and token[0] == '-'):  # Verifica números inteiros e negativos
            stack.append(int(token))
        else:
            try:
                b = stack.pop()
                a = stack.pop()

                if token == '+':
                    stack.append(a + b)
                elif token == '-':
                    stack.append(a - b)
                elif token == '*':
                    stack.append(a * b)
                elif token == '/':
                    stack.append(a / b)  # Resultado será float
                else:
                    raise ValueError(f"Operador inválido: {token}")
            except IndexError:
                raise ValueError("Erro na expressão: operandos insuficientes")

    if len(stack) != 1:
        raise ValueError("Erro na expressão: operandos restantes na pilha")

    return stack[0]

if __name__ == "__main__":

    expressions = [
        "0",
        "1",
        "12",
        "123",
        "1234",
        "32767",
        "2 3 +",
        "4321 1234 -",
        "6 8 *",
        "96 24 /",
        "101 102 + 103 + 104 + 105 + 106 + 107 + 108 + 109 + 110 +",
        "1001 10002 103 104 105 106 107 108 109 110 + + + + + + + + +",
        "5 1 2 + 4 * + 3 - 6 2 / 8 + *",
        "100 5 / 20 3 * +",
        "100 5 / 20 3 * + 50 2 - 4 / *",
        "15 7 1 1 + - / 3 * 2 1 1 + + -",
        "12 3 / 4 5 * - 6 2 / + 10 - 8 4 / -",
        "10 11 -",
    ]

    for expression in expressions:
        print(f"Expressão: {expression}")
        try:
            resultado = evaluate_rpn(expression)
            print(f"Resultado (dec): {resultado}")
            if resultado < 0:
                resultado_hex = f"{(int(resultado) + (1 << 16)) & 0xFFFF:04X}"
            else:
                resultado_hex = f"{int(resultado):04X}"
            print(f"Resultado (hex): {resultado_hex}\n")
        except ValueError as e:
            print(f"Erro: {e}\n")