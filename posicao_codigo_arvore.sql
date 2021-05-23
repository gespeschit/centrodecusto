CREATE SCHEMA if not exists utilitarios; 
 
DROP FUNCTION if EXISTS utilitarios.posicao_codigo_arvore(varchar, 
                                                          varchar, 
                                                          varchar, 
                                                          varchar, 
                                                          varchar, 
                                                          varchar, 
                                                          varchar ); 
CREATE OR REPLACE FUNCTION utilitarios.posicao_codigo_arvore(pschema varchar DEFAULT 'public'::varchar, 
                                                             ptabela varchar DEFAULT ''::varchar, 
                                                             pcampocodigo varchar DEFAULT ''::varchar, 
                                                             pcampodescricao varchar DEFAULT ''::varchar, 
                                                             pcamponatureza varchar DEFAULT ''::varchar, 
                                                             pcamposinteticoanalitico varchar DEFAULT ''::varchar, 
                                                             pcampoativo varchar DEFAULT ''::varchar) 
 RETURNS TABLE(retorno boolean, 
               menssagem text, 
               id integer, 
               codigo varchar, 
               descricao varchar, 
               natureza varchar, 
               sintetico boolean, 
               ativo boolean, 
               posicao integer, 
               nivel integer) 
 LANGUAGE plpgsql 
AS $$ 
DECLARE 
  lErro boolean :=false; 
  cErroDescricao text :=''; 
  cMsg text :='Ordenação gerada com sucesso.'; 
  cQuery text :=''; 
