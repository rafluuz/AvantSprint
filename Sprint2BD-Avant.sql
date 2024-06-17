-- Verificação se as tabelas existem antes de tentar excluí-las
SET SERVEROUTPUT ON;
DECLARE
    v_table_exists NUMBER;
BEGIN
    FOR cur_rec IN (SELECT table_name FROM user_tables WHERE table_name IN ('USUARIO', 'SESSAO_LOGIN', 'REGISTRO_ACESSO', 'PERGUNTA', 'RESPOSTA')) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'SELECT 1 FROM ' || cur_rec.table_name || ' WHERE ROWNUM = 1';
            v_table_exists := 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_table_exists := 0;
        END;
        IF v_table_exists = 1 THEN
            EXECUTE IMMEDIATE 'DROP TABLE ' || cur_rec.table_name || ' CASCADE CONSTRAINTS';
        END IF;
    END LOOP;
END;



-- Criando a tabela "usuario" com fusão dos atributos de "Usuario" pq havia dados duplicados
CREATE TABLE usuario (
    id_usuario       NUMBER(4) GENERATED ALWAYS AS IDENTITY,
    nome_user         VARCHAR2(60) NOT NULL,
    email_user        VARCHAR2(100) NOT NULL,
    senha_user        VARCHAR2(55) NOT NULL,
    cpf               VARCHAR2(11) NOT NULL UNIQUE,
    CONSTRAINT pk_usuario PRIMARY KEY (id_usuario)
);
-- Criando a tabela "sessao_login" com remoção de atributos duplicados e adição de "data_hora_logout"
CREATE TABLE sessao_login (
    id_sess          NUMBER(4) NOT NULL,
    data_hora_login   TIMESTAMP,
    data_hora_logout  TIMESTAMP,
    usuario_id_usuario   NUMBER(4) NOT NULL,
    CONSTRAINT pk_sessao_login PRIMARY KEY (id_sess),
    CONSTRAINT fk_sessao_login_usuario FOREIGN KEY (usuario_id_usuario) REFERENCES usuario (id_usuario)
);
-- Criando a tabela "registro_acesso"
CREATE TABLE registro_acesso (
    id_aces          NUMBER(4) NOT NULL,
    tipo_acesso      VARCHAR2(100) NOT NULL,
    data_hora_acesso TIMESTAMP,
    sessao_login_id  NUMBER(4) NOT NULL,
    CONSTRAINT pk_registro_acesso PRIMARY KEY (id_aces),
    CONSTRAINT fk_registro_acesso_sessao_login FOREIGN KEY (sessao_login_id) REFERENCES sessao_login (id_sess)
);

-- Criando a tabela "pergunta"
CREATE TABLE pergunta (
    id_perg         NUMBER(4) NOT NULL,
    conteudo_perg    VARCHAR2(2000) NOT NULL, 
    data_hora_perg  TIMESTAMP,
    usuario_id_usuario NUMBER(4) NOT NULL,
    CONSTRAINT pk_pergunta PRIMARY KEY (id_perg),
    CONSTRAINT fk_pergunta_usuario FOREIGN KEY (usuario_id_usuario) REFERENCES usuario (id_usuario)
);
-- Criando a tabela "resposta"
CREATE TABLE resposta (
    id_resp           NUMBER(4) NOT NULL,
    conteudo_resposta VARCHAR2(2000) NOT NULL,
    data_hora_resposta TIMESTAMP, 
    pergunta_id_perg   NUMBER(4) NOT NULL,
    CONSTRAINT pk_resposta PRIMARY KEY (id_resp),
    CONSTRAINT fk_resposta_pergunta FOREIGN KEY (pergunta_id_perg) REFERENCES pergunta (id_perg)
);

