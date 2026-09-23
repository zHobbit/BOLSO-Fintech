-- =====================================================================
-- BOLSO — Sistema de Controle Financeiro Pessoal
-- Atividade: Criando junções entre tabelas (comandos DML — Oracle)
-- Victor Holanda de Oliveira — RM571263
--
-- Receitas e despesas ficam em T_TRANSACAO (coluna tipo = 'RECEITA' ou
-- 'DESPESA'). A transação pertence a uma conta (T_CONTA) e a conta
-- pertence ao usuário; por isso o usuário é identificado via T_CONTA.
-- Valores entre colchetes são máscaras de substituição.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 0. As chaves primárias são geradas pelas sequences que já fazem parte
--    do modelo físico da Fase 3 (fintech_modelo_fisico.sql):
--    seq_usuario, seq_conta, seq_transacao e seq_investimento.
-- ---------------------------------------------------------------------

-- =====================================================================
-- 1. CADASTRO
-- =====================================================================

-- 1.1 Cadastrar os dados de um novo usuário
INSERT INTO T_USUARIO (cd_usuario, nome, email, senha_hash, cpf,
                       data_nascimento, data_cadastro, ativo)
VALUES (seq_usuario.NEXTVAL, '[NOME DO USUÁRIO]', '[E-MAIL DO USUÁRIO]',
        '[HASH DA SENHA]', '[CPF DO USUÁRIO]',
        TO_DATE('[DATA DE NASCIMENTO]', 'DD/MM/YYYY'), SYSTIMESTAMP, 1);

-- 1.2 Cadastrar os dados da conta bancária de um usuário
INSERT INTO T_CONTA (cd_conta, cd_usuario, nome_conta, tipo_conta, saldo_atual,
                     moeda, instituicao, data_abertura, ativa)
VALUES (seq_conta.NEXTVAL, [CÓDIGO DO USUÁRIO], '[NOME DA CONTA]', '[TIPO DA CONTA]',
        [SALDO ATUAL], '[MOEDA]', '[INSTITUIÇÃO]',
        TO_DATE('[DATA DE ABERTURA]', 'DD/MM/YYYY'), 1);

-- 1.3 Cadastrar os dados de uma nova receita (entrada de dinheiro) para um usuário
--     (o SELECT garante que a conta informada pertence ao usuário)
INSERT INTO T_TRANSACAO (cd_transacao, cd_conta, cd_categoria, cd_transacao_par,
                         tipo, valor, descricao, data_transacao, data_efetivacao,
                         efetivada, recorrente, data_registro)
SELECT seq_transacao.NEXTVAL, c.cd_conta, [CÓDIGO DA CATEGORIA], NULL,
       'RECEITA', [VALOR DA RECEITA], '[DESCRIÇÃO DA RECEITA]',
       TO_DATE('[DATA DA RECEITA]', 'DD/MM/YYYY'),
       TO_DATE('[DATA DE EFETIVAÇÃO]', 'DD/MM/YYYY'),
       [EFETIVADA], [RECORRENTE], SYSTIMESTAMP
  FROM T_CONTA c
 WHERE c.cd_conta   = [CÓDIGO DA CONTA]
   AND c.cd_usuario = [CÓDIGO DO USUÁRIO];

-- 1.4 Cadastrar os dados de uma nova despesa (gasto) de um usuário
--     (o SELECT garante que a conta informada pertence ao usuário)
INSERT INTO T_TRANSACAO (cd_transacao, cd_conta, cd_categoria, cd_transacao_par,
                         tipo, valor, descricao, data_transacao, data_efetivacao,
                         efetivada, recorrente, data_registro)
SELECT seq_transacao.NEXTVAL, c.cd_conta, [CÓDIGO DA CATEGORIA], NULL,
       'DESPESA', [VALOR DA DESPESA], '[DESCRIÇÃO DA DESPESA]',
       TO_DATE('[DATA DA DESPESA]', 'DD/MM/YYYY'),
       TO_DATE('[DATA DE EFETIVAÇÃO]', 'DD/MM/YYYY'),
       [EFETIVADA], [RECORRENTE], SYSTIMESTAMP
  FROM T_CONTA c
 WHERE c.cd_conta   = [CÓDIGO DA CONTA]
   AND c.cd_usuario = [CÓDIGO DO USUÁRIO];

