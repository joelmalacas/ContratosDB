/*Index.sql --> Enunciado*/

--1. a)

create or replace PROCEDURE Resumo_Entidade (
    p_parte_nome IN Entidade.designacao%TYPE
) IS
    v_encontrou BOOLEAN := FALSE;

    CURSOR c_entidades IS
        WITH contratos_por_papel AS (
            SELECT DISTINCT
                ce.id_entidade,
                ce.id_contrato,
                TRIM(UPPER(ce.papel)) AS papel_norm,
                c.preco_contratual
            FROM
                Contrato_Entidade ce
                JOIN Contrato c
                    ON c.id_contrato = ce.id_contrato
            WHERE
                TRIM(UPPER(ce.papel)) IN ('ADJUDICANTE', 'ADJUDICATARIO')
        )
        SELECT
            e.id_entidade,
            e.designacao,
            e.identificador_fiscal,
            COUNT(DISTINCT ce.id_contrato) AS total_contratos,
            COUNT(
                DISTINCT CASE
                    WHEN cpp.papel_norm = 'ADJUDICANTE' THEN cpp.id_contrato
                END
            ) AS total_adjudicante,
            NVL(
                SUM(
                    CASE
                        WHEN cpp.papel_norm = 'ADJUDICANTE' THEN cpp.preco_contratual
                    END
                ),
                0
            ) AS valor_total_adjudicante,
            COUNT(
                DISTINCT CASE
                    WHEN cpp.papel_norm = 'ADJUDICATARIO' THEN cpp.id_contrato
                END
            ) AS total_adjudicatario,
            NVL(
                SUM(
                    CASE
                        WHEN cpp.papel_norm = 'ADJUDICATARIO' THEN cpp.preco_contratual
                    END
                ),
                0
            ) AS valor_total_adjudicatario
        FROM
            Entidade e
            LEFT JOIN Contrato_Entidade ce
                ON ce.id_entidade = e.id_entidade
            LEFT JOIN contratos_por_papel cpp
                ON cpp.id_entidade = e.id_entidade
        WHERE
            p_parte_nome IS NOT NULL
            AND INSTR(UPPER(e.designacao), UPPER(p_parte_nome)) > 0
        GROUP BY
            e.id_entidade,
            e.designacao,
            e.identificador_fiscal
        ORDER BY
            e.id_entidade;
BEGIN
    FOR r IN c_entidades LOOP
        v_encontrou := TRUE;
        DBMS_OUTPUT.PUT_LINE(
            'ID: ' || r.id_entidade ||
            ' | Designação: ' || r.designacao ||
            ' | NIF/Identificador Fiscal: ' || r.identificador_fiscal ||
            ' | Contratos distintos: ' || r.total_contratos ||
            ' | Adjudicante: ' || r.total_adjudicante ||
            ' (' || r.valor_total_adjudicante || ' €)' ||
            ' | Adjudicatário: ' || r.total_adjudicatario ||
            ' (' || r.valor_total_adjudicatario || ' €)'
        );
    END LOOP;

    IF NOT v_encontrou THEN
        DBMS_OUTPUT.PUT_LINE(
            'Não foram encontradas entidades com "' || NVL(p_parte_nome, '') || '" na designação.'
        );
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ocorreu um erro ao pesquisar entidades: ' || SQLERRM);
        RAISE;

END Resumo_Entidade;


--Testar Procedure Resumo_Entidade
SET SERVEROUTPUT ON;

BEGIN
    Resumo_Entidade('Castelo Branco');
END;

/*=================================================*/
--1. b)
CREATE TABLE IF NOT EXISTS RESULTADO_LOCALIZACAO (
    id_contrato         NUMBER(10),
    objeto              VARCHAR2(4000),
    pais                VARCHAR2(100),
    distrito            VARCHAR2(100),
    concelho            VARCHAR2(100),
    preco_contratual    DECIMAL(15,2)
);

