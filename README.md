# Primeiro Trabalho de IA - Mundo dos Blocos

Integrantes:
- Bianka Vasconcelos
- Micael Viana
- Vinícius Chagas

### Contexto
Neste trabalho desenvolvemos um programa em Prolog que resolve o novo problema do Mundo dos Blocos, com os blocos tendo largura variável e altura fixa igual a 1. Usamos como base o livro do Bratko na sua seção 17.6, com o código do means-end e goal regression.

## Arquivo Principal

- **blocks_world.pl**: contém toda a lógica do planner (representação do conhecimento, regras de regressão, pré-condições, efeitos e domínio dos blocos).

## Pré-requisitos

- SWI-Prolog (versão 8.x ou superior)

## Como Executar

1. Abra o SWI-Prolog no terminal.  
2. Carregue o arquivo:  
   ```prolog
   ?- [blocks_world].
3. Defina o estado inicial e os objetivos, por exemplo:
```
plan([on(c,0), on(a,3), on(b,5), on(d,a)], [on(c,0), on(d,2), on(b,5), on(a,c)], P).
```
4. O planner retornará P, a lista de ações necessárias para atingir os objetivos.

## Estrutura do Código

1. Planejamento por Regressão de Objetivos

    - `plan(State, Goals, Plan)`: implementa o processo de regressão com caso base e recursão.

    - `satisfied/2`: verifica se todos os objetivos estão satisfeitos no estado atual.

    - `select/3`: escolhe um objetivo remanescente para regressão.

    - `achieves/2`: testa se uma ação alcança um dos objetivos.

    - `preserves/2`: garante que a ação não destrua objetivos ainda pendentes.

    - `regress/3`: remove efeitos positivos já satisfeitos e adiciona as pré-condições da ação.

2. Tratamento de Condições

    - `add_conditions/3`: agrega pré-condições sem gerar conflitos.

    - `impossible/2`: detecta condições que não podem coexistir baseado em ocupação de células e metas atuais.

3. Ações de Movimento

    - `can/2`: verifica todas as células que o bloco ocupará e se o bloco está na posição de origem.

    - `adds/2`: efeitos positivos de move/3 (on/2 e clear/1).

    - `deletes/2`: efeitos negativos de move/3 (on/2 e clear/1).

4. Representação do Mundo

    - `covered_positions/3`: gera o intervalo de células ocupadas por um bloco conforme sua largura.

    - `object/1`: identifica lugares e blocos.

    - `place/1`: domínio de posições válidas na mesa (0…6).

    - `block/2`: especifica a largura de cada bloco.

## Considerações Importantes

O planner atual utiliza DFS sem poda de estados repetidos e pode gerar planos inválidos.

**Melhorias sugeridas**:

1. Em vez de ficar recuando sem parar, poderíamos fazer busca pra frente, guardando cada configuração de on/2 num hash e pulando estados que já vimos.

2. Criar uma heurística que some quantos blocos estão fora do lugar e a distância (em células) que cada um precisa percorrer, trocando o DFS por A* para garantir o menor número de movimentos.

3. Usar CLP(FD): modelar cada bloco como variável com domínio 0…MaxX-Width e deixar o solver propagar automaticamente as restrições de não-sobreposição, evitando caminhos inválidos desde o início.
























