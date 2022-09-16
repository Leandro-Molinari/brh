/* TAREFAS MySQL*/

/*TAREFA 1 - RELATORIO DE DEPARTAMENTOS*/

SELECT sigla, nome
FROM departamento
ORDER BY nome;


/*TAREFA 2 - RELATORIO DE DEPENDENTES*/

SELECT colaborador.nome AS 'Nome do Colaborador', dependente.nome AS 'Nome do Dependente', dependente.data_nascimento AS 'Data de Nascimento', dependente.parentesco AS 'Grau de Parentesco'
FROM colaborador, dependente
where colaborador.matricula = dependente.colaborador
ORDER BY colaborador.nome, dependente.nome;


/*TAREFA 3 - INSERIR NOVO COLABORADOR*/

insert into papel 
	(nome) 
values 
	('Especialista de Negócios');

insert into projeto 
	(nome, responsavel, inicio, fim)
values 
	('BI', 'W123', '2022-05-01', '2022-07-04');

insert into endereco
	(cep, uf, cidade, bairro, logradouro)
values
	('18569-350', 'SP', 'São Paulo', 'Morumbi', 'Avenida 01 de Fevereiro');

insert into colaborador 
	(matricula, nome, cpf, email_pessoal, email_corporativo, salario, departamento, cep, complemento_endereco)
values
	('F124', 'Fulano de Tal', '259.468.995-32', 'fdetal@email.com', 'fulanodt@corp.com', '12689', 'SESEG', '18569-350', 'Casa 26');

insert into telefone_colaborador 
	(colaborador, numero, tipo)
values
	('F124', '(61) 99999-9999', 'M');

insert into atribuicao 
	(projeto, colaborador, papel)
values 
	(5, 'F124', 8);


/*TAREFA 4 - EXCLUIR DEPARTAMENTO */

SELECT * FROM DEPARTAMENTO;

SELECT * FROM COLABORADOR
WHERE DEPARTAMENTO = 'SECAP';

DELETE FROM atribuicao 
WHERE colaborador = 'H123' or colaborador = 'M123' OR colaborador = 'R123' OR colaborador = 'W123';

SELECT * FROM atribuicao;

DELETE FROM telefone_colaborador 
WHERE colaborador = 'H123' or colaborador = 'M123' OR colaborador = 'R123' OR colaborador = 'W123';

SELECT * FROM telefone_colaborador;

DELETE FROM dependente
WHERE colaborador = 'H123' or colaborador = 'M123' OR colaborador = 'R123' OR colaborador = 'W123';

SELECT * FROM dependente;

UPDATE departamento SET chefe = 'F124'
WHERE sigla = 'SECAP';

SELECT chefe
FROM departamento
WHERE sigla = 'SECAP';

DELETE FROM projeto
WHERE responsavel = 'H123' or responsavel = 'M123' OR responsavel = 'R123' OR responsavel = 'W123';

SELECT * FROM projeto; 

DELETE FROM colaborador 
WHERE departamento = 'SECAP';

SELECT * FROM colaborador
WHERE departamento = 'SECAP';
 
DELETE FROM departamento 
WHERE sigla = 'SECAP';
 
SELECT * FROM departamento;