-- 1.5 Cadastrar os dados de um novo investimento feito por um usuário
INSERT INTO T_INVESTIMENTO (cd_investimento, cd_usuario, cd_conta, nome_ativo,
                            tipo_investimento, instituicao, valor_investido,
                            valor_atual, rentabilidade_esperada, data_inicio,
                            data_vencimento, status, observacao)
VALUES (seq_investimento.NEXTVAL, [CÓDIGO DO USUÁRIO], [CÓDIGO DA CONTA],
        '[NOME DO ATIVO]', '[TIPO DE INVESTIMENTO]', '[INSTITUIÇÃO]',
        [VALOR INVESTIDO], [VALOR ATUAL], [RENTABILIDADE ESPERADA],
        TO_DATE('[DATA DE INÍCIO]', 'DD/MM/YYYY'),
        TO_DATE('[DATA DE VENCIMENTO]', 'DD/MM/YYYY'),
        '[STATUS]', '[OBSERVAÇÃO]');

-- =====================================================================
-- 2. ALTERAÇÃO
-- =====================================================================

-- 2.1 Alterar os dados de um usuário (a partir do código do usuário)
UPDATE T_USUARIO
   SET nome            = '[NOME DO USUÁRIO]',
       email           = '[E-MAIL DO USUÁRIO]',
       data_nascimento = TO_DATE('[DATA DE NASCIMENTO]', 'DD/MM/YYYY'),
       ativo           = [ATIVO]
 WHERE cd_usuario = [CÓDIGO DO USUÁRIO];

-- 2.2 Alterar os dados de uma receita (código do usuário + código da receita)
UPDATE T_TRANSACAO t
   SET t.cd_categoria    = [CÓDIGO DA CATEGORIA],
       t.valor           = [VALOR DA RECEITA],
       t.descricao       = '[DESCRIÇÃO DA RECEITA]',
       t.data_transacao  = TO_DATE('[DATA DA RECEITA]', 'DD/MM/YYYY'),
       t.data_efetivacao = TO_DATE('[DATA DE EFETIVAÇÃO]', 'DD/MM/YYYY'),
       t.efetivada       = [EFETIVADA]
 WHERE t.cd_transacao = [CÓDIGO DA RECEITA]
   AND t.tipo         = 'RECEITA'
   AND t.cd_conta IN (SELECT c.cd_conta
                        FROM T_CONTA c
                       WHERE c.cd_usuario = [CÓDIGO DO USUÁRIO]);

-- 2.3 Alterar os dados de uma despesa (código do usuário + código da despesa)
UPDATE T_TRANSACAO t
   SET t.cd_categoria    = [CÓDIGO DA CATEGORIA],
       t.valor           = [VALOR DA DESPESA],
       t.descricao       = '[DESCRIÇÃO DA DESPESA]',
       t.data_transacao  = TO_DATE('[DATA DA DESPESA]', 'DD/MM/YYYY'),
       t.data_efetivacao = TO_DATE('[DATA DE EFETIVAÇÃO]', 'DD/MM/YYYY'),
       t.efetivada       = [EFETIVADA]
 WHERE t.cd_transacao = [CÓDIGO DA DESPESA]
   AND t.tipo         = 'DESPESA'
   AND t.cd_conta IN (SELECT c.cd_conta
                        FROM T_CONTA c
                       WHERE c.cd_usuario = [CÓDIGO DO USUÁRIO]);