CREATE OR REPLACE FUNCTION Procura_Contratos_Concelho (
    p_distrito IN VARCHAR2,
    p_concelho IN VARCHAR2
) RETURN NUMBER
IS
    v_linhas_inseridas NUMBER := 0;
BEGIN

    DELETE FROM RESULTADO_LOCALIZACAO;

    INSERT INTO RESULTADO_LOCALIZACAO (
        id_contrato,
        objeto,
        pais,
        distrito,
        concelho,
        preco_contratual
    )
    SELECT DISTINCT
        c.id_contrato,
        c.objeto,
        'Portugal' AS pais,
        p_distrito AS distrito,

        TRIM(
            REGEXP_SUBSTR(
                le.descricao,
                '([^-]+)',
                1,
                1,
                NULL,
                1
            )
        ) AS concelho,

        c.preco_contratual

    FROM CONTRATO c
    JOIN CONTRATO_LOCAL_EXECUCAO cle
        ON cle.id_contrato = c.id_contrato
    JOIN LOCAL_EXECUCAO le
        ON le.id_local_execucao = cle.id_local_execucao

    WHERE LOWER(
        TRIM(
            REGEXP_SUBSTR(
                le.descricao,
                '([^-]+)',
                1,
                1,
                NULL,
                1
            )
        )
    ) = LOWER(TRIM(p_concelho));

    v_linhas_inseridas := SQL%ROWCOUNT;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE(
        'Linhas inseridas: ' || v_linhas_inseridas
    );

    IF v_linhas_inseridas > 0 THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERRO: ' || SQLERRM);
        ROLLBACK;
        RETURN 1;
END;


-- TESTE FUNC Procura_Contratos_Concelho
DECLARE
    v_res NUMBER;
BEGIN
    v_res := Procura_Contratos_Concelho('Castelo Branco', 'Covilhã');
    DBMS_OUTPUT.PUT_LINE('Retorno: ' || v_res);
END;

SELECT * FROM RESULTADO_LOCALIZACAO;


/*===========================================*/
--2. a)

CREATE OR REPLACE TRIGGER ActualizaTotalContratos
AFTER INSERT OR DELETE OR UPDATE OF id_procedimento ON CONTRATO
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE PROCEDIMENTO p
        SET p.total_contratos = NVL(p.total_contratos, 0) + 1
        WHERE p.id_procedimento = :NEW.id_procedimento;

    ELSIF DELETING THEN
        UPDATE PROCEDIMENTO p
        SET p.total_contratos = NVL(p.total_contratos, 0) - 1
        WHERE p.id_procedimento = :OLD.id_procedimento;

    ELSIF UPDATING('ID_PROCEDIMENTO') THEN
        IF (:OLD.id_procedimento IS NULL AND :NEW.id_procedimento IS NOT NULL)
           OR (:OLD.id_procedimento IS NOT NULL AND :NEW.id_procedimento IS NULL)
           OR (:OLD.id_procedimento <> :NEW.id_procedimento) THEN

            IF :OLD.id_procedimento IS NOT NULL THEN
                UPDATE PROCEDIMENTO p
                SET p.total_contratos = NVL(p.total_contratos, 0) - 1
                WHERE p.id_procedimento = :OLD.id_procedimento;
            END IF;

            IF :NEW.id_procedimento IS NOT NULL THEN
                UPDATE PROCEDIMENTO p
                SET p.total_contratos = NVL(p.total_contratos, 0) + 1
                WHERE p.id_procedimento = :NEW.id_procedimento;
            END IF;
        END IF;
    END IF;
END ActualizaTotalContratos;
/

--Testar Trigger AtualizatotalContratos
SET SERVEROUTPUT ON;

DECLARE
    v_col NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_col
    FROM user_tab_columns
    WHERE table_name = 'PROCEDIMENTO'
      AND column_name = 'TOTAL_CONTRATOS';

    IF v_col = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE PROCEDIMENTO ADD (total_contratos NUMBER(10) DEFAULT 0)';
    END IF;
END;
/

