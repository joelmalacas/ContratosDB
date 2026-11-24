/* =====================================================================
   TP1 - CBD - Complementos de Bases de Dados, SEED
   ===================================================================== */

-- 1. PAIS
INSERT INTO PAIS (codigo_pais, designacao) VALUES ('PRT', 'Portugal');
INSERT INTO PAIS (codigo_pais, designacao) VALUES ('ESP', 'Espanha');
INSERT INTO PAIS (codigo_pais, designacao) VALUES ('FRA', 'França');
INSERT INTO PAIS (codigo_pais, designacao) VALUES ('DEU', 'Alemanha');
INSERT INTO PAIS (codigo_pais, designacao) VALUES ('ITA', 'Itália');

-- 2. NUTS
INSERT INTO NUTS (codigo_nuts, designacao) VALUES ('PT11', 'Norte');
INSERT INTO NUTS (codigo_nuts, designacao) VALUES ('PT16', 'Centro');
INSERT INTO NUTS (codigo_nuts, designacao) VALUES ('PT17', 'Área Metropolitana de Lisboa');
INSERT INTO NUTS (codigo_nuts, designacao) VALUES ('PT18', 'Alentejo');
INSERT INTO NUTS (codigo_nuts, designacao) VALUES ('PT15', 'Algarve');
INSERT INTO NUTS (codigo_nuts, designacao) VALUES ('PT20', 'Região Autónoma dos Açores');
INSERT INTO NUTS (codigo_nuts, designacao) VALUES ('PT30', 'Região Autónoma da Madeira');

-- 3. LOCAL_EXECUCAO
INSERT INTO LOCAL_EXECUCAO (id_local_execucao, descricao) VALUES (1, 'Covilhã - Zona industrial do Tortosendo');
INSERT INTO LOCAL_EXECUCAO (id_local_execucao, descricao) VALUES (2, 'Castelo Branco - Rede de abastecimento e saneamento');
INSERT INTO LOCAL_EXECUCAO (id_local_execucao, descricao) VALUES (3, 'Coimbra - Baixa e margem do Mondego');
INSERT INTO LOCAL_EXECUCAO (id_local_execucao, descricao) VALUES (4, 'Bragança - Eixos viários rurais');
INSERT INTO LOCAL_EXECUCAO (id_local_execucao, descricao) VALUES (5, 'Setúbal - Terminais e acessos rodoviários');
INSERT INTO LOCAL_EXECUCAO (id_local_execucao, descricao) VALUES (6, 'Funchal - Infraestruturas de drenagem');

-- 4. TIPO_CONTRATO
INSERT INTO TIPO_CONTRATO (id_tipo_contrato, designacao) VALUES (1, 'Empreitadas de obras públicas');
INSERT INTO TIPO_CONTRATO (id_tipo_contrato, designacao) VALUES (2, 'Locação ou aquisição de bens móveis');
INSERT INTO TIPO_CONTRATO (id_tipo_contrato, designacao) VALUES (3, 'Aquisição de serviços');
INSERT INTO TIPO_CONTRATO (id_tipo_contrato, designacao) VALUES (4, 'Concessão de obras públicas');

-- 5. CPV
INSERT INTO CPV (codigo_cpv, descricao) VALUES ('45233140', 'Obras rodoviárias');
INSERT INTO CPV (codigo_cpv, descricao) VALUES ('72263000', 'Serviços de implementação de software');
INSERT INTO CPV (codigo_cpv, descricao) VALUES ('09132100', 'Gasolina sem chumbo');
INSERT INTO CPV (codigo_cpv, descricao) VALUES ('71311000', 'Serviços de consultoria em engenharia civil');
INSERT INTO CPV (codigo_cpv, descricao) VALUES ('30213000', 'Computadores pessoais');
INSERT INTO CPV (codigo_cpv, descricao) VALUES ('90511000', 'Serviços de recolha de resíduos urbanos');

-- 6. TIPO_PROCEDIMENTO
INSERT INTO TIPO_PROCEDIMENTO (id_tipo_procedimento, designacao) VALUES (1, 'Ajuste direto');
INSERT INTO TIPO_PROCEDIMENTO (id_tipo_procedimento, designacao) VALUES (2, 'Concurso público');
INSERT INTO TIPO_PROCEDIMENTO (id_tipo_procedimento, designacao) VALUES (3, 'Concurso limitado por prévia qualificação');
INSERT INTO TIPO_PROCEDIMENTO (id_tipo_procedimento, designacao) VALUES (4, 'Consulta prévia');

-- 7. ENTIDADE
INSERT INTO ENTIDADE (id_entidade, identificador_fiscal, designacao, codigo_pais, codigo_nuts, pme)
VALUES (1, '600073148', 'Município da Covilhã', 'PRT', 'PT16', NULL);

