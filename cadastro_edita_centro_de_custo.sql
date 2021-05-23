DROP FUNCTION if EXISTS public._cadastro_edita_centro_de_custo(integer, varchar, varchar, varchar, boolean, boolean ); 
CREATE OR REPLACE FUNCTION public._cadastro_edita_centro_de_custo(pid integer DEFAULT 0, 
                                                              pcodigo character varying DEFAULT '.F.'::character varying, 
                                                              pdescricao character varying DEFAULT '.F.'::character varying, 
                                                              pnatureza character varying DEFAULT 'D'::character varying, 
                                                              psintetico boolean DEFAULT false, 
                                                              pativo boolean DEFAULT false) 
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
    cMsg text := 'Registro alterado com sucesso!'; 
    cErroDescricao text :=''; 
    nId integer :=0; 
    cCodigo varchar :=''; 
    cDescricao varchar :=''; 
    cNatureza varchar :=''; 
    lAtivo boolean :=true; 
    lSinteticoAnalitico boolean :=false; 
    cNewCodigo varchar :=''; 
    cNewDescricao varchar :=''; 
    cNewNatureza varchar :=''; 
    lNewAtivo boolean :=true; 
    lNewSinteticoAnalitico boolean :=false; 
    rUpdatePosicao record; 
    nI integer :=0; 
    lAlterou boolean :=false; 
    lTratarCondicao boolean :=true; 
    nNivel integer :=0;
  begin
	  ASSERT trim(pCodigo)!='' ,'Código com valor vazio. Favor revisar.'; 
	  ASSERT trim(pCodigo)!='.' ,'Código inválido. Favor revisar.'; 
	  ASSERT trim(pDescricao)!='' ,'Descrição do código '||trim(pCodigo)||' com valor vazio. Favor revisar.'; 
	  ASSERT (SELECT (trim(pNatureza)='D' OR trim(pNatureza)='R')::boolean) ,'A natureza financeira definida '||trim(pNatureza)||' não é valida. Os valores válidos são "D"- Despesas e "R" - Receitas. Favor revisar.'; 
	  SELECT utilitarios.strposicaoreversa(trim(pCodigo),'.') INTO nNivel;
	  IF nNivel>1 THEN 
	  	 ASSERT (SELECT count(*) FROM cadastro.centrodecusto WHERE trim(cadastro.centrodecusto.codigo) LIKE substr(trim(pCodigo),1,nNivel-1)||'%')>0 ,'Código '||trim(pCodigo)||' não possui nível anterior. Favor revisar.';
	  END IF; 
  	 SELECT trim(COALESCE(a.codigo,'')) INTO cCodigo FROM cadastro.centrodecusto a WHERE a.id=pId;
  	 IF cCodigo!='' AND trim(cCodigo)!=trim(pCodigo) THEN 
  	    SELECT utilitarios.strposicaoreversa(trim(cCodigo),'.') INTO nNivel;
  	    IF nNivel=0 THEN 
  	    	cCodigo:=cCodigo||'.';
  	        SELECT utilitarios.strposicaoreversa(trim(cCodigo),'.') INTO nNivel;
  	    END IF;
  	 	ASSERT (SELECT count(*) FROM cadastro.centrodecusto WHERE trim(cadastro.centrodecusto.codigo) LIKE substr(trim(cCodigo),1,nNivel+1)||'%')=0 ,'O código '||trim(cCodigo)||' não poderá ser alterado para '||trim(pCodigo)||', pois há niveis posteriores em '||trim(cCodigo)||'. Favor revisar.';
  	 END IF;
   if pId>0 and (pCodigo!='.F.' or pDescricao!='.F.' or pSintetico or pAtivo) and lTratarCondicao then 
    pCodigo:=trim(pCodigo); 
    pDescricao:=trim(upper(pDescricao)); 
      pNatureza:=trim(upper(pNatureza)); 
    select cadastro.centrodecusto.id, 
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
                lAtivo  
    from cadastro.centrodecusto 
    WHERE cadastro.centrodecusto.id=pId; 
    if nId>0 then 
      if trim(pCodigo)!='.F.'  then 
       cNewCodigo:=trim(pCodigo); 
       if trim(cNewCodigo)='' then 
              cNewCodigo:=trim(cCodigo); 
           else 
              if trim(cCodigo)!=trim(cNewCodigo) then 
                lAlterou:=true; 
              end if; 
           end if; 
      else 
         cNewCodigo:=trim(cCodigo); 
      end if; 
          if trim(pDescricao)!='.F.' then 
             cNewDescricao:=trim(pDescricao); 
             if trim(cNewDescricao)='' then 
                cNewDescricao:=trim(cDescricao);  
             else 
              if trim(cDescricao)!=trim(cNewDescricao) then 
                  lAlterou:=true; 
                end if; 
             end if; 
          else 
             cNewCodigo:=trim(cCodigo); 
          end if; 
          cNewNatureza:=trim(pNatureza); 
          if trim(cNatureza)!=trim(cNewNatureza) then 
            lAlterou:=true; 
          end if; 
         lNewSinteticoAnalitico:=pSintetico; 
          if lSinteticoAnalitico!=lNewSinteticoAnalitico then 
            lAlterou:=true; 
          end if;       
         if lAlterou then 
           UPDATE cadastro.centrodecusto SET codigo=trim(cNewCodigo), 
                                                     descricao=trim(upper(cNewDescricao)), 
                                                     natureza=trim(upper(cNewNatureza)), 
                                                     ativo=lNewAtivo, 
                                                     sintetico=lNewSinteticoAnalitico 
            WHERE cadastro.centrodecusto.id=pId 
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
                              end if; 
              end loop; 
              cMsg:='Registro foi alerado com sucesso.'; 
              lRetorno:=true; 
            else 
              cMsg:='Nenhum registro foi alterado. Favor revisar.'; 
              lRetorno:=false; 
            end if; 
            return query select lRetorno::boolean as retorno, 
                                cMsg::text as menssagem, 
                                nId::integer, 
                                cCodigo::varchar, 
                                cDescricao::varchar, 
                                cNatureza::varchar, 
                                lSinteticoAnalitico::boolean, 
                                lAtivo::boolean; 
    else 
      if lTratarCondicao then 
        cMsg:=FORMAT('Não for encontrado o registro de número %s. Favor revisar.',pId); 
        return query select false::boolean as retorno, 
                            cMsg::text as menssagem, 
                            nId::integer, 
                            cCodigo::varchar, 
                            cDescricao::varchar, 
                            cNatureza::varchar, 
                            lSinteticoAnalitico::boolean, 
                            lAtivo::boolean; 
        end if; 
    end if; 
  else 
     cMsg:='Parâmetros da função não foram preenchidos. Favor revisar.'; 
     return query select false::boolean as retorno, 
                         cMsg::text as menssagem, 
                         nId::integer, 
                         cCodigo::varchar, 
                         cDescricao::varchar, 
                         cNatureza::varchar, 
                         lSinteticoAnalitico::boolean, 
                         lAtivo::boolean; 
  
  end if; 
   
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

COMMENT ON FUNCTION public."_cadastro_edita_centro_de_custo"(int4,varchar,varchar,varchar,bool,bool) IS 'Edita registro do centro de custo.';