-- Inserts for table "usuario"
INSERT INTO usuario (nome_user, email_user, senha_user, cpf) VALUES ('Alice', 'alice@example.com', 'password123', '12345678901');
INSERT INTO usuario (nome_user, email_user, senha_user, cpf) VALUES ('Bob', 'bob@example.com', 'password456', '23456789012');
INSERT INTO usuario (nome_user, email_user, senha_user, cpf) VALUES ('Charlie', 'charlie@example.com', 'password789', '34567890123');
INSERT INTO usuario (nome_user, email_user, senha_user, cpf) VALUES ('Diana', 'diana@example.com', 'passwordabc', '45678901234');
INSERT INTO usuario (nome_user, email_user, senha_user, cpf) VALUES ('Eve', 'eve@example.com', 'passwordefg', '56789012345');
 
-- Inserts for table "sessao_login"
INSERT INTO sessao_login (id_sess, data_hora_login, data_hora_logout, usuario_id_usuario) VALUES ('0001', SYSTIMESTAMP, NULL, 1);
INSERT INTO sessao_login (id_sess, data_hora_login, data_hora_logout, usuario_id_usuario) VALUES ('0002', SYSTIMESTAMP, NULL, 2);
INSERT INTO sessao_login (id_sess, data_hora_login, data_hora_logout, usuario_id_usuario) VALUES ('0003', SYSTIMESTAMP, NULL, 3);
INSERT INTO sessao_login (id_sess, data_hora_login, data_hora_logout, usuario_id_usuario) VALUES ('0004', SYSTIMESTAMP, NULL, 4);
INSERT INTO sessao_login (id_sess, data_hora_login, data_hora_logout, usuario_id_usuario) VALUES ('0005', SYSTIMESTAMP, NULL, 5);
 
-- Inserts for table "registro_acesso"
INSERT INTO registro_acesso (id_aces, tipo_acesso, data_hora_acesso, sessao_login_id) VALUES ('1001', 'login', SYSTIMESTAMP, '0001');
INSERT INTO registro_acesso (id_aces, tipo_acesso, data_hora_acesso, sessao_login_id) VALUES ('1002', 'logout', SYSTIMESTAMP, '0001');
INSERT INTO registro_acesso (id_aces, tipo_acesso, data_hora_acesso, sessao_login_id) VALUES ('1003', 'login', SYSTIMESTAMP, '0002');
INSERT INTO registro_acesso (id_aces, tipo_acesso, data_hora_acesso, sessao_login_id) VALUES ('1004', 'logout', SYSTIMESTAMP, '0002');
INSERT INTO registro_acesso (id_aces, tipo_acesso, data_hora_acesso, sessao_login_id) VALUES ('1005', 'login', SYSTIMESTAMP, '0003');
 
-- Inserts for table "pergunta"
INSERT INTO pergunta (id_perg, conteudo_perg, data_hora_perg, usuario_id_usuario) VALUES ('2001', 'Quais são as tendências mais recentes no e-commerce?', SYSTIMESTAMP, 1);
INSERT INTO pergunta (id_perg, conteudo_perg, data_hora_perg, usuario_id_usuario) VALUES ('2002', 'Como os dados estão sendo utilizados para personalizar a experiência do usuário no e-commerce?', SYSTIMESTAMP, 2);
INSERT INTO pergunta (id_perg, conteudo_perg, data_hora_perg, usuario_id_usuario) VALUES ('2003', 'Quais são os desafios mais comuns ao lidar com grandes volumes de dados no e-commerce?', SYSTIMESTAMP, 3);
INSERT INTO pergunta (id_perg, conteudo_perg, data_hora_perg, usuario_id_usuario) VALUES ('2004', 'Como as empresas estão protegendo os dados dos clientes no e-commerce?', SYSTIMESTAMP, 4);
INSERT INTO pergunta (id_perg, conteudo_perg, data_hora_perg, usuario_id_usuario) VALUES ('2005', 'Quais são as melhores práticas para análise de dados no e-commerce?', SYSTIMESTAMP, 5);
 