INSERT INTO ENTIDADE (id_entidade, identificador_fiscal, designacao, codigo_pais, codigo_nuts, pme)
VALUES (2, '600075426', 'Câmara Municipal de Castelo Branco', 'PRT', 'PT16', NULL);

INSERT INTO ENTIDADE (id_entidade, identificador_fiscal, designacao, codigo_pais, codigo_nuts, pme)
VALUES (3, '600076899', 'Município de Coimbra', 'PRT', 'PT16', NULL);

INSERT INTO ENTIDADE (id_entidade, identificador_fiscal, designacao, codigo_pais, codigo_nuts, pme)
VALUES (4, '600077917', 'Município de Bragança', 'PRT', 'PT11', NULL);

INSERT INTO ENTIDADE (id_entidade, identificador_fiscal, designacao, codigo_pais, codigo_nuts, pme)
VALUES (5, '506194820', 'Beira Alta Construções e Terraplenagens, Lda.', 'PRT', 'PT16', 'S');

INSERT INTO ENTIDADE (id_entidade, identificador_fiscal, designacao, codigo_pais, codigo_nuts, pme)
VALUES (6, '508924115', 'Mondego & Zêzere Projetos Hidráulicos, S.A.', 'PRT', 'PT16', 'S');

INSERT INTO ENTIDADE (id_entidade, identificador_fiscal, designacao, codigo_pais, codigo_nuts, pme)
VALUES (7, '511462803', 'Transmontana de Pavimentos e Betuminosos, Lda.', 'PRT', 'PT11', 'N');

INSERT INTO ENTIDADE (id_entidade, identificador_fiscal, designacao, codigo_pais, codigo_nuts, pme)
VALUES (8, '509184732', 'Sado & Tejo Soluções Informáticas, Lda.', 'PRT', 'PT17', 'S');

INSERT INTO ENTIDADE (id_entidade, identificador_fiscal, designacao, codigo_pais, codigo_nuts, pme)
VALUES (9, '513902641', 'Atlântica de Obras Subaquáticas, Unipessoal Lda.', 'PRT', 'PT30', 'S');

INSERT INTO ENTIDADE (id_entidade, identificador_fiscal, designacao, codigo_pais, codigo_nuts, pme)
VALUES (10, NULL, 'Estudio Técnico del Duero y Tajo', 'ESP', NULL, NULL);

-- 8. PROCEDIMENTO
INSERT INTO PROCEDIMENTO (id_procedimento, id_tipo_procedimento, centralizado, compra_conjunta)
VALUES (201, 2, 'N', 'N');

INSERT INTO PROCEDIMENTO (id_procedimento, id_tipo_procedimento, centralizado, compra_conjunta)
VALUES (202, 4, 'N', 'S');

INSERT INTO PROCEDIMENTO (id_procedimento, id_tipo_procedimento, centralizado, compra_conjunta)
VALUES (203, 2, 'S', 'N');

INSERT INTO PROCEDIMENTO (id_procedimento, id_tipo_procedimento, centralizado, compra_conjunta)
VALUES (204, 1, 'N', 'N');

INSERT INTO PROCEDIMENTO (id_procedimento, id_tipo_procedimento, centralizado, compra_conjunta)
VALUES (205, 3, 'N', 'S');

-- 9. CONTRATO
INSERT INTO CONTRATO (id_contrato, id_procedimento, objeto, data_publicacao, data_celebracao, preco_contratual, prazo_execucao, ecologico)
VALUES (2001, 201, 'Alargamento de arruamentos e drenagem pluvial no Tortosendo', DATE '2026-01-12', DATE '2026-01-29', 312450.00, 180, 'N');

INSERT INTO CONTRATO (id_contrato, id_procedimento, objeto, data_publicacao, data_celebracao, preco_contratual, prazo_execucao, ecologico)
VALUES (2002, 202, 'Elaboração de projeto de reforço de condutas adutoras', DATE '2026-02-05', DATE '2026-02-19', 54800.00, 90, 'S');

INSERT INTO CONTRATO (id_contrato, id_procedimento, objeto, data_publicacao, data_celebracao, preco_contratual, prazo_execucao, ecologico)
VALUES (2003, 203, 'Fornecimento de postos de trabalho informáticos e licenciamento', DATE '2026-03-02', DATE '2026-03-16', 88600.00, 60, 'S');

INSERT INTO CONTRATO (id_contrato, id_procedimento, objeto, data_publicacao, data_celebracao, preco_contratual, prazo_execucao, ecologico)
VALUES (2004, 204, 'Conservação corrente de caminhos vicinais e bermas', DATE '2026-03-25', DATE '2026-04-03', 142900.75, 210, 'N');

INSERT INTO CONTRATO (id_contrato, id_procedimento, objeto, data_publicacao, data_celebracao, preco_contratual, prazo_execucao, ecologico)
VALUES (2005, 205, 'Reabilitação de coletores de águas residuais e estações elevatórias', DATE '2026-04-14', DATE '2026-05-04', 615000.00, 270, 'S');