UPDATE PROCEDIMENTO p
SET total_contratos = (
    SELECT COUNT(*)
    FROM CONTRATO c
    WHERE c.id_procedimento = p.id_procedimento
);

-- =====================================================================
-- 1. PREPARAÇÃO: 2 procedimentos de teste (com 0 contratos iniciais)
-- =====================================================================
INSERT INTO PROCEDIMENTO (id_procedimento, id_tipo_procedimento, centralizado, compra_conjunta, total_contratos)
SELECT 990001, MIN(id_tipo_procedimento), 'N', 'N', 0
FROM TIPO_PROCEDIMENTO;

INSERT INTO PROCEDIMENTO (id_procedimento, id_tipo_procedimento, centralizado, compra_conjunta, total_contratos)
SELECT 990002, MIN(id_tipo_procedimento), 'N', 'N', 0
FROM TIPO_PROCEDIMENTO;

PROMPT === Estado inicial (esperado: 990001 = 0, 990002 = 0) ===
SELECT id_procedimento, total_contratos
FROM PROCEDIMENTO
WHERE id_procedimento IN (990001, 990002)
ORDER BY id_procedimento;

-- =====================================================================
-- 2. TESTE INSERT: inserir 2 contratos em 990001
-- =====================================================================
INSERT INTO CONTRATO (id_contrato, id_procedimento, objeto, preco_contratual, ecologico)
VALUES (9900001, 990001, 'Teste INSERT 1', 1000.00, 'N');

INSERT INTO CONTRATO (id_contrato, id_procedimento, objeto, preco_contratual, ecologico)
VALUES (9900002, 990001, 'Teste INSERT 2', 2000.00, 'S');


PROMPT === Após INSERT de 2 contratos em 990001 (re: 990001 = 2, 990002 = 0) ===
SELECT id_procedimento, total_contratos
FROM PROCEDIMENTO
WHERE id_procedimento IN (990001, 990002)
ORDER BY id_procedimento;

-- =====================================================================
-- 3. TESTE UPDATE (mesmo id_procedimento): alterar outro campo sem mudar id_procedimento
-- =====================================================================
UPDATE CONTRATO
SET preco_contratual = 1250.00,
    id_procedimento = 990001
WHERE id_contrato = 9900001;

PROMPT === Após UPDATE sem alterar id_procedimento (re: 990001 = 2, 990002 = 0) ===
SELECT id_procedimento, total_contratos
FROM PROCEDIMENTO
WHERE id_procedimento IN (990001, 990002)
ORDER BY id_procedimento;

-- =====================================================================
-- 4. TESTE UPDATE (mudança de id_procedimento): mover 9900002 de 990001 para 990002
-- =====================================================================
UPDATE CONTRATO
SET id_procedimento = 990002
WHERE id_contrato = 9900002;

PROMPT === Após UPDATE movendo contrato de 990001 para 990002 (re: 990001 = 1, 990002 = 1) ===
SELECT id_procedimento, total_contratos
FROM PROCEDIMENTO
WHERE id_procedimento IN (990001, 990002)
ORDER BY id_procedimento;

-- =====================================================================
-- 5. TESTE DELETE: apagar contrato 9900001 de 990001
-- =====================================================================
DELETE FROM CONTRATO
WHERE id_contrato = 9900001;

PROMPT === Após DELETE de contrato em 990001 (re: 990001 = 0, 990002 = 1) ===
SELECT id_procedimento, total_contratos
FROM PROCEDIMENTO
WHERE id_procedimento IN (990001, 990002)
ORDER BY id_procedimento;

-- Reverter tudo para deixar a base de dados limpa
ROLLBACK;


/*=======================================*/
--2. b)

CREATE TABLE REGISTA_ALTERACOES_PRECOS (
    id_alteracao   NUMBER GENERATED BY DEFAULT AS IDENTITY,
    id_contrato    NUMBER NOT NULL,
    objeto         VARCHAR2(500),
    preco_antigo   NUMBER(12, 2),
    novo_preco     NUMBER(12, 2),
    data_alteracao DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_REGISTA_ALTERACOES_PRECOS PRIMARY KEY (id_alteracao)
);

