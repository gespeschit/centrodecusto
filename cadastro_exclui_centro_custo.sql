DROP FUNCTION if EXISTS public._cadastro_exclui_centro_custo(integer ); 
CREATE OR REPLACE FUNCTION public._cadastro_exclui_centro_custo(pId integer default 0) 
 RETURNS TABLE(retorno boolean, 
               mensagem text, 
               id integer, 
               codigo character varying, 
               descricao character varying, 
               natureza character varying, 
               sintetico boolean, 
               ativo boolean) 
 LANGUAGE plpgsql 
AS $$ 
   declare 
    nRetorno integer :=0; 
    lRetorno boolean := true; 
    cMsg text := 'Registro excluido com sucesso.'; 
    cErroDescricao text :=''; 
    nId integer :=0; 
    cCodigo varchar :=''; 
    cDescricao varchar :=''; 
    cNatureza varchar :=''; 
    lAtivo boolean :=true; 
    lSinteticoAnalitico boolean :=false; 
    rUpdatePosicao record; 
    nI integer :=0; 
    nNivel integer :=0; 
    cCodigoVer varchar :=''; 
    nRegistros integer :=0; 
  BEGIN 
      if pId>0 then 
        SELECT trim(COALESCE(a.codigo,'')) INTO cCodigo FROM cadastro.centro_custo a WHERE a.id=pId; 
        IF cCodigo!='' THEN 
          cCodigoVer:=cCodigo||'.'; 
          SELECT utilitarios.strposicaoreversa(trim(cCodigoVer),'.') INTO nNivel; 
          ASSERT (SELECT count(*) FROM cadastro.centro_custo WHERE trim(cadastro.centro_custo.codigo) LIKE substr(trim(cCodigoVer),1,nNivel+3)||'%')=0 ,'O código '||trim(cCodigo)||' não poderá ser excluído porque há niveis posteriores em '||trim(cCodigo)||'. Favor revisar.'; 
         END IF; 
        delete from cadastro.centro_custo where cadastro.centro_custo.id=pId 
        returning cadastro.centro_custo.id, 
                   cadastro.centro_custo.codigo, 
                   cadastro.centro_custo.descricao, 
                   cadastro.centro_custo.natureza, 
                   cadastro.centro_custo.sintetico, 
                   cadastro.centro_custo.ativo 
         into nId, cCodigo, cDescricao, cNatureza, lSinteticoAnalitico, lAtivo; 
        for rUpdatePosicao in select x.codigo, 
                                     x.posicao, 
                                     x.nivel 
                                  from utilitarios.posicao_codigo_arvore('cadastro','centro_custo','codigo','descricao','natureza','sintetico','ativo') x 
                                  loop 
            if trim(rUpdatePosicao.codigo)!='' and rUpdatePosicao.posicao>0 then 
              UPDATE cadastro.centro_custo SET posicao=rUpdatePosicao.posicao, nivel=rUpdatePosicao.posicao WHERE trim(cadastro.centro_custo.codigo)=trim(rUpdatePosicao.codigo); 
            end if; 
         end loop;              
      else 
         lRetorno:=false; 
         cMsg:='Código de identificação do centro de custo dever ser maior que zero. Favor revisar.'; 
      end if; 
     return query select lRetorno::boolean as retorno, 
                         cMsg::text as menssagem, 
                         nId::integer, 
                         cCodigo::varchar, 
                         cDescricao::varchar, 
                         cNatureza::varchar, 
                         lSinteticoAnalitico::boolean, 
                         lAtivo::boolean; 
    EXCEPTION 
              when sqlstate 'P0004' then 
                GET STACKED DIAGNOSTICS cErroDescricao = PG_EXCEPTION_CONTEXT; 
                    lRetorno:=false; 
                    cMsg:=FORMAT('Descrição: %s.'||chr(13)||' Comando: %s',SQLERRM,cErroDescricao); 
                    return query select false::boolean as retorno, 
                                        cMsg::text as menssagem, 
                                        nId::integer, 
                                        cCodigo::varchar, 
                                        cDescricao::varchar, 
                                        cNatureza::varchar, 
                                        lSinteticoAnalitico::boolean, 
                                        lAtivo::boolean; 
              when others then 
                GET STACKED DIAGNOSTICS cErroDescricao = PG_EXCEPTION_CONTEXT; 
                lRetorno:=false; 
                cMsg:=FORMAT('Descrição: %s.'||chr(13)||' Comando: %s',SQLERRM,cErroDescricao); 
                return query select false::boolean as retorno, 
                                    cMsg::text as menssagem, 
                                    nId::integer, 
                                    cCodigo::varchar, 
                                    cDescricao::varchar, 
                                    cNatureza::varchar, 
                                    lSinteticoAnalitico::boolean, 
                                    lAtivo::boolean; 
 
  END; 
$$ 
; 
 
COMMENT ON FUNCTION  public._cadastro_exclui_centro_custo(integer ) IS 'Exclui o registro de centro de custo.'; 