BEGIN 
    pSchema:=coalesce(pSchema,''); 
    pTabela:=coalesce(pTabela,''); 
    pCampoCodigo:=coalesce(pCampoCodigo,''); 
    pCampoDescricao:=coalesce(pCampoDescricao,''); 
    pCampoNatureza:=coalesce(pCampoNatureza,''); 
    pCampoSinteticoAnalitico:=coalesce(pCampoSinteticoAnalitico,''); 
    pCampoAtivo:=coalesce(pCampoAtivo,''); 
    if trim(pSchema)='' then  
      pSchema:='public'; 
    end if; 

        cQuery:=format(' 
        select true::boolean, 
           ''%s''::text, 
           id::integer, 
           codigo::varchar, 
           descricao::varchar, 
           natureza::varchar, 
           sintetico::boolean, 
           ativo::boolean,                          
           row_number() over (partition by 0) ::int as posicao, 
             case when n1>0 and n2=0 then  
                         1                                                               
                  when n2>0 and n3=0 then 
                         2 
                  when n3>0 and n4=0 then 
                         3 
                  when n4>0 and n5=0 then 
                         4 
                  when n5>0 and n6=0 then 
                         5 
                  when n6>0 and n7=0 then 
                         6 
                  when n7>0 and n8=0 then 
                         7 
                  when n8>0 and n9=0 then 
                         8 
                  when n9>0 and n10=0 then 
                         9 
                  when n10>0 and n11=0 then 
                         10 
                  when n11>0 and n12=0 then 
                         11 
                  when n12>0 and n13=0 then 
                         12 
                  when n13>0 and n14=0 then 
                         13 
                  when n14>0 and n15=0 then 
                         14 
                  when n15>0 and n16=0 then 
                         15 
                  when n16>0 and n17=0 then 
                         16 
                  when n17>0 and n18=0 then 
                         17 
                  when n18>0 and n19=0 then 
                         18 
                  when n19>0 and n20=0 then 
                         19 
                  when n20>0 then 
                         20 
            end::int as nivel                                    
          from (                                                                                                        
          select id, 
                 codigo, 
                 descricao, 
                 natureza, 
                 sintetico, 
                 ativo,  
                 posicao,           
                 case when col1>0 then col1 else 0 end as n1,                                                               
                 case when col2>0 then col2 else 0 end as n2,                                                               
                 case when col3>0 then col3 else 0 end as n3,                                                               
                 case when col4>0 then col4 else 0 end as n4,                                                               
                 case when col5>0 then col5 else 0 end as n5,                                                               
                 case when col6>0 then col6 else 0 end as n6,                                                               
                 case when col7>0 then col7 else 0 end as n7,                                                               
                 case when col8>0 then col8 else 0 end as n8,                                                               
                 case when col9>0 then col9 else 0 end as n9,                                                               
                 case when col10>0 then col10 else 0 end as n10,                                                            
                 case when col11>0 then col11 else 0 end as n11,                                                            
                 case when col12>0 then col12 else 0 end as n12,                                                            
                 case when col13>0 then col13 else 0 end as n13,                                                            
                 case when col14>0 then col14 else 0 end as n14,                                                            
                 case when col15>0 then col15 else 0 end as n15,                                                            
                 case when col16>0 then col16 else 0 end as n16,                                                            
                 case when col17>0 then col17 else 0 end as n17,                                                            
                 case when col18>0 then col18 else 0 end as n18,                                                            
                 case when col19>0 then col19 else 0 end as n19,                                                            
                 case when col20>0 then col20 else 0 end as n20                                              
             from (                                                                                                     
             select  id, 
                     codigo,                                                                                             
                     descricao,                                                                                              
                     natureza,                                                                                                 
                     sintetico,                                                                                                 
                     ativo::boolean as ativo,                                                                                                 
                     0 as posicao,                                                                                     
                     data[1] ::int as col1,                                                                                  
                     data[2] ::int as col2,                                                                                  
                     data[3] ::int as col3,                                                                                  
                     data[4] ::int as col4,                                                                                  
                     data[5] ::int as col5,                                                                                  
                     data[6] ::int as col6,                                                                                  
                     data[7] ::int as col7,                                                                                  
                     data[8] ::int as col8,                                                                                  
                     data[9] ::int as col9,                                                                                  
                     data[10] ::int as col10,                                                                                
                     data[11] ::int as col11,                                                                                
                     data[12] ::int as col12,                                                                                
                     data[13] ::int as col13,                                                                                
                     data[14] ::int as col14,                                                                                
                     data[15] ::int as col15,                                                                                
                     data[16] ::int as col16,                                                                                
                     data[17] ::int as col17,                                                                                
                     data[18] ::int as col18,                                                                                
                     data[19] ::int as col19,                                                                                
                     data[20] ::int as col20                                                                                 
             from (  
                   select string_to_array(%s,''.'','''') as data, 
                                              id as id, 
                                              %s as codigo, 
                                              %s as descricao, 
                                              %s as natureza, 
                                              %s as sintetico, 
                                              %s::boolean as ativo  
                                       from %s.%s 
                ) as res                                                                                                
             ) as resultado  
             order by 7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26                         
          ) as final',cMsg, 
                      pCampoCodigo, 
                      pCampoCodigo, 
                          pCampoDescricao, 
                          pCampoNatureza, 
                          pCampoSinteticoAnalitico, 
                          pCampoAtivo, 
                          pSchema, 
                          pTabela); 

    if trim(pSchema)!=''  
       and trim(pTabela)!=''  
       and trim(pCampoCodigo)!=''  
       and trim(pCampoDescricao)!=''  
       and trim(pCampoNatureza)!=''  
       and trim(pCampoSinteticoAnalitico)!=''  
       and trim(pCampoAtivo)!='' then  
       return query 
       execute cQuery; 
   else  
          if trim(pTabela)='' and not lErro then  
            cMsg:='Nome da tabela não definido. Favor revisar.'; 
              lErro:=true; 
          end if; 
          if trim(pCampoCodigo)='' and not lErro then  
            cMsg:='Campo código da tabela não definido. Favor revisar.'; 
              lErro:=true; 
          end if; 
        if trim(pCampoDescricao)='' and not lErro then  
            cMsg:='Campo descrição da tabela não definido. Favor revisar.'; 
              lErro:=true; 
        end if; 
        if trim(pCampoNatureza)='' and not lErro then  
            cMsg:='Campo natureza da tabela não definido. Favor revisar.'; 
            lErro:=true; 
        end if; 
        if trim(pCampoSinteticoAnalitico)='' and not lErro then  
            cMsg:='Campo sintético da tabela não definido. Favor revisar.'; 
            lErro:=true; 
        end if; 
        if trim(pCampoAtivo)=''  and not lErro then  
            cMsg:='Campo ativo da tabela não definido. Favor revisar.'; 
            lErro:=true; 
        end if; 
          return query 
        select false::boolean, 
             cMsg::text, 
             ''::varchar, 
             ''::varchar, 
             ''::varchar, 
             false::boolean, 
             false::boolean,                          
             0::int as posicao;   
       end if; 
       EXCEPTION 
            when others then 
              GET STACKED DIAGNOSTICS cErroDescricao = PG_EXCEPTION_CONTEXT; 
                cMsg:=FORMAT('Descrição: %s.'||CHR(13)||' Comando: %s',SQLERRM,cErroDescricao); 
                return query 
               select false::boolean, 
                    cMsg::text, 
                ''::varchar, 
                ''::varchar, 
                ''::varchar, 
                false::boolean, 
                false::boolean,                          
                0::int as posicao; 
END 
$$ 
; 
COMMENT ON FUNCTION utilitarios.posicao_codigo_arvore(varchar, varchar, varchar, varchar, varchar, varchar, varchar ) IS 'Retorna o nível e a posição de um código caracter formato 9.99.999.99999.';
