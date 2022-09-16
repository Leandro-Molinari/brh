CREATE OR REPLACE PACKAGE brh.pkg_projeto

IS
PROCEDURE insere_projeto_1 
(
      p_NOME IN BRH.PROJETO.NOME%type
    , p_RESPONSAVEL IN BRH.PROJETO.RESPONSAVEL%type
    , p_INICIO IN BRH.PROJETO.INICIO%type
); 

FUNCTION calcula_idade_1
(p_data_referencia IN DATE)
RETURN NUMBER;


FUNCTION finaliza_projeto
(p_ID IN brh.projeto.id%type)
RETURN brh.projeto.fim%type;

FUNCTION calcula_idade_ERRO
(p_data_referencia IN DATE)
RETURN VARCHAR2;

PROCEDURE insere_projeto 
(
      p_NOME IN BRH.PROJETO.NOME%type
    , p_RESPONSAVEL IN BRH.PROJETO.RESPONSAVEL%type
    , p_INICIO IN BRH.PROJETO.INICIO%type
);


PROCEDURE define_atribuicao
        (  p_nome_colaborador IN brh.colaborador.nome%type
         , p_nome_projeto IN brh.projeto.nome%type
         , p_nome_papel IN brh.papel.nome%type
        );

END;



CREATE OR REPLACE PACKAGE BODY brh.pkg_projeto

IS
PROCEDURE insere_projeto_1 
(
      p_NOME IN BRH.PROJETO.NOME%type
    , p_RESPONSAVEL IN BRH.PROJETO.RESPONSAVEL%type
    , p_INICIO IN BRH.PROJETO.INICIO%type
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


FUNCTION calcula_idade_1
(p_data_referencia IN DATE)
RETURN NUMBER
IS
v_idade NUMBER;
BEGIN
       v_idade := TRUNC(MONTHS_BETWEEN(sysdate, p_data_referencia)/12);
RETURN v_idade;
END;


FUNCTION finaliza_projeto
(p_ID IN brh.projeto.id%type)
RETURN brh.projeto.fim%type
IS
data_fim brh.projeto.fim%type;
BEGIN
    UPDATE brh.projeto SET FIM = SYSDATE
    WHERE brh.projeto.ID = p_ID;
        RETURN data_fim;
END;


FUNCTION calcula_idade_ERRO
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
       v_resultado := 'Imposs�vel calcular idade! Data inv�lida: ' || TO_CHAR (p_data_referencia, 'DD/MM/YYYY');
      ELSE 
       v_resultado := 'Imposs�vel calcular idade! Dados Invalidos';
      END IF;
RETURN v_resultado;
END;


PROCEDURE insere_projeto 
(
      p_NOME IN BRH.PROJETO.NOME%type
    , p_RESPONSAVEL IN BRH.PROJETO.RESPONSAVEL%type
    , p_INICIO IN BRH.PROJETO.INICIO%type
) 
IS
   e_erro exception;
BEGIN
    INSERT INTO BRH.PROJETO 
        (NOME, RESPONSAVEL, INICIO) 
    VALUES 
        (upper (p_NOME), upper (p_RESPONSAVEL), p_INICIO);

    DECLARE
        e_nome BRH.PROJETO.NOME%type := p_nome;
    BEGIN
        IF length (e_nome) < 2 THEN
            RAISE e_erro;
        END IF;
    END;

    EXCEPTION
        WHEN e_erro THEN
                raise_application_error(-20100,'Nome de projeto inv�lido! Deve ter dois ou mais caracteres.');
END;


PROCEDURE define_atribuicao
        (  p_nome_colaborador IN brh.colaborador.nome%type
         , p_nome_projeto IN brh.projeto.nome%type
         , p_nome_papel IN brh.papel.nome%type
        )
                 
IS
      e_erro_col_inex exception;
      e_erro_proj_inex exception;
      e_erro_papel_inex exception;
   
    v_matricula_colaborador brh.colaborador.matricula%type; 
    v_id_projeto brh.projeto.id%type;   
    v_id_papel brh.papel.id%type;
    
 BEGIN
    
    BEGIN
       SELECT matricula INTO v_matricula_colaborador 
            FROM brh.colaborador 
            WHERE nome = p_nome_colaborador;
            
        EXCEPTION
        WHEN no_data_found THEN
        RAISE e_erro_col_inex;
    END;
    
    BEGIN
       SELECT id INTO v_id_projeto       
            FROM brh.projeto
            WHERE nome = p_nome_projeto;
     
        EXCEPTION
        WHEN no_data_found THEN
        RAISE e_erro_proj_inex;
    END;
    
    BEGIN
       SELECT id INTO v_id_papel      
            FROM brh.papel
            WHERE nome = p_nome_papel;
        
        EXCEPTION
        WHEN no_data_found THEN
        INSERT INTO brh.papel (NOME) VALUES (p_nome_papel);
    END;
    
    EXCEPTION
        WHEN e_erro_col_inex THEN
                raise_application_error(-20100,'Colaborador Inexistente: ' || p_nome_colaborador);       
        WHEN e_erro_proj_inex THEN
                raise_application_error(-20200,'Projeto Inexistente: ' || p_nome_projeto);  

    BEGIN
       INSERT INTO brh.atribuicao 
                 (COLABORADOR, PROJETO, PAPEL) 
       VALUES 
                 (v_matricula_colaborador, v_id_projeto, v_id_papel);  
    END;

END;

END;

GRANT EXECUTE ON PKG_PROJETO TO BRH;

CREATE PUBLIC SYNONYM PKG_PROJETO FOR brh.PKG_PROJETO;

