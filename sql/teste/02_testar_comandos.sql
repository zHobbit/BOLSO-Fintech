-- =====================================================================
-- PASSO 2 — Testar os comandos do PDF com valores reais
--
-- São os MESMOS comandos do PDF; só troquei cada [MÁSCARA] por um valor.
-- Rode um comando por vez com Ctrl+Enter e compare com o "ESPERADO".
-- Antes, crie a estrutura rodando o DDL da Fase 3 (../../fintech_modelo_fisico.sql).
-- Os códigos (1, 2, 3...) assumem sequences recém-criadas e tabelas
-- vazias. Se o seu usuário recebeu outro código no teste 4.1, use esse
-- número no lugar de 1 nos comandos seguintes.
-- =====================================================================

-- ---------------------------------------------------------------------
-- PREPARAÇÃO: categorias (não fazem parte da atividade, mas toda
-- receita/despesa precisa de uma categoria). Códigos altos para não
-- colidir com categorias que você já tenha.
-- ---------------------------------------------------------------------
INSERT INTO T_CATEGORIA (cd_categoria, nome, tipo) VALUES (9001, 'Salário', 'R');
INSERT INTO T_CATEGORIA (cd_categoria, nome, tipo) VALUES (9002, 'Alimentação', 'D');
INSERT INTO T_CATEGORIA (cd_categoria, nome, tipo) VALUES (9003, 'Transporte', 'D');
-- ESPERADO: "1 linha inserido." três vezes

-- =====================================================================
-- 4. CADASTRO
-- =====================================================================

-- 4.1 Novo usuário
INSERT INTO T_USUARIO (cd_usuario, nome, email, senha_hash, cpf,
                       data_nascimento, data_cadastro, ativo)
VALUES (seq_usuario.NEXTVAL, 'Maria Teste', 'maria.teste@bolso.com.br',
        'hash123', '12345678901',
        TO_DATE('15/03/1998', 'DD/MM/YYYY'), SYSTIMESTAMP, 1);
-- ESPERADO: 1 linha inserido.
-- Confira o código gerado:
SELECT cd_usuario, nome FROM T_USUARIO WHERE email = 'maria.teste@bolso.com.br';
-- ESPERADO: cd_usuario = 1

-- 4.2 Conta bancária do usuário 1
INSERT INTO T_CONTA (cd_conta, cd_usuario, nome_conta, tipo_conta, saldo_atual,
                     moeda, instituicao, data_abertura, ativa)
VALUES (seq_conta.NEXTVAL, 1, 'Conta Principal', 'CORRENTE',
        2500.00, 'BRL', 'Banco Bolso',
        TO_DATE('01/01/2026', 'DD/MM/YYYY'), 1);
-- ESPERADO: 1 linha inserido. (cd_conta = 1)

-- 4.3 Receita do usuário 1, na conta 1
INSERT INTO T_TRANSACAO (cd_transacao, cd_conta, cd_categoria, cd_transacao_par,
                         tipo, valor, descricao, data_transacao, data_efetivacao,
                         efetivada, recorrente, data_registro)
SELECT seq_transacao.NEXTVAL, c.cd_conta, 9001, NULL,
       'RECEITA', 5000.00, 'Salário de setembro',
       TO_DATE('05/09/2026', 'DD/MM/YYYY'),
       TO_DATE('05/09/2026', 'DD/MM/YYYY'),
       1, 1, SYSTIMESTAMP
  FROM T_CONTA c
 WHERE c.cd_conta   = 1
   AND c.cd_usuario = 1;
-- ESPERADO: 1 linha inserido. (cd_transacao = 1)

-- 4.4 Três despesas do usuário 1 (datas fora de ordem de propósito,
--     para testar a ordenação depois)
INSERT INTO T_TRANSACAO (cd_transacao, cd_conta, cd_categoria, cd_transacao_par,
                         tipo, valor, descricao, data_transacao, data_efetivacao,
                         efetivada, recorrente, data_registro)
SELECT seq_transacao.NEXTVAL, c.cd_conta, 9002, NULL,
       'DESPESA', 350.90, 'Mercado',
       TO_DATE('05/09/2026', 'DD/MM/YYYY'),
       TO_DATE('05/09/2026', 'DD/MM/YYYY'),
       1, 0, SYSTIMESTAMP
  FROM T_CONTA c
 WHERE c.cd_conta   = 1
   AND c.cd_usuario = 1;
-- ESPERADO: 1 linha inserido. (cd_transacao = 2)

