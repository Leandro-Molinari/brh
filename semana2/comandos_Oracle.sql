/*TAREFAS ORACLE*/

/*TAREFA 1 - RELATORIO DE DEPARTAMENTOS*/

select sigla, nome
from brh.departamento
order by nome;

/*TAREFA 2 - RELATORIO DE DEPENDENTES*/

SELECT c.nome Colaborador, d.nome Dependente, d.data_nascimento, d.parentesco
FROM brh.colaborador c, brh.dependente d
WHERE c.matricula = d.colaborador
ORDER BY c.nome, d.nome;

OU

SELECT c.nome Colaborador, d.nome Dependente, d.data_nascimento, d.parentesco
FROM brh.colaborador c
INNER JOIN brh.dependente d
ON c.matricula = d.colaborador
ORDER BY c.nome, d.nome;


/*TAREFA 3 - INSERIR NOVO COLABORADOR*/

insert into brh.papel 
	(nome) 
values 
	('Especialista de Negócios');

SELECT * FROM brh.papel;

insert into brh.projeto 
	(nome, responsavel, inicio, fim)
values 
	('BI', 'W123', TO_DATE ('2022-05-01','YYYY-MM-DD'), TO_DATE('2022-07-04','YYYY-MM-DD'));

SELECT * FROM brh.projeto;

insert into brh.endereco
	(cep, uf, cidade, bairro, logradouro)
values
	('18569-350', 'SP', 'São Paulo', 'Morumbi', 'Avenida 01 de Fevereiro');

SELECT * FROM brh.endereco;

insert into brh.colaborador 
	(matricula, nome, cpf, email_pessoal, email_corporativo, salario, departamento, cep, complemento_endereco)
values
	('F124', 'Fulano de Tal', '259.468.995-32', 'fdetal@email.com', 'fulanodt@corp.com', '12689', 'SESEG', '18569-350', 'Casa 26');

SELECT * FROM brh.colaborador;

insert into brh.telefone_colaborador 
	(colaborador, numero, tipo)
values
	('F124', '(61) 99999-9999', 'M');

SELECT * FROM brh.colaborador;

insert into brh.atribuicao 
	(projeto, colaborador, papel)
values 
	(5, 'F124', 8);

SELECT * FROM brh.atribuicao;


  /*TAREFA 4 - EXCLUIR DEPARTAMENTO*/
  
SELECT * FROM brh.colaborador
WHERE departamento = 'SECAP';

DELETE FROM brh.atribuicao 
WHERE colaborador = 'H123' or colaborador = 'M123' OR colaborador = 'R123' OR colaborador = 'W123';

DELETE FROM brh.telefone_colaborador 
WHERE colaborador = 'H123' or colaborador = 'M123' OR colaborador = 'R123' OR colaborador = 'W123';

DELETE FROM brh.dependente
WHERE colaborador = 'H123' or colaborador = 'M123' OR colaborador = 'R123' OR colaborador = 'W123';

UPDATE brh.departamento SET chefe = 'X123'
WHERE sigla = 'SECAP';

SELECT chefe
FROM brh.departamento
WHERE sigla = 'SECAP';

DELETE FROM brh.projeto
WHERE responsavel = 'H123' or responsavel = 'M123' OR responsavel = 'R123' OR responsavel = 'W123';

DELETE FROM brh.colaborador 
WHERE departamento = 'SECAP';

SELECT * FROM brh.colaborador
WHERE departamento = 'SECAP';
 
DELETE FROM brh.departamento 
WHERE sigla = 'SECAP';
 
SELECT * FROM brh.departamento;


/* TAREFA EXTRA 1 - RELATÓRIO DE CONTATOS */

SELECT c.nome, c.email_corporativo, t.numero telefone
FROM brh.colaborador c
INNER JOIN brh.telefone_colaborador t
ON c.matricula = t.colaborador;

/* OU */

SELECT c.nome, c.email_corporativo, t.numero telefone
FROM brh.colaborador c, brh.telefone_colaborador t
WHERE c.matricula = t.colaborador;


/* TAREFA EXTRA 2 - RELATÓRIO ANALÍTICO*/

/*
  Criar um relatório completo das equipes em projetos que liste:
  O nome do Departamento; OK
  O nome do chefe do Departamento; OK
  O nome do Colaborador; OK
  O nome do Projeto que ele está alocado; OK
  O nome do papel desempenhado por ele;
  O número de telefone do Colaborador;ok
  O nome do Dependente do Colaborador. OK*/

SELECT d.nome "Nome do Departamento", 
       chefe.nome "Nome do Chefe", 
       alocacao.nome "Nome do Colaborador",
       projeto.nome Projeto, 
       papel.nome Papel,
       telefone.numero Telefone,
       dep.nome Dependente
    FROM brh.departamento d
        INNER JOIN brh.colaborador chefe
            ON d.chefe = chefe.matricula
        INNER JOIN brh.colaborador alocacao  
            ON d.sigla = alocacao.departamento
        LEFT JOIN brh.projeto projeto
            ON projeto.responsavel = alocacao.matricula
        LEFT JOIN brh.atribuicao npapel
            ON npapel.colaborador = alocacao.matricula
        LEFT JOIN brh.papel papel
            ON papel.id = npapel.papel    
        INNER JOIN brh.telefone_colaborador telefone
            ON telefone.colaborador = alocacao.matricula
        LEFT JOIN brh.dependente dep
         ON dep.colaborador = alocacao.matricula
    ORDER BY d.nome, alocacao.nome;