-- 10. CONTRATO_TIPO_CONTRATO
INSERT INTO CONTRATO_TIPO_CONTRATO (id_contrato, id_tipo_contrato) VALUES (2001, 1);
INSERT INTO CONTRATO_TIPO_CONTRATO (id_contrato, id_tipo_contrato) VALUES (2002, 3);
INSERT INTO CONTRATO_TIPO_CONTRATO (id_contrato, id_tipo_contrato) VALUES (2003, 2);
INSERT INTO CONTRATO_TIPO_CONTRATO (id_contrato, id_tipo_contrato) VALUES (2003, 3);
INSERT INTO CONTRATO_TIPO_CONTRATO (id_contrato, id_tipo_contrato) VALUES (2004, 1);
INSERT INTO CONTRATO_TIPO_CONTRATO (id_contrato, id_tipo_contrato) VALUES (2005, 1);

-- 11. CONTRATO_LOCAL_EXECUCAO
INSERT INTO CONTRATO_LOCAL_EXECUCAO (id_contrato, id_local_execucao) VALUES (2001, 1);
INSERT INTO CONTRATO_LOCAL_EXECUCAO (id_contrato, id_local_execucao) VALUES (2002, 2);
INSERT INTO CONTRATO_LOCAL_EXECUCAO (id_contrato, id_local_execucao) VALUES (2003, 3);
INSERT INTO CONTRATO_LOCAL_EXECUCAO (id_contrato, id_local_execucao) VALUES (2004, 4);
INSERT INTO CONTRATO_LOCAL_EXECUCAO (id_contrato, id_local_execucao) VALUES (2005, 5);
INSERT INTO CONTRATO_LOCAL_EXECUCAO (id_contrato, id_local_execucao) VALUES (2005, 6);

-- 12. CONTRATO_CPV
INSERT INTO CONTRATO_CPV (id_contrato_cpv, id_contrato, codigo_cpv, valor, tipo_objeto)
VALUES (101, 2001, '45233140', 312450.00, 'PRINCIPAL');

INSERT INTO CONTRATO_CPV (id_contrato_cpv, id_contrato, codigo_cpv, valor, tipo_objeto)
VALUES (102, 2002, '71311000', 54800.00, 'PRINCIPAL');

INSERT INTO CONTRATO_CPV (id_contrato_cpv, id_contrato, codigo_cpv, valor, tipo_objeto)
VALUES (103, 2003, '30213000', 63600.00, 'PRINCIPAL');

INSERT INTO CONTRATO_CPV (id_contrato_cpv, id_contrato, codigo_cpv, valor, tipo_objeto)
VALUES (104, 2003, '72263000', 25000.00, 'COMPLEMENTAR');

INSERT INTO CONTRATO_CPV (id_contrato_cpv, id_contrato, codigo_cpv, valor, tipo_objeto)
VALUES (105, 2004, '45233140', 142900.75, 'PRINCIPAL');

INSERT INTO CONTRATO_CPV (id_contrato_cpv, id_contrato, codigo_cpv, valor, tipo_objeto)
VALUES (106, 2005, '90511000', 615000.00, 'PRINCIPAL');

-- 13. CONTRATO_ENTIDADE
INSERT INTO CONTRATO_ENTIDADE (id_contrato, id_entidade, papel) VALUES (2001, 1, 'ADJUDICANTE');
INSERT INTO CONTRATO_ENTIDADE (id_contrato, id_entidade, papel) VALUES (2001, 5, 'ADJUDICATARIO');

INSERT INTO CONTRATO_ENTIDADE (id_contrato, id_entidade, papel) VALUES (2002, 2, 'ADJUDICANTE');
INSERT INTO CONTRATO_ENTIDADE (id_contrato, id_entidade, papel) VALUES (2002, 6, 'ADJUDICATARIO');

INSERT INTO CONTRATO_ENTIDADE (id_contrato, id_entidade, papel) VALUES (2003, 3, 'ADJUDICANTE');
INSERT INTO CONTRATO_ENTIDADE (id_contrato, id_entidade, papel) VALUES (2003, 8, 'ADJUDICATARIO');

INSERT INTO CONTRATO_ENTIDADE (id_contrato, id_entidade, papel) VALUES (2004, 4, 'ADJUDICANTE');
INSERT INTO CONTRATO_ENTIDADE (id_contrato, id_entidade, papel) VALUES (2004, 7, 'ADJUDICATARIO');

INSERT INTO CONTRATO_ENTIDADE (id_contrato, id_entidade, papel) VALUES (2005, 2, 'ADJUDICANTE');
INSERT INTO CONTRATO_ENTIDADE (id_contrato, id_entidade, papel) VALUES (2005, 9, 'ADJUDICATARIO');

COMMIT;