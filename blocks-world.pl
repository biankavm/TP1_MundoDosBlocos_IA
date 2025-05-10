% Planner com blocos de largura variável

% Planner com busca em profundidade iterativa
plan(State, Goals, []) :-
    satisfied(State, Goals).

plan(State, Goals, Plan) :-
    append(PrePlan, [Action], Plan),
    select(State, Goals, Goal),
    achieves(Action, Goal),
    can(Action, Conditions),
    preserves(Action, Goals),
    regress(Goals, Action, RegressedGoals),
    plan(State, RegressedGoals, PrePlan).

% Verifica se todos os objetivos estão satisfeitos no estado atual
satisfied(State, Goals) :-
    subset(Goals, State).

% Seleciona um objetivo da lista (simples seleção do primeiro)
select(_, Goals, Goal) :-
    member(Goal, Goals).

% Verifica se uma ação contribui para algum objetivo
achieves(Action, Goal) :-
    adds(Action, AddList),
    member(Goal, AddList).

% Verifica se uma ação não prejudica os objetivos atuais
preserves(Action, Goals) :-
    deletes(Action, DelList),
    \+ (member(Del, DelList), member(Del, Goals)).

% Realiza a regressão dos objetivos através de uma ação
regress(Goals, Action, RegressedGoals) :-
    adds(Action, AddList),
    subtract(Goals, AddList, RestGoals),
    can(Action, Conditions),
    add_conditions(Conditions, RestGoals, RegressedGoals).

% Adiciona condições sem conflitos
add_conditions([], Goals, Goals).
add_conditions([Cond|T], Goals, NewGoals) :-
    \+ (impossible(Cond, Goals)),
    \+ member(Cond, Goals),
    add_conditions(T, [Cond|Goals], NewGoals), !.
add_conditions([_|T], Goals, NewGoals) :-
    add_conditions(T, Goals, NewGoals).

% Verifica se um objetivo é impossível dado os objetivos atuais
impossible(on(X,X), _).
impossible(on(X,Y), Goals) :-
    (member(clear(Y), Goals) ; 
     member(on(X,Y1), Goals), Y1 \== Y ; 
     member(on(X1,Y), Goals), X1 \== X).
impossible(clear(X), Goals) :-
    (block(X, Width) -> 
        (member(on(X, Pos), Goals) -> true ; Pos = 0), % Obtém a posição do bloco
        covered_positions(Pos, Width, Covered),
        member(P, Covered),
        member(on(_, P), Goals)
    ;   member(on(_, X), Goals)
    ).

% Calcula as posições cobertas por um bloco
covered_positions(Pos, Width, Covered) :-
    integer(Pos), % Garante que Pos seja um número
    Width > 0,
    MaxI is Width - 1,
    findall(P, (between(0, MaxI, I), P is Pos + I), Covered).

% Definições de ações
can(move(Block, From, To), [clear(Block), clear(To), on(Block, From)]) :-
    block(Block, _),
    object(To),
    To \== Block,
    object(From),
    From \== To,
    Block \== From.

adds(move(X, From, To), [on(X, To), clear(From)]).
deletes(move(X, From, To), [on(X, From), clear(To)]).

% Objetos do mundo
object(X) :- place(X) ; block(X, _).

place(0).
place(1).
place(2).
place(3).
place(4).
place(5).
place(6).

block(a, 1).
block(b, 1).
block(c, 2).
block(d, 3).
