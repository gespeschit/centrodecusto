# Centro de Custo Financeiro

O centro de custo financeiro é uma importante ferramenta de gestão de custos que separa a empresa em setores ou projetos, dependendo da sua atuação. Cada centro de custo possui uma parcela independente de responsabilidades, seja operacional ou financeira, e todos juntos representam a empresa como um todo.

Neste procurei desenvolver utilizando a tecnologia PL/PGSQL do PostgreSQL. Ele possui níveis dinâmicos onde poderá ser representado conforme abaixo:

- 1- Despesa  
- 1.1- Folha de Pagamento
- 1.1.1- Salário
- 1.1.2-Férias
- 1.1.3-13͒͒͒͒० Salário
- 1.1.4-INSS
- 1.1.5-IRPF
- 1.1.6-Descontos
- 1.1.7-Aviso Prévio
- 1.1.8-Vale Transporte
- 1.1.9-Vale Refeição
- 1.1.10-FGTS

Como o código de centro de custo foi criado em um campo string, ao fazer a ordenação teríamos 1,1.1,1.1.1,1.1.10,1.1.2 ... 1.1.9. 
# Inclusão
Ao realizar a inclusão de registro, retornará o primeiro campo boolean, onde se ocorrer algum erro terá o valor de false. Na segunda coluna retornar a descrição. Os campos seguintes serão de acordo com a tabela.

## Função
- _cadastro_inclui_centro_custo(pCodigo, pDescricao, pNatureza, pAtivo )

## Parâmetros da Função
- pCodigo - Código hierárquico do centro de custo.
- pDescricao - descrição do centro de custo.
- pNatureza - Natureza financeira do centro de custo. No caso seria “D” para despesa e “R” para receita.
- pAtivo - Se o centro de custo estiver ativo para o lançamento financeiro. True sim e false não.

## Exemplo
```yaml
select * from _cadastro_inclui_centro_custo('1', 'DESPESA', 'D', true );
select * from _cadastro_inclui_centro_custo('1.1', 'FOLHA DE PAGAMENTO', 'D', true );
select * from _cadastro_inclui_centro_custo('1.1.1', 'SALÁRIO', 'D', false );
select * from _cadastro_inclui_centro_custo('1.1.2', 'FÉRIAS', 'D', false );
select * from _cadastro_inclui_centro_custo('1.1.3', '13 SALÁRIO', 'D', false );
select * from _cadastro_inclui_centro_custo('1.1.4', 'INSS', 'D', false );
select * from _cadastro_inclui_centro_custo('1.1.5', 'IRPF', 'D', false );
select * from _cadastro_inclui_centro_custo('1.1.6', 'DESCONTOS', 'D', false );
select * from _cadastro_inclui_centro_custo('1.1.7', 'AVISO PRÉVIO', 'D', false );
select * from _cadastro_inclui_centro_custo('1.1.8', 'VALE TRANSPORTE', 'D', false );
select * from _cadastro_inclui_centro_custo('1.1.9', 'VALE REFEIÇÃO', 'D', false );
select * from _cadastro_inclui_centro_custo('1.1.10', 'FGTS', 'D', false );
```

# Edição
Os parâmetros da função podem devem ser preenchidos da esqueda para a direita, isto é, é obrigatório o preenchimento do primeiro parâmtro e os demais quando se fizer necessário.

## Função
- _cadastro_edita_centro_de_custo(pId, pCodigo, pDescricao, pNatureza, pSintetico, pAtivo)

## Parâmetros da Função
- pId - Identificação única do registro na tabela.
- pCodigo - Código hierárquico do centro de custo.
- pDescricao - descrição do centro de custo.
- pNatureza - Natureza financeira do centro de custo. No caso seria “D” para despesa e “R” para receita.
- pSintetico - Se o centro de custo é análitico ou sintético.
- pAtivo - Se o centro de custo estiver ativo para o lançamento financeiro. True sim e false não

## Exemplo
```yaml
select * from _cadastro_edita_centro_de_custo(3,'1','RECEITA'); 
```
# Exclusão
Ao excluir, a função retorna o registro excluído. Se houver qualquer erro, o primeiro campo retornará falso (false) onde o segundo campo terá a descrição do erro. Caso contrário retornará verdadeiro (true).
## Função
- _cadastro_exclui_centro_custo(pId)

## Parâmetros da Função
- pId - Identificação única do registro na tabela.


## Exemplo
```yaml
select * from _cadastro_exclui_centro_custo(1); 
```
# Listagem
Não possui parâmetros. Lista por ordem de código de centro de custo hierárquico.
## Função
- _cadastro_lista_centro_de_custo();

## Exemplo
```yaml
select * from _cadastro_lista_centro_de_custo();
```
---
### Tecnologia usada na construção do projeto

- [PostgreSQL](https://www.postgresql.org/)

#### Redes Sociais
[![Twitter Badge](https://img.shields.io/badge/-@gespeschit-1ca0f1?style=flat-square&labelColor=1ca0f1&logo=twitter&logoColor=white&link=https://twitter.com/gespeschit)](https://twitter.com/gespeschit) [![Linkedin Badge](https://img.shields.io/badge/-Guilherme-blue?style=flat-square&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/gespeschit/)](https://www.linkedin.com/in/gespeschit/) 

