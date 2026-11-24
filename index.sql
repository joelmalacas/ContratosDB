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