INSERT INTO T_TRANSACAO (cd_transacao, cd_conta, cd_categoria, cd_transacao_par,
                         tipo, valor, descricao, data_transacao, data_efetivacao,
                         efetivada, recorrente, data_registro)
SELECT seq_transacao.NEXTVAL, c.cd_conta, 9003, NULL,
       'DESPESA', 42.50, 'Uber para o trabalho',
       TO_DATE('20/09/2026', 'DD/MM/YYYY'),
       TO_DATE('20/09/2026', 'DD/MM/YYYY'),
       1, 0, SYSTIMESTAMP
  FROM T_CONTA c
 WHERE c.cd_conta   = 1
   AND c.cd_usuario = 1;
-- ESPERADO: 1 linha inserido. (cd_transacao = 3)

INSERT INTO T_TRANSACAO (cd_transacao, cd_conta, cd_categoria, cd_transacao_par,
                         tipo, valor, descricao, data_transacao, data_efetivacao,
                         efetivada, recorrente, data_registro)
SELECT seq_transacao.NEXTVAL, c.cd_conta, 9002, NULL,
       'DESPESA', 89.00, 'Restaurante',
       TO_DATE('12/09/2026', 'DD/MM/YYYY'),
       TO_DATE('12/09/2026', 'DD/MM/YYYY'),
       1, 0, SYSTIMESTAMP
  FROM T_CONTA c
 WHERE c.cd_conta   = 1
   AND c.cd_usuario = 1;
-- ESPERADO: 1 linha inserido. (cd_transacao = 4)

-- TESTE DE SEGURANÇA: despesa na conta 1 dizendo que o dono é o usuário 999
INSERT INTO T_TRANSACAO (cd_transacao, cd_conta, cd_categoria, cd_transacao_par,
                         tipo, valor, descricao, data_transacao, data_efetivacao,
                         efetivada, recorrente, data_registro)
SELECT seq_transacao.NEXTVAL, c.cd_conta, 9002, NULL,
       'DESPESA', 1.00, 'NÃO DEVE ENTRAR',
       TO_DATE('01/09/2026', 'DD/MM/YYYY'), NULL,
       0, 0, SYSTIMESTAMP
  FROM T_CONTA c
 WHERE c.cd_conta   = 1
   AND c.cd_usuario = 999;
-- ESPERADO: 0 linhas inserido. (a conta 1 não é do usuário 999)

-- 4.5 Dois investimentos do usuário 1
INSERT INTO T_INVESTIMENTO (cd_investimento, cd_usuario, cd_conta, nome_ativo,
                            tipo_investimento, instituicao, valor_investido,
                            valor_atual, rentabilidade_esperada, data_inicio,
                            data_vencimento, status, observacao)
VALUES (seq_investimento.NEXTVAL, 1, 1,
        'Tesouro Selic 2029', 'RENDA_FIXA', 'Tesouro Direto',
        1000.00, 1000.00, 10.5,
        TO_DATE('01/08/2026', 'DD/MM/YYYY'),
        TO_DATE('01/03/2029', 'DD/MM/YYYY'),
        'ATIVO', 'Reserva de emergência');
-- ESPERADO: 1 linha inserido. (cd_investimento = 1)

INSERT INTO T_INVESTIMENTO (cd_investimento, cd_usuario, cd_conta, nome_ativo,
                            tipo_investimento, instituicao, valor_investido,
                            valor_atual, rentabilidade_esperada, data_inicio,
                            data_vencimento, status, observacao)
VALUES (seq_investimento.NEXTVAL, 1, 1,
        'CDB Banco Bolso', 'RENDA_FIXA', 'Banco Bolso',
        2000.00, 2000.00, 12.0,
        TO_DATE('15/09/2026', 'DD/MM/YYYY'),
        TO_DATE('15/09/2028', 'DD/MM/YYYY'),
        'ATIVO', 'Aplicação mensal');
-- ESPERADO: 1 linha inserido. (cd_investimento = 2)

-- =====================================================================
-- 5. ALTERAÇÃO
-- =====================================================================

-- 5.1 Alterar usuário 1
UPDATE T_USUARIO
   SET nome            = 'Maria Teste Silva',
       email           = 'maria.silva@bolso.com.br',
       data_nascimento = TO_DATE('15/03/1998', 'DD/MM/YYYY'),
       ativo           = 1
 WHERE cd_usuario = 1;
-- ESPERADO: 1 linha atualizado.

