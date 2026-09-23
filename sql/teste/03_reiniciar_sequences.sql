-- =====================================================================
-- Use SÓ se quiser rodar o teste de novo depois de um ROLLBACK.
-- O ROLLBACK desfaz os dados, mas NÃO volta as sequences para 1;
-- este script recria as sequences para os códigos voltarem a ser 1, 2, 3...
-- Não use se as tabelas tiverem dados de verdade.
-- =====================================================================
DROP SEQUENCE seq_usuario;
DROP SEQUENCE seq_conta;
DROP SEQUENCE seq_transacao;
DROP SEQUENCE seq_investimento;

CREATE SEQUENCE seq_usuario      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_conta        START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_transacao    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE seq_investimento START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