create or replace trigger AuditaPrecosContratos
after update of preco_contratual or delete on Contrato
for each row
begin
  if updating('preco_contratual') then
    if nvl(:old.preco_contratual, -1) <> nvl(:new.preco_contratual, -1) then
      INSERT INTO REGISTA_ALTERACOES_PRECOS (
          id_contrato,
          objeto,
          preco_antigo,
          novo_preco,
          data_alteracao
      ) VALUES (
          :OLD.id_contrato,
          :OLD.objeto,
          :OLD.preco_contratual,
          :NEW.preco_contratual,
          SYSDATE
      );
    end if;

    elsif deleting then
      INSERT INTO REGISTA_ALTERACOES_PRECOS (
          id_contrato,
          objeto,
          preco_antigo,
          novo_preco,
          data_alteracao
      ) VALUES (
          :OLD.id_contrato,
          :OLD.objeto,
          :OLD.preco_contratual,
          NULL,
          SYSDATE
      );
  end if;
end AuditaPrecosContratos;

--Testes trigger AuditaPrecosContratos
SET SERVEROUTPUT ON;

-- =========================================================================
-- PREPARAÇÃO: limpar eventuais dados de teste anteriores
-- =========================================================================
DELETE FROM REGISTA_ALTERACOES_PRECOS WHERE id_contrato = 99902;
DELETE FROM Contrato WHERE id_contrato = 99902;

-- Inserir contrato de teste usando um id_procedimento existente em Procedimento
INSERT INTO Contrato (id_contrato, id_procedimento, objeto, preco_contratual)
VALUES (99902, 201, 'Objeto inicial', 5000.00);

-- Confirmar que o INSERT não cria registo de auditoria
SELECT COUNT(*) AS registos_apos_insert
FROM REGISTA_ALTERACOES_PRECOS
WHERE id_contrato = 99902;

-- =========================================================================
-- TESTE 1: UPDATE sem alterar preco_contratual (não deve auditar)
-- =========================================================================
UPDATE Contrato
SET objeto = 'Objeto alterado sem mudar preco',
    preco_contratual = 5000.00
WHERE id_contrato = 99902;

-- Esperado: 0 linhas para id_contrato = 99902
SELECT id_alteracao, id_contrato, objeto, preco_antigo, novo_preco, data_alteracao
FROM REGISTA_ALTERACOES_PRECOS
WHERE id_contrato = 99902
ORDER BY id_alteracao;

-- =========================================================================
-- TESTE 2: UPDATE alterando preco_contratual (deve registar valores anteriores e novo)
-- =========================================================================
UPDATE Contrato
SET objeto = 'Objeto apos alteracao de preco',
    preco_contratual = 6250.00
WHERE id_contrato = 99902;

-- Esperado: 1 linha com objeto='Objeto alterado sem mudar preco', preco_antigo=5000.00, novo_preco=6250.00
SELECT id_alteracao, id_contrato, objeto, preco_antigo, novo_preco, data_alteracao
FROM REGISTA_ALTERACOES_PRECOS
WHERE id_contrato = 99902
ORDER BY id_alteracao;

-- =========================================================================
-- TESTE 3: DELETE do contrato (deve registar valores anteriores com novo_preco = NULL)
-- =========================================================================
DELETE FROM Contrato
WHERE id_contrato = 99902;

-- Esperado: 2.ª linha com objeto='Objeto apos alteracao de preco', preco_antigo=6250.00, novo_preco=NULL
SELECT id_alteracao, id_contrato, objeto, preco_antigo, novo_preco, data_alteracao
FROM REGISTA_ALTERACOES_PRECOS
WHERE id_contrato = 99902
ORDER BY id_alteracao;

-- =========================================================================
-- LIMPEZA FINAL (opcional)
-- =========================================================================
DELETE FROM REGISTA_ALTERACOES_PRECOS WHERE id_contrato = 99902;
