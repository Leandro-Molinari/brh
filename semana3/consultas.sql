-- LEANDRO MOLINARI

-- TAREFA 1 - Filtrar Dependentes 

SELECT c.nome COLABORADOR, d.nome DEPENDENTE, d.data_nascimento "Data de Nascimento"
    FROM brh.dependente d
        INNER JOIN brh.colaborador c
        ON c.matricula = d.colaborador
    WHERE ((TO_CHAR (d.data_nascimento, 'MM')) >= '04' 
          AND (TO_CHAR (d.data_nascimento, 'MM')) <= '06'
          OR lower(d.nome)LIKE '%h%')
    ORDER BY c.nome;


-- TAREFA 2 - Listar colaboradores em projetos

SELECT       
       d.nome "NOME DEPARTAMENTO"
     , p.nome "PROJETO"
     , COUNT(a.projeto) "QUANTIDADE DE COLABORADORES"
       
FROM brh.departamento d
    INNER JOIN brh.colaborador c
    ON c.departamento = d.sigla
    INNER JOIN brh.atribuicao a
        ON c.matricula = a.colaborador
            INNER JOIN brh.projeto p
            ON a.projeto = p.id
-- LEMBRETE
-- CAMPO COUNT NO GROUP BY 
GROUP BY  a.projeto, p.nome , d.nome  
ORDER BY d.nome, p.nome;

-- TAREFA 3 - Listar colaboradores com mais dependentes

SELECT c.nome
	 , COUNT (d.nome) QUANTIDADE_DEPENDENTES 

FROM brh.colaborador c
     , brh.dependente d
   WHERE c.matricula = d.colaborador
HAVING COUNT (*) > 1
GROUP BY c.nome
ORDER BY QUANTIDADE_DEPENDENTES DESC, c.nome;


-- TAREFA 4 - Listar faixa etária dos dependentes

SELECT d.cpf
	 , d.nome
	 , TO_CHAR (d.data_nascimento,'DD/MM/YYYY') "DATA DE NASCIMENTO"
 	 , d.parentesco
	 , d.colaborador
	 --, trunc (MONTHS_BETWEEN (SYSDATE, DATA_NASCIMENTO)/12) AS idade
	 ,  

	(CASE WHEN trunc (MONTHS_BETWEEN (SYSDATE, DATA_NASCIMENTO)/12) < 18 THEN 'Menor de Idade'
      	ELSE 'Adulto'
     	END) AS "CLASSIFICAÇÃO ETÁRIA"

FROM brh.dependente d
ORDER BY d.colaborador, d.nome;


-- TAREFA 5 - Listar colaborador com maior salário

SELECT nome, salario
FROM brh.colaborador
WHERE salario = (SELECT MAX(salario)
                 FROM brh.colaborador);


-- TAREFA 6 - Relatório de senioridade

SELECT  matricula
        , nome
        , salario,
        (CASE
          WHEN salario <= 3000 THEN 'Júnior'
          WHEN salario <= 6000 THEN 'Pleno'
          WHEN salario <= 20000 THEN 'Sênior'
          ELSE 'Corpo Diretor'
        END) AS "SENIORIDADE"
        
FROM brh.colaborador
ORDER BY senioridade, nome;