-- 5.2 Alterar receita 1 do usuário 1
UPDATE T_TRANSACAO t
   SET t.cd_categoria    = 9001,
       t.valor           = 5200.00,
       t.descricao       = 'Salário de setembro + bônus',
       t.data_transacao  = TO_DATE('05/09/2026', 'DD/MM/YYYY'),
       t.data_efetivacao = TO_DATE('05/09/2026', 'DD/MM/YYYY'),
       t.efetivada       = 1
 WHERE t.cd_transacao = 1
   AND t.tipo         = 'RECEITA'
   AND t.cd_conta IN (SELECT c.cd_conta
                        FROM T_CONTA c
                       WHERE c.cd_usuario = 1);
-- ESPERADO: 1 linha atualizado.

-- 5.3 Alterar despesa 3 do usuário 1
UPDATE T_TRANSACAO t
   SET t.cd_categoria    = 9003,
       t.valor           = 45.00,
       t.descricao       = 'Uber para o trabalho (corrigido)',
       t.data_transacao  = TO_DATE('20/09/2026', 'DD/MM/YYYY'),
       t.data_efetivacao = TO_DATE('20/09/2026', 'DD/MM/YYYY'),
       t.efetivada       = 1
 WHERE t.cd_transacao = 3
   AND t.tipo         = 'DESPESA'
   AND t.cd_conta IN (SELECT c.cd_conta
                        FROM T_CONTA c
                       WHERE c.cd_usuario = 1);
-- ESPERADO: 1 linha atualizado.

-- TESTE DE SEGURANÇA: mesma despesa, mas com o usuário errado
UPDATE T_TRANSACAO t
   SET t.valor = 0.01
 WHERE t.cd_transacao = 3
   AND t.tipo         = 'DESPESA'
   AND t.cd_conta IN (SELECT c.cd_conta
                        FROM T_CONTA c
                       WHERE c.cd_usuario = 999);
-- ESPERADO: 0 linhas atualizado.

-- TESTE DE SEGURANÇA: tentar alterar a RECEITA 1 usando o comando de despesa
UPDATE T_TRANSACAO t
   SET t.valor = 0.01
 WHERE t.cd_transacao = 1
   AND t.tipo         = 'DESPESA'
   AND t.cd_conta IN (SELECT c.cd_conta
                        FROM T_CONTA c
                       WHERE c.cd_usuario = 1);
-- ESPERADO: 0 linhas atualizado.

-- 5.4 Alterar investimento 1 do usuário 1
UPDATE T_INVESTIMENTO
   SET nome_ativo             = 'Tesouro Selic 2029',
       tipo_investimento      = 'RENDA_FIXA',
       instituicao            = 'Tesouro Direto',
       valor_investido        = 1000.00,
       valor_atual            = 1050.00,
       rentabilidade_esperada = 10.5,
       data_vencimento        = TO_DATE('01/03/2029', 'DD/MM/YYYY'),
       status                 = 'ATIVO',
       observacao             = 'Reserva de emergência (rendeu R$ 50)'
 WHERE cd_investimento = 1
   AND cd_usuario      = 1;
-- ESPERADO: 1 linha atualizado.

-- =====================================================================
-- 6. CONSULTAS SIMPLES
-- =====================================================================

-- 6.1 Usuário 1
SELECT cd_usuario, nome, email, cpf, data_nascimento, data_cadastro, ativo
  FROM T_USUARIO
 WHERE cd_usuario = 1;
-- ESPERADO: 1 linha — Maria Teste Silva / maria.silva@bolso.com.br

-- 6.2 Despesa 3 do usuário 1
SELECT t.cd_transacao, t.descricao, t.valor, t.data_transacao, t.data_efetivacao,
       t.efetivada, t.recorrente, cat.nome AS categoria, c.nome_conta, c.instituicao
  FROM T_TRANSACAO t
 INNER JOIN T_CONTA c       ON c.cd_conta       = t.cd_conta
 INNER JOIN T_CATEGORIA cat ON cat.cd_categoria = t.cd_categoria
 WHERE t.cd_transacao = 3
   AND t.tipo         = 'DESPESA'
   AND c.cd_usuario   = 1;
-- ESPERADO: 1 linha — Uber para o trabalho (corrigido) / 45 / Transporte / Conta Principal

-- 6.3 Investimento 1 do usuário 1
SELECT i.cd_investimento, i.nome_ativo, i.tipo_investimento, i.instituicao,
       i.valor_investido, i.valor_atual, i.rentabilidade_esperada, i.data_inicio,
       i.data_vencimento, i.status, i.observacao, c.nome_conta
  FROM T_INVESTIMENTO i
 INNER JOIN T_CONTA c ON c.cd_conta = i.cd_conta
 WHERE i.cd_investimento = 1
   AND i.cd_usuario      = 1;
