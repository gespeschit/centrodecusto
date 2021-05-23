DROP FUNCTION if EXISTS public._cadastro_lista_centro_de_custo(); 
CREATE OR REPLACE FUNCTION public._cadastro_lista_centro_de_custo() 
RETURNS TABLE(id integer,  
             codigo character varying,  
             descricao character varying,  
             natureza character varying, 
             nivel integer,  
             sintetico boolean,  
             ativo boolean) 
LANGUAGE plpgsql 
AS $$  
 declare  
  cMsg text := 'Listagem de registros.'; 
  cErroDescricao text :=''; 
  lRetorno boolean :=true; 

BEGIN 
  return query 
  select cadastro.centrodecusto.id::integer, 
         trim(cadastro.centrodecusto.codigo)::varchar as codigo, 
         trim(cadastro.centrodecusto.descricao)::varchar as descricao, 
         trim(cadastro.centrodecusto.natureza)::varchar as natureza, 
         cadastro.centrodecusto.nivel::integer as nivel, 
         cadastro.centrodecusto.sintetico::boolean as sintetico, 
         cadastro.centrodecusto.ativo::boolean as ativo 
  from cadastro.centrodecusto 
  order by cadastro.centrodecusto.posicao; 

END; 
$$ 
; 
 
COMMENT ON FUNCTION public._cadastro_lista_centro_de_custo() IS 'Lista registro de centro de custo.'; 