-- Inserts for table "resposta"
INSERT INTO resposta (id_resp, conteudo_resposta, data_hora_resposta, pergunta_id_perg) VALUES ('3001', 'Alguns exemplos de tendências atuais no e-commerce incluem a adoção de compras por voz, personalização avançada com inteligência artificial e realidade aumentada para melhorar a experiência do cliente.', SYSTIMESTAMP, '2001');
INSERT INTO resposta (id_resp, conteudo_resposta, data_hora_resposta, pergunta_id_perg) VALUES ('3002', 'Os dados são utilizados para criar perfis de clientes, recomendar produtos com base no histórico de compras e otimizar campanhas de marketing direcionadas.', SYSTIMESTAMP, '2002');
INSERT INTO resposta (id_resp, conteudo_resposta, data_hora_resposta, pergunta_id_perg) VALUES ('3003', 'Alguns desafios comuns incluem a escalabilidade da infraestrutura de dados, a garantia da segurança dos dados pessoais e a extração de insights significativos de grandes conjuntos de dados.', SYSTIMESTAMP, '2003');
INSERT INTO resposta (id_resp, conteudo_resposta, data_hora_resposta, pergunta_id_perg) VALUES ('3004', 'As empresas estão investindo em medidas de segurança como criptografia de dados, conformidade com regulamentações de privacidade e auditorias de segurança regulares.', SYSTIMESTAMP, '2004');
INSERT INTO resposta (id_resp, conteudo_resposta, data_hora_resposta, pergunta_id_perg) VALUES ('3005', 'Algumas melhores práticas incluem a implementação de análises preditivas para prever tendências de mercado, o uso de ferramentas de visualização de dados para comunicar insights e a adoção de técnicas de machine learning para personalização avançada.', SYSTIMESTAMP, '2005');
 
 
/
 
--Visualização das tabelas
SELECT *  FROM usuario;
SELECT *  FROM sessao_login;
SELECT *  FROM registro_acesso;
SELECT *  FROM pergunta;
SELECT *  FROM resposta;
 
/

--Funções de Validação de Dados: Função para validar o formato do CPF :)
CREATE OR REPLACE FUNCTION validar_cpf(p_cpf IN VARCHAR2) RETURN BOOLEAN IS
BEGIN
    IF LENGTH(p_cpf) <> 11 THEN
        RETURN FALSE;
    ELSE
        FOR i IN 1..LENGTH(p_cpf) LOOP
            IF NOT ASCII(SUBSTR(p_cpf, i, 1)) BETWEEN ASCII('0') AND ASCII('9') THEN
                RETURN FALSE;
            END IF;
        END LOOP;
        RETURN TRUE;
    END IF;
END validar_cpf;

/
 
 
-- Função para validar o formato do e-mail :)
CREATE OR REPLACE FUNCTION validar_email(p_email IN VARCHAR2) RETURN BOOLEAN IS
BEGIN
    IF REGEXP_LIKE(p_email, '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$') THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END validar_email;

 
/

 
--Procedures de Manipulação de Dados: 
-- Procedure de INSERT para a tabela "usuario"
CREATE OR REPLACE PROCEDURE insert_usuario (
    p_nome_user IN VARCHAR2,
    p_email_user IN VARCHAR2,
    p_senha_user IN VARCHAR2,
    p_cpf IN VARCHAR2
) AS
BEGIN
    IF validar_cpf(p_cpf) AND validar_email(p_email_user) THEN
        INSERT INTO usuario (nome_user, email_user, senha_user, cpf)
        VALUES (p_nome_user, p_email_user, p_senha_user, p_cpf);
    ELSE
        DBMS_OUTPUT.PUT_LINE('CPF ou e-mail inválido');
    END IF;
END;

-- Procedure de UPDATE para a tabela "usuario"
CREATE OR REPLACE PROCEDURE atualizar_usuario(
    p_id_usuario IN NUMBER,
    p_nome_user IN VARCHAR2,
    p_email_user IN VARCHAR2,
    p_senha_user IN VARCHAR2,
    p_cpf IN VARCHAR2
) AS
BEGIN
    UPDATE usuario
    SET nome_user = p_nome_user,
        email_user = p_email_user,
        senha_user = p_senha_user,
        cpf = p_cpf
    WHERE id_usuario = p_id_usuario;
    COMMIT;
END atualizar_usuario;

