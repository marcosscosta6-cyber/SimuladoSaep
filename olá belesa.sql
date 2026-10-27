CREATE TABLE usuario ( 
    id_usuario INT PRIMARY KEY AUTO_INCREMENT, 
    nome_usuario VARCHAR(100) NOT NULL, 
    funcao VARCHAR(50) NOT NULL, 
    idade INT CHECK (idade >= 18)
);

CREATE TABLE equipamentos ( 
    id_equipamento INT PRIMARY KEY AUTO_INCREMENT, 
    nome_equipamento VARCHAR(50) NOT NULL, 
    id_usuario INT NOT NULL, 
    CONSTRAINT fk_equipamentos_usuario 
        FOREIGN KEY (id_usuario) 
        REFERENCES usuario(id_usuario) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

CREATE TABLE ordem (
    id_ordem INT PRIMARY KEY AUTO_INCREMENT,
    situacao VARCHAR(50) NOT NULL DEFAULT 'ABERTA',
    especificacao VARCHAR(100) NOT NULL,
    descricao VARCHAR(500) NOT NULL, 
    data_aberta DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_equipamento INT NOT NULL,
    CONSTRAINT fk_ordem_equipamento 
        FOREIGN KEY (id_equipamento) 
        REFERENCES equipamentos(id_equipamento) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

CREATE TABLE manutencao (
    id_manutencao INT PRIMARY KEY AUTO_INCREMENT,
    situacao VARCHAR(50) NOT NULL DEFAULT 'PROGRAMADA',
    data_manutencao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_ordem INT NOT NULL,
    CONSTRAINT fk_manutencao_ordem 
        FOREIGN KEY (id_ordem) 
        REFERENCES ordem(id_ordem) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

INSERT INTO usuario (nome_usuario, funcao, idade) VALUES 
('Carlos Andrade', 'Técnico de Manutenção', 32),
('Mariana Lima', 'Engenheira de Ativos', 28);

INSERT INTO equipamentos (nome_equipamento, id_usuario) VALUES 
('Torno CNC 01', 1),
('Prensa Hidráulica P2', 1),
('Empilhadeira Elétrica E3', 2);

INSERT INTO ordem (situacao, especificacao, descricao, id_equipamento) VALUES 
('EM ANDAMENTO', 'Troca de Rolamento', 'Equipamento apresentando ruído excessivo e vibração no eixo principal.', 1),
('ABERTA', 'Revisão Preventiva', 'Checklist periódico de 500 horas de uso.', 3);

INSERT INTO manutencao (situacao, id_ordem) VALUES 
('EM DIAGNÓSTICO', 1),
('CONCLUÍDA', 1);

SELECT 
    o.id_ordem,
    o.situacao AS status_ordem,
    o.especificacao,
    o.data_aberta,
    e.nome_equipamento,
    u.nome_usuario AS responsavel_tecnico,
    m.id_manutencao,
    m.situacao AS status_intervencao,
    m.data_manutencao
FROM ordem o
INNER JOIN equipamentos e ON o.id_equipamento = e.id_equipamento
INNER JOIN usuario u ON e.id_usuario = u.id_usuario
LEFT JOIN manutencao m ON o.id_ordem = m.id_ordem;