-- 2.4 Alterar os dados de um investimento (código do usuário + código do investimento)
UPDATE T_INVESTIMENTO
   SET nome_ativo             = '[NOME DO ATIVO]',
       tipo_investimento      = '[TIPO DE INVESTIMENTO]',
       instituicao            = '[INSTITUIÇÃO]',
       valor_investido        = [VALOR INVESTIDO],
       valor_atual            = [VALOR ATUAL],
       rentabilidade_esperada = [RENTABILIDADE ESPERADA],
       data_vencimento        = TO_DATE('[DATA DE VENCIMENTO]', 'DD/MM/YYYY'),
       status                 = '[STATUS]',
       observacao             = '[OBSERVAÇÃO]'
 WHERE cd_investimento = [CÓDIGO DO INVESTIMENTO]
   AND cd_usuario      = [CÓDIGO DO USUÁRIO];

-- =====================================================================
-- 3. CONSULTAS SIMPLES
-- =====================================================================

-- 3.1 Consultar os dados de um usuário específico
SELECT cd_usuario, nome, email, cpf, data_nascimento, data_cadastro, ativo
  FROM T_USUARIO
 WHERE cd_usuario = [CÓDIGO DO USUÁRIO];

-- 3.2 Consultar os dados de uma despesa específica (código do usuário + código da despesa)
SELECT t.cd_transacao, t.descricao, t.valor, t.data_transacao, t.data_efetivacao,
       t.efetivada, t.recorrente, cat.nome AS categoria, c.nome_conta, c.instituicao
  FROM T_TRANSACAO t
 INNER JOIN T_CONTA c       ON c.cd_conta       = t.cd_conta
 INNER JOIN T_CATEGORIA cat ON cat.cd_categoria = t.cd_categoria
 WHERE t.cd_transacao = [CÓDIGO DA DESPESA]
   AND t.tipo         = 'DESPESA'
   AND c.cd_usuario   = [CÓDIGO DO USUÁRIO];

-- 3.3 Consultar os dados de um investimento específico (código do usuário + código do investimento)
SELECT i.cd_investimento, i.nome_ativo, i.tipo_investimento, i.instituicao,
       i.valor_investido, i.valor_atual, i.rentabilidade_esperada, i.data_inicio,
       i.data_vencimento, i.status, i.observacao, c.nome_conta
  FROM T_INVESTIMENTO i
 INNER JOIN T_CONTA c ON c.cd_conta = i.cd_conta
 WHERE i.cd_investimento = [CÓDIGO DO INVESTIMENTO]
   AND i.cd_usuario      = [CÓDIGO DO USUÁRIO];

-- =====================================================================
-- 4. CONSULTAS ORDENADAS
-- =====================================================================

-- 4.1 Consultar todas as despesas de um usuário (da mais recente à mais antiga)
SELECT t.cd_transacao, t.descricao, t.valor, t.data_transacao, t.efetivada,
       cat.nome AS categoria, c.nome_conta
  FROM T_TRANSACAO t
 INNER JOIN T_CONTA c       ON c.cd_conta       = t.cd_conta
 INNER JOIN T_CATEGORIA cat ON cat.cd_categoria = t.cd_categoria
 WHERE c.cd_usuario = [CÓDIGO DO USUÁRIO]
   AND t.tipo       = 'DESPESA'
 ORDER BY t.data_transacao DESC, t.cd_transacao DESC;

-- 4.2 Consultar todos os investimentos de um usuário (do mais recente ao mais antigo)
SELECT i.cd_investimento, i.nome_ativo, i.tipo_investimento, i.instituicao,
       i.valor_investido, i.valor_atual, i.data_inicio, i.data_vencimento, i.status
  FROM T_INVESTIMENTO i
 WHERE i.cd_usuario = [CÓDIGO DO USUÁRIO]
 ORDER BY i.data_inicio DESC, i.cd_investimento DESC;

-- =====================================================================
-- 5. CONSULTA PARA O DASHBOARD
--    Retorna UMA linha: dados do usuário + saldo total das contas ativas
--    + última despesa + último investimento. LEFT JOIN mantém a linha
--    mesmo que o usuário ainda não tenha despesas ou investimentos.
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
 WHERE u.cd_usuario = [CÓDIGO DO USUÁRIO];