-- Procedure de DELETE para a tabela "usuario"
CREATE OR REPLACE PROCEDURE deletar_usuario(
    p_id_usuario IN NUMBER
) AS
BEGIN
    DELETE FROM usuario WHERE id_usuario = p_id_usuario;
    COMMIT;
END deletar_usuario;



-- Procedure de INSERT para a tabela "sessao_login"
CREATE OR REPLACE PROCEDURE insert_sessao_login (
    p_id_sess IN NUMBER,
    p_data_hora_login IN TIMESTAMP,
    p_data_hora_logout IN TIMESTAMP,
    p_usuario_id_usuario IN NUMBER
) AS
BEGIN
    INSERT INTO sessao_login (id_sess, data_hora_login, data_hora_logout, usuario_id_usuario)
    VALUES (p_id_sess, p_data_hora_login, p_data_hora_logout, p_usuario_id_usuario);
    COMMIT;
END insert_sessao_login;



-- Procedure de UPDATE para a tabela "sessao_login"
CREATE OR REPLACE PROCEDURE atualizar_sessao_login (
    p_id_sess IN NUMBER,
    p_data_hora_login IN TIMESTAMP,
    p_data_hora_logout IN TIMESTAMP,
    p_usuario_id_usuario IN NUMBER
) AS
BEGIN
    UPDATE sessao_login
    SET data_hora_login = p_data_hora_login,
        data_hora_logout = p_data_hora_logout,
        usuario_id_usuario = p_usuario_id_usuario
    WHERE id_sess = p_id_sess;
    COMMIT;
END atualizar_sessao_login;

-- Procedure de DELETE para a tabela "sessao_login"
CREATE OR REPLACE PROCEDURE deletar_sessao_login (
    p_id_sess IN NUMBER
) AS
BEGIN
    DELETE FROM sessao_login WHERE id_sess = p_id_sess;
    COMMIT;
END deletar_sessao_login;
 
 

-- Procedure de INSERT para a tabela "registro_acesso"
CREATE OR REPLACE PROCEDURE insert_registro_acesso (
    p_id_aces IN NUMBER,
    p_tipo_acesso IN VARCHAR2,
    p_data_hora_acesso IN TIMESTAMP,
    p_sessao_login_id IN NUMBER
) AS
BEGIN
    INSERT INTO registro_acesso (id_aces, tipo_acesso, data_hora_acesso, sessao_login_id)
    VALUES (p_id_aces, p_tipo_acesso, p_data_hora_acesso, p_sessao_login_id);
    COMMIT;
END insert_registro_acesso;

-- Procedure de UPDATE para a tabela "registro_acesso"
CREATE OR REPLACE PROCEDURE atualizar_registro_acesso (
    p_id_aces IN NUMBER,
    p_tipo_acesso IN VARCHAR2,
    p_data_hora_acesso IN TIMESTAMP,
    p_sessao_login_id IN NUMBER
) AS
BEGIN
    UPDATE registro_acesso
    SET tipo_acesso = p_tipo_acesso,
        data_hora_acesso = p_data_hora_acesso,
        sessao_login_id = p_sessao_login_id
    WHERE id_aces = p_id_aces;
    COMMIT;
END atualizar_registro_acesso;

-- Procedure de DELETE para a tabela "registro_acesso"
CREATE OR REPLACE PROCEDURE deletar_registro_acesso (
    p_id_aces IN NUMBER
) AS
BEGIN
    DELETE FROM registro_acesso WHERE id_aces = p_id_aces;
    COMMIT;
END deletar_registro_acesso;


-- Procedure de INSERT para a tabela "pergunta"
CREATE OR REPLACE PROCEDURE insert_pergunta (
    p_id_perg IN NUMBER,
    p_conteudo_perg IN VARCHAR2,
    p_data_hora_perg IN TIMESTAMP,
    p_usuario_id_usuario IN NUMBER
) AS
BEGIN
    INSERT INTO pergunta (id_perg, conteudo_perg, data_hora_perg, usuario_id_usuario)
    VALUES (p_id_perg, p_conteudo_perg, p_data_hora_perg, p_usuario_id_usuario);
    COMMIT;
END insert_pergunta;

