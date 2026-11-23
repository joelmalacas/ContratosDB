/* =====================================================================
   TP1 - CBD - Complementos de Bases de Dados, CREATE TABLE
   ===================================================================== */
CREATE TABLE IF NOT EXISTS NUTS (
    codigo_nuts     VARCHAR2(10),
    designacao      VARCHAR2(200),
    CONSTRAINT PK_NUTS PRIMARY KEY (codigo_nuts)
);

CREATE TABLE IF NOT EXISTS PAIS (
    codigo_pais     VARCHAR2(3),
    designacao      VARCHAR2(100),
    CONSTRAINT PK_PAIS PRIMARY KEY (codigo_pais)
);

CREATE TABLE IF NOT EXISTS LOCAL_EXECUCAO (
    id_local_execucao   NUMBER(10),
    descricao           VARCHAR2(500),
    CONSTRAINT PK_LOCAL_EXECUCAO PRIMARY KEY (id_local_execucao)
);

CREATE TABLE IF NOT EXISTS TIPO_CONTRATO (
    id_tipo_contrato    NUMBER(10),
    designacao          VARCHAR2(150),
    CONSTRAINT PK_TIPO_CONTRATO PRIMARY KEY (id_tipo_contrato)
);

CREATE TABLE IF NOT EXISTS CPV (
    codigo_cpv      VARCHAR2(10),
    descricao       VARCHAR2(500),
    CONSTRAINT PK_CPV PRIMARY KEY (codigo_cpv)
);

CREATE TABLE IF NOT EXISTS TIPO_PROCEDIMENTO (
    id_tipo_procedimento    NUMBER(10),
    designacao              VARCHAR2(150),
    CONSTRAINT PK_TIPO_PROCEDIMENTO PRIMARY KEY (id_tipo_procedimento)
);

CREATE TABLE IF NOT EXISTS ENTIDADE (
    id_entidade             NUMBER(10),
    identificador_fiscal    VARCHAR2(50),
    designacao              VARCHAR2(300) NOT NULL,
    codigo_pais             VARCHAR2(3),
    codigo_nuts             VARCHAR2(10),
    pme                     varchar2(1) DEFAULT NULL CONSTRAINT estado_pme CHECK (pme IN ('S', 'N')),
    CONSTRAINT PK_ENTIDADE PRIMARY KEY (id_entidade),
    CONSTRAINT FK_ENTIDADE_TB_PAIS FOREIGN KEY (codigo_pais)
        REFERENCES PAIS (codigo_pais),
    CONSTRAINT FK_ENTIDADE_TB_NUTS FOREIGN KEY (codigo_nuts)
        REFERENCES NUTS (codigo_nuts)
);

CREATE UNIQUE INDEX IF NOT EXISTS UX_ENTIDADE_PAIS_ID_FISCAL ON ENTIDADE (
    CASE WHEN identificador_fiscal IS NOT NULL THEN codigo_pais          END,
    CASE WHEN identificador_fiscal IS NOT NULL THEN identificador_fiscal END
);

CREATE TABLE IF NOT EXISTS PROCEDIMENTO (
    id_procedimento         NUMBER(10),
    id_tipo_procedimento    NUMBER(10),
    centralizado            VARCHAR2(1),
    compra_conjunta         VARCHAR2(1),
    CONSTRAINT PK_PROCEDIMENTO PRIMARY KEY (id_procedimento),
    CONSTRAINT CHCK_PROCEDIMENTO_CENTRALIZADO CHECK (centralizado IN ('S', 'N')),
    CONSTRAINT CHCK_PROCEDIMENTO_COMPRA_CONJUNTA CHECK (compra_conjunta IN ('S', 'N')),
    CONSTRAINT FK_PROCEDIMENTO_TB_TIPO_PROCEDIMENTO FOREIGN KEY (id_tipo_procedimento)
        REFERENCES TIPO_PROCEDIMENTO (id_tipo_procedimento)
);

