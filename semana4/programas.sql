-- 1. Criar procedure insere_projeto

CREATE OR REPLACE PROCEDURE brh.insere_projeto 
(
      p_NOME IN BRH.PROJETO.NOME%type
    , p_RESPONSAVEL IN BRH.PROJETO.RESPONSAVEL%type
    , p_INICIO IN BRH.PROJETO.INICIO%type
    , p_FIM IN BRH.PROJETO.FIM%type
) 
IS
BEGIN
INSERT INTO BRH.PROJETO 
    (
        NOME
      , RESPONSAVEL
      , INICIO
     ) 
VALUES 
    (
       upper (p_NOME)
     , upper (p_RESPONSAVEL)
     , p_INICIO
    );
END;

-- EXECUTANDO EM SQL
EXECUTE brh.insere_projeto ('middle earth', 'w123', '15/09/2022');

--EXECUTANDO EM PL-SQL
BEGIN
        brh.insere_projeto ('valinor', 'l123', '02/10/2022');
END;

SELECT * FROM brh.projeto;


-- 2. Criar função calcula_idade sem considerar erro (Ver tarefa 6)

CREATE OR REPLACE FUNCTION brh.calcula_idade
(p_data_referencia IN DATE)
RETURN NUMBER
IS
v_idade NUMBER;
BEGIN
       v_idade := TRUNC(MONTHS_BETWEEN(sysdate, p_data_referencia)/12);
RETURN v_idade;
END;

SELECT brh.calcula_idade(to_date('', 'DD/MM/YYYY')) Idade FROM dual;



-- 6. Validar cálculo de idade

CREATE OR REPLACE FUNCTION brh.calcula_idade_ERRO
(p_data_referencia IN DATE)
RETURN VARCHAR2
IS
v_idade NUMBER;
v_resultado VARCHAR(100);
BEGIN
       v_idade := TRUNC (MONTHS_BETWEEN(sysdate, p_data_referencia)/12);
      IF p_data_referencia <= sysdate THEN
       v_resultado := TO_CHAR(v_idade);
      ELSIF p_data_referencia > sysdate THEN
       v_resultado := 'Impossível calcular idade! Data inválida: ' || TO_CHAR (p_data_referencia, 'DD/MM/YYYY');
      ELSE 
       v_resultado := 'Impossível calcular idade! Dados Invalidos';
      END IF;
RETURN v_resultado;
END;


SELECT brh.calcula_idade_ERRO (to_date('lyij', 'DD/MM/YYYY')) Idade FROM dual;