-- Procedure de UPDATE para a tabela "pergunta"
CREATE OR REPLACE PROCEDURE atualizar_pergunta (
    p_id_perg IN NUMBER,
    p_conteudo_perg IN VARCHAR2,
    p_data_hora_perg IN TIMESTAMP,
    p_usuario_id_usuario IN NUMBER
) AS
BEGIN
    UPDATE pergunta
    SET conteudo_perg = p_conteudo_perg,
        data_hora_perg = p_data_hora_perg,
        usuario_id_usuario = p_usuario_id_usuario
    WHERE id_perg = p_id_perg;
    COMMIT;
END atualizar_pergunta;

-- Procedure de DELETE para a tabela "pergunta"
CREATE OR REPLACE PROCEDURE deletar_pergunta (
    p_id_perg IN NUMBER
) AS
BEGIN
    DELETE FROM pergunta WHERE id_perg = p_id_perg;
    COMMIT;
END deletar_pergunta;


-- Procedure de INSERT para a tabela "resposta"
CREATE OR REPLACE PROCEDURE insert_resposta (
    p_id_resp IN NUMBER,
    p_conteudo_resposta IN VARCHAR2,
    p_data_hora_resposta IN TIMESTAMP,
    p_pergunta_id_perg IN NUMBER
) AS
BEGIN
    INSERT INTO resposta (id_resp, conteudo_resposta, data_hora_resposta, pergunta_id_perg)
    VALUES (p_id_resp, p_conteudo_resposta, p_data_hora_resposta, p_pergunta_id_perg);
    COMMIT;
END insert_resposta;

-- Procedure de UPDATE para a tabela "resposta"
CREATE OR REPLACE PROCEDURE atualizar_resposta (
    p_id_resp IN NUMBER,
    p_conteudo_resposta IN VARCHAR2,
    p_data_hora_resposta IN TIMESTAMP,
    p_pergunta_id_perg IN NUMBER
) AS
BEGIN
    UPDATE resposta
    SET conteudo_resposta = p_conteudo_resposta,
        data_hora_resposta = p_data_hora_resposta,
        pergunta_id_perg = p_pergunta_id_perg
    WHERE id_resp = p_id_resp;
    COMMIT;
END atualizar_resposta;

-- Procedure de DELETE para a tabela "resposta"
CREATE OR REPLACE PROCEDURE deletar_resposta (
    p_id_resp IN NUMBER
) AS
BEGIN
    DELETE FROM resposta WHERE id_resp = p_id_resp;
    COMMIT;
END deletar_resposta;




/


-- Procedure para realizar um JOIN entre as tabelas "usuario" e "sessao_login"
CREATE OR REPLACE PROCEDURE join_usuario_sessao_login AS
    CURSOR c IS
        SELECT c.nome_user, s.id_sess
        FROM usuario c
        JOIN sessao_login s ON c.id_usuario = s.usuario_id_usuario;
BEGIN
    FOR r IN c LOOP
        DBMS_OUTPUT.PUT_LINE('Nome: ' || r.nome_user || ', ID de Sessão: ' || r.id_sess);
    END LOOP;
END;



-- Executar a procedure de JOIN das tabelas "usuario" e "sessao_login" após a remoção dos campos "email_login" e "senha_login"
BEGIN
    join_usuario_sessao_login;
END;


/


-- Procedure para imprimir um relatório contendo a contagem de acessos de cada usuário
CREATE OR REPLACE PROCEDURE relatorio_acessos AS
BEGIN
    FOR r IN (
        SELECT c.nome_user, COUNT(ra.id_aces) AS total_acessos
        FROM usuario c
        LEFT JOIN sessao_login s ON c.id_usuario = s.usuario_id_usuario
        LEFT JOIN registro_acesso ra ON s.id_sess = ra.sessao_login_id
        GROUP BY c.nome_user
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Usuário: ' || r.nome_user || ', Total de acessos: ' || r.total_acessos);
    END LOOP;
END;


-- Executar a procedure de JOIN "relatorio_acessos"
BEGIN
    relatorio_acessos;
END;