CREATE TABLE IF NOT EXISTS CONTRATO (
    id_contrato         NUMBER(10),
    id_procedimento     NUMBER(10),
    objeto              VARCHAR2(4000),
    data_publicacao     DATE,
    data_celebracao     DATE,
    preco_contratual    NUMBER(15,2),
    prazo_execucao      NUMBER(10),
    ecologico           VARCHAR2(1),
    CONSTRAINT PK_CONTRATO PRIMARY KEY (id_contrato),
    CONSTRAINT CHCK_CONTRATO_ECOLOGICO CHECK (ecologico IN ('S', 'N')),
    CONSTRAINT FK_CONTRATO_TB_PROCEDIMENTO FOREIGN KEY (id_procedimento)
        REFERENCES PROCEDIMENTO (id_procedimento)
);

CREATE TABLE IF NOT EXISTS CONTRATO_TIPO_CONTRATO (
    id_contrato         NUMBER(10),
    id_tipo_contrato    NUMBER(10),
    CONSTRAINT PK_CONTRATO_TIPO_CONTRATO PRIMARY KEY (id_contrato, id_tipo_contrato),
    CONSTRAINT FK_CONTRATO_TIPO_CONTRATO_TB_CONTRATO FOREIGN KEY (id_contrato)
        REFERENCES CONTRATO (id_contrato),
    CONSTRAINT FK_CONTRATO_TIPO_CONTRATO_TB_TIPO_CONTRATO FOREIGN KEY (id_tipo_contrato)
        REFERENCES TIPO_CONTRATO (id_tipo_contrato)
);

CREATE TABLE IF NOT EXISTS CONTRATO_LOCAL_EXECUCAO (
    id_contrato         NUMBER(10),
    id_local_execucao   NUMBER(10),
    CONSTRAINT PK_CONTRATO_LOCAL_EXECUCAO PRIMARY KEY (id_contrato, id_local_execucao),
    CONSTRAINT FK_CONTRATO_LOCAL_EXECUCAO_TB_CONTRATO FOREIGN KEY (id_contrato)
        REFERENCES CONTRATO (id_contrato),
    CONSTRAINT FK_CONTRATO_LOCAL_EXECUCAO_TB_LOCAL_EXECUCAO FOREIGN KEY (id_local_execucao)
        REFERENCES LOCAL_EXECUCAO (id_local_execucao)
);

CREATE TABLE IF NOT EXISTS CONTRATO_CPV (
    id_contrato_cpv     NUMBER(10),
    id_contrato         NUMBER(10),
    codigo_cpv          VARCHAR2(10),
    valor               NUMBER(15,2),
    tipo_objeto         VARCHAR2(12),
    CONSTRAINT PK_CONTRATO_CPV PRIMARY KEY (id_contrato_cpv),
    CONSTRAINT CHCK_CONTRATO_CPV_TIPO_OBJETO CHECK (tipo_objeto IN ('PRINCIPAL', 'COMPLEMENTAR')),
    CONSTRAINT FK_CONTRATO_CPV_TB_CONTRATO FOREIGN KEY (id_contrato)
        REFERENCES CONTRATO (id_contrato),
    CONSTRAINT FK_CONTRATO_CPV_TB_CPV FOREIGN KEY (codigo_cpv)
        REFERENCES CPV (codigo_cpv)
);

CREATE TABLE IF NOT EXISTS CONTRATO_ENTIDADE (
    id_contrato     NUMBER(10),
    id_entidade     NUMBER(10),
    papel           VARCHAR2(13),
    CONSTRAINT PK_CONTRATO_ENTIDADE PRIMARY KEY (id_contrato, id_entidade, papel),
    CONSTRAINT CHCK_CONTRATO_ENTIDADE_PAPEL CHECK (papel IN ('ADJUDICANTE', 'ADJUDICATARIO')),
    CONSTRAINT FK_CONTRATO_ENTIDADE_TB_CONTRATO FOREIGN KEY (id_contrato)
        REFERENCES CONTRATO (id_contrato),
    CONSTRAINT FK_CONTRATO_ENTIDADE_TB_ENTIDADE FOREIGN KEY (id_entidade)
        REFERENCES ENTIDADE (id_entidade)
);
