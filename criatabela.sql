CREATE schema if not exists cadastro;

CREATE TABLE if not exists cadastro.centrodecusto (
	id serial NOT NULL, -- Código de idenficação única do registro.
	codigo varchar NOT NULL, -- Código hierárquico de identificação do centro de custo
	descricao varchar NOT NULL, -- Descrição do centro de custo
	ativo bool NOT NULL DEFAULT true, -- Se o centro de custo esta ativo para cadastrar em lançamento financeiro.
	natureza varchar(1) NOT NULL DEFAULT 'D'::character varying, -- Natureza financeira do centro de custo. R-Receita e D- Despesa.
	sintetico bool NOT NULL DEFAULT false, -- Se nível hierárquico do centro de custo é sintético.
	posicao int4 NOT NULL DEFAULT 0, -- Podição hierárquica do codigo do centro de custo.
	nivel int4 NOT NULL DEFAULT 0 -- Nível do código do centro de custo.
);
COMMENT ON TABLE cadastro.centrodecusto IS 'Centro de Custo Financeiro';

COMMENT ON COLUMN cadastro.centrodecusto.id IS 'Código de idenficação única do registro.';
COMMENT ON COLUMN cadastro.centrodecusto.codigo IS 'Código hierárquico de identificação do centro de custo';
COMMENT ON COLUMN cadastro.centrodecusto.descricao IS 'Descrição do centro de custo';
COMMENT ON COLUMN cadastro.centrodecusto.ativo IS 'Se o centro de custo esta ativo para cadastrar em lançamento financeiro.';
COMMENT ON COLUMN cadastro.centrodecusto.natureza IS 'Natureza financeira do centro de custo. R-Receita e D- Despesa.';
COMMENT ON COLUMN cadastro.centrodecusto.sintetico IS 'Se nível hierárquico do centro de custo é sintético.';
COMMENT ON COLUMN cadastro.centrodecusto.posicao IS 'Podição hierárquica do codigo do centro de custo.';
COMMENT ON COLUMN cadastro.centrodecusto.nivel IS 'Nível do código do centro de custo.';
