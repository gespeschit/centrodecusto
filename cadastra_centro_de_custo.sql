DROP FUNCTION if EXISTS public._cadastro_inclui_centro_custo(varchar, varchar, varchar, boolean ); 
CREATE OR REPLACE FUNCTION public._cadastro_inclui_centro_custo(pCodigo character varying DEFAULT ''::character varying, 
                                                               pDescricao character varying DEFAULT ''::character varying, 
                                                               pNatureza character varying DEFAULT 'D'::character varying, 
                                                               pSinteticoAnalitico boolean default false::boolean) 
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
    lRetorno boolean := true; 
    cMsg text := 'Registro incluído com sucesso!'; 
    cErroDescricao text :=''; 
    nId integer :=0; 
    cCodigo varchar :=''; 
    cDescricao varchar :=''; 
    cNatureza varchar :=''; 
    lAtivo boolean :=true; 
    lSinteticoAnalitico boolean :=false; 
    rUpdatePosicao record; 
    nIdPrincipal integer :=0; 
    nNivel integer :=0; 
  BEGIN 
	  ASSERT trim(pCodigo)!='' ,'Código com valor vazio. Favor revisar.'; 
	  ASSERT trim(pDescricao)!='' ,'Descrição do código '||trim(pCodigo)||' com valor vazio. Favor revisar.'; 
	  ASSERT (SELECT (trim(pNatureza)='D' OR trim(pNatureza)='R')::boolean) ,'A natureza financeira definida '||trim(pNatureza)||' não é valida. Os valores válidos são "D"- Despesas e "R" - Receitas. Favor revisar.'; 
	  ASSERT (SELECT count(*) FROM cadastro.centrodecusto WHERE trim(cadastro.centrodecusto.codigo)=trim(pCodigo))=0 ,'Código '||trim(pCodigo)||' já cadastrado. Favor revisar.'; 
	  SELECT utilitarios.strposicaoreversa(trim(pCodigo),'.') INTO nNivel; 
	  IF nNivel>1 THEN 
	  	 ASSERT (SELECT count(*) FROM cadastro.centrodecusto WHERE trim(cadastro.centrodecusto.codigo) LIKE substr(trim(pCodigo),1,nNivel-1)||'%')>0 ,'Código '||trim(pCodigo)||' não possui nível anterior. Favor revisar.'; 
	  END IF; 
	  if (trim(pCodigo)!='' and trim(pCodigo)!='') then 
           INSERT INTO cadastro.centrodecusto (codigo, descricao, natureza, sintetico) VALUES(trim(pCodigo), trim(upper(pDescricao)), trim(upper(pNatureza)), pSinteticoAnalitico) 
         returning cadastro.centrodecusto.id, 
                   cadastro.centrodecusto.codigo, 
                   cadastro.centrodecusto.descricao, 
                   cadastro.centrodecusto.natureza, 
                   cadastro.centrodecusto.sintetico, 
                   cadastro.centrodecusto.ativo 
         into nId, 
              cCodigo, 
              cDescricao, 
              cNatureza, 
              lSinteticoAnalitico, 
              lAtivo; 
        for rUpdatePosicao in select x.codigo, 
                                     x.posicao, 
                                     x.nivel 
                                  from utilitarios.posicao_codigo_arvore('cadastro','centrodecusto','codigo','descricao','natureza','sintetico','ativo') x 
                                  loop 
                                  if trim(rUpdatePosicao.codigo)!='' and rUpdatePosicao.posicao>0 then 
                                    UPDATE cadastro.centrodecusto SET posicao=rUpdatePosicao.posicao, nivel=rUpdatePosicao.nivel WHERE trim(cadastro.centrodecusto.codigo)=trim(rUpdatePosicao.codigo); 
                                    SELECT utilitarios.strposicaoreversa(trim(pCodigo),'.') INTO nNivel; 
                                    IF nNivel>1 THEN 
                                    	UPDATE cadastro.centrodecusto SET sintetico=true WHERE trim(cadastro.centrodecusto.codigo)=substr(trim(pCodigo),1,nNivel-1); 
                                    END IF; 
                                  end if; 
         end loop; 
      else 
         lRetorno:=false; 
         case when trim(pCodigo)=''  and trim(pDescricao)!='' then 
              cMsg:='Código com valor vazio. Favor revisar.'; 
            when trim(pCodigo)!='' and trim(pDescricao)='' then 
              cMsg:='Descrição com valor vazio. Favor revisar.'; 
            when trim(pCodigo)='' and trim(pDescricao)='' then 
              cMsg:='Código e descrição com valor vazio. Favor revisar.'; 
         end case; 
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
 
COMMENT ON FUNCTION  public._cadastro_inclui_centro_custo(varchar, varchar, varchar, boolean ) IS 'Inclui registro de centro de custo.'; 