-- ESPERADO: 1 linha — Tesouro Selic 2029 / valor_atual 1050

-- =====================================================================
-- 7. CONSULTAS ORDENADAS
-- =====================================================================

-- 7.1 Despesas do usuário 1, da mais recente à mais antiga
SELECT t.cd_transacao, t.descricao, t.valor, t.data_transacao, t.efetivada,
       cat.nome AS categoria, c.nome_conta
  FROM T_TRANSACAO t
 INNER JOIN T_CONTA c       ON c.cd_conta       = t.cd_conta
 INNER JOIN T_CATEGORIA cat ON cat.cd_categoria = t.cd_categoria
 WHERE c.cd_usuario = 1
   AND t.tipo       = 'DESPESA'
 ORDER BY t.data_transacao DESC, t.cd_transacao DESC;
-- ESPERADO: 3 linhas, nesta ordem:
--   3 Uber (20/09)  ->  4 Restaurante (12/09)  ->  2 Mercado (05/09)
--   (a receita 1 NÃO aparece)

-- 7.2 Investimentos do usuário 1, do mais recente ao mais antigo
SELECT i.cd_investimento, i.nome_ativo, i.tipo_investimento, i.instituicao,
       i.valor_investido, i.valor_atual, i.data_inicio, i.data_vencimento, i.status
  FROM T_INVESTIMENTO i
 WHERE i.cd_usuario = 1
 ORDER BY i.data_inicio DESC, i.cd_investimento DESC;
-- ESPERADO: 2 linhas: 2 CDB Banco Bolso (15/09) -> 1 Tesouro Selic 2029 (01/08)

-- =====================================================================
-- 8. DASHBOARD
-- =====================================================================
SELECT u.cd_usuario,
       u.nome,
       u.email,
       NVL(s.saldo_total, 0) AS saldo_total,
       d.cd_transacao        AS cd_ultima_despesa,
       d.descricao           AS descricao_ultima_despesa,
       d.categoria           AS categoria_ultima_despesa,
       d.valor               AS valor_ultima_despesa,
       d.data_transacao      AS data_ultima_despesa,
       i.cd_investimento     AS cd_ultimo_investimento,
       i.nome_ativo          AS ativo_ultimo_investimento,
       i.tipo_investimento   AS tipo_ultimo_investimento,
       i.valor_investido     AS valor_ultimo_investimento,
       i.data_inicio         AS data_ultimo_investimento
  FROM T_USUARIO u
  LEFT JOIN (SELECT c.cd_usuario, SUM(c.saldo_atual) AS saldo_total
               FROM T_CONTA c
              WHERE c.ativa = 1
              GROUP BY c.cd_usuario) s
         ON s.cd_usuario = u.cd_usuario
  LEFT JOIN (SELECT c.cd_usuario, t.cd_transacao, t.descricao, cat.nome AS categoria,
                    t.valor, t.data_transacao,
                    ROW_NUMBER() OVER (PARTITION BY c.cd_usuario
                                       ORDER BY t.data_transacao DESC,
                                                t.cd_transacao DESC) AS posicao
               FROM T_TRANSACAO t
              INNER JOIN T_CONTA c       ON c.cd_conta       = t.cd_conta
              INNER JOIN T_CATEGORIA cat ON cat.cd_categoria = t.cd_categoria
              WHERE t.tipo = 'DESPESA') d
         ON d.cd_usuario = u.cd_usuario AND d.posicao = 1
  LEFT JOIN (SELECT inv.cd_usuario, inv.cd_investimento, inv.nome_ativo,
                    inv.tipo_investimento, inv.valor_investido, inv.data_inicio,
                    ROW_NUMBER() OVER (PARTITION BY inv.cd_usuario
                                       ORDER BY inv.data_inicio DESC,
                                                inv.cd_investimento DESC) AS posicao
               FROM T_INVESTIMENTO inv) i
         ON i.cd_usuario = u.cd_usuario AND i.posicao = 1
 WHERE u.cd_usuario = 1;
-- ESPERADO: EXATAMENTE 1 linha:
--   Maria Teste Silva | saldo 2500 | última despesa: 3 Uber ... 45 Transporte 20/09/2026
--   | último investimento: 2 CDB Banco Bolso RENDA_FIXA 2000 15/09/2026

-- =====================================================================
-- FIM. Nada acima foi gravado de verdade ainda (sem COMMIT).
--   ROLLBACK;  -> desfaz tudo (recomendado: deixa o banco limpo)
--   COMMIT;    -> grava os dados de teste
-- =====================================================================
