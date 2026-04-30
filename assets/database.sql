-- SCHEMA: estrutura do banco de dados
CREATE TABLE salas(
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome TEXT,
capacidade INTEGER,
numero TEXT,
recursos TEXT,
localizacao TEXT,
disponivel INTEGER
);

CREATE TABLE cursos(
id INTEGER PRIMARY KEY AUTOINCREMENT,
nome_curso TEXT,
data_inicio TEXT,
data_fim TEXT,
turno TEXT,
professor TEXT,
codigo_sig TEXT
);

CREATE TABLE reservas(
id INTEGER PRIMARY KEY AUTOINCREMENT,
id_curso INTEGER,
id_sala INTEGER,
  
  FOREIGN KEY (id_curso) REFERENCES cursos(id),
  FOREIGN KEY (id_sala) REFERENCES salas(id)
);

-- QUERIES: operaçoes do banco de dados
INSERT INTO salas(nome, capacidade, numero, recursos, localizacao, disponivel)
VALUES ('Lab MAC', 11, '209', 'Computadores iMac 2019, SmartTV', 'Segundo Piso', 1);

SELECT * FROM salas;

INSERT INTO cursos(nome_curso, data_inicio, data_fim, turno, professor, codigo_sig)
VALUES('Programador de Dispositivos Móveis', '06/02/2026', '18/05/2026', 'Tarde', 'Patrick Macedo', '2026.7.54');

SELECT * FROM cursos;

INSERT INTO reservas(id_curso, id_sala)
VALUES (1, 1);

SELECT * FROM reservas;

-- exibe todos os dados de uma tabela
SELECT * FROM salas, cursos, reservas
WHERE salas.id = reservas.id_sala
AND cursos.id = reservas.id_curso;

-- exibe o nome da sala e nome do curso da tabela
SELECT salas.nome, cursos.nome_curso
FROM salas, cursos, reservas
WHERE salas.id = reservas.id_sala
AND cursos.id = reservas.id_curso;

SELECT *
FROM reservas
	INNER JOIN salas ON salas.id = reservas.id_sala
    INNER JOIN cursos ON cursos.id = reservas.id_curso;