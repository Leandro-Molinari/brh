-- 1- DESAFIO RELATORIO DE TAXA POR DEPENDENTE --

-- VIEW DA CLASSIFICAÇÃO DE SENIORIDADE --

CREATE OR REPLACE VIEW BRH.VW_SENIORIDADE
AS SELECT  matricula
        , nome
        , salario,
        (CASE
          WHEN salario <= 3000 THEN 'Júnior'
          WHEN salario <= 6000 THEN 'Pleno'
          WHEN salario <= 20000 THEN 'Sênior'
          ELSE 'Corpo Diretor'
        END) AS SENIORIDADE
        
FROM brh.colaborador
ORDER BY senioridade, nome;

-- VIEW DA CLASSIFICAÇÃO DE FAIXA ETÁRIA --
CREATE OR REPLACE VIEW BRH.VW_FAIXA_ETARIA AS
SELECT d.cpf
	 , d.nome
	 , TO_CHAR (d.data_nascimento,'DD/MM/YYYY') "DATA DE NASCIMENTO"
 	 , d.parentesco
	 , d.colaborador
	 ,	(CASE 
            WHEN trunc (MONTHS_BETWEEN (SYSDATE, DATA_NASCIMENTO)/12) < 18 THEN 'Menor de Idade'
            ELSE 'Adulto'
     	END) AS etaria

FROM brh.dependente d;


-- RELATÓRIO DE VALORES ADICIONAIS DE PLANO DE SAÚDE POR COLABORADOR E DEPENDENTES --

SELECT  valor.nome
      , (dep.Adicional + valor.val) Total
       
FROM 

 (SELECT  
          a.matricula
          , a.nome
          , CASE 
            WHEN a.senioridade = 'Júnior' then ROUND ((A.SALARIO * 0.01),2)
             WHEN a.senioridade = 'Pleno' then ROUND ((A.SALARIO * 0.02),2)
              WHEN a.senioridade = 'Sênior' then ROUND ((A.SALARIO * 0.03),2)
            ELSE ROUND ((a.SALARIO * 0.05),2)
         END AS val
         
    from brh.vw_senioridade A) valor

INNER JOIN

(SELECT  
          colaborador,
          SUM (adicional) Adicional
FROM    
     (SELECT f.colaborador  
         , CASE
            WHEN f.parentesco = 'Filho(a)' AND f.etaria = 'Adulto' THEN '50'
             WHEN f.parentesco = 'Filho(a)' AND f.etaria = 'Menor de Idade' THEN '25'
              WHEN f.parentesco = 'Cônjuge' then '100'
            ELSE '0'
         END AS adicional
     FROM BRH.VW_FAIXA_ETARIA f) 
     
    GROUP BY colaborador) dep


ON dep.colaborador = valor.matricula
       
       ORDER BY valor.nome;


-- 2 - DESAFIO PAGINAÇÃO --

-- PAGINAÇÃO ATÉ 10 --

SELECT nome , cpf, email_pessoal, email_corporativo, salario, departamento
  FROM
        (SELECT ROWNUM linha, c.nome , c.cpf, c.email_pessoal, c.email_corporativo, c.salario, c.departamento
         FROM BRH.COLABORADOR c
         ORDER BY nome
        )
    WHERE linha <= 10; 

-- PAGINAÇÃO 11 ATÉ 20 --

SELECT nome , cpf, email_pessoal, email_corporativo, salario, departamento
  FROM
        (SELECT ROWNUM linha, c.nome , c.cpf, c.email_pessoal, c.email_corporativo, c.salario, c.departamento
         FROM BRH.COLABORADOR c
         ORDER BY nome
        )
    WHERE linha >= 11 AND linha <= 20; 

-- PAGINAÇÃO 21 ATÉ 30 (ATÉ O FINAL) --
SELECT nome , cpf, email_pessoal, email_corporativo, salario, departamento
  FROM
        (SELECT ROWNUM linha, c.nome , c.cpf, c.email_pessoal, c.email_corporativo, c.salario, c.departamento
         FROM BRH.COLABORADOR c
         ORDER BY nome
        )
    WHERE linha >= 21 AND linha <= 30; 




-- 3 - DESAFIO Listar colaboradores que participaram de todos os projetos --


SELECT  c.nome, col_proj.colaborador
 FROM
    brh.colaborador c 
    ,(
      SELECT a.colaborador, COUNT (*) td_proj 
       FROM brh.atribuicao a
       GROUP BY colaborador
     )col_proj

INNER JOIN

     (
      SELECT SUM(agrupamento.grupo) Numero_de_Projetos
       FROM
            (                                                
             SELECT COUNT(*) grupo 
               FROM brh.projeto
               GROUP BY id
            )agrupamento
     ) agroup

ON col_proj.td_proj = agroup.Numero_de_projetos
WHERE col_proj.colaborador = c.matricula;