DROP FUNCTION if exists utilitarios.strposicaoreversa(text,text);
CREATE OR REPLACE FUNCTION utilitarios.strposicaoreversa(cString text, cSubString text) 
  RETURNS integer AS 
$$ 
  DECLARE result INTEGER; 
  BEGIN 
    IF strpos(cString, cSubString) = 0 THEN 
      result:=0; 
    ELSEIF length(cSubString)=1 THEN 
      result:= 1 + length(cString) - strpos(reverse(cString), cSubString); 
    ELSE 
      result:= 2 + length(cString)- length(cSubString) - strpos(reverse(cString), reverse(cSubString)); 
    END IF; 
    RETURN result; 
  END; 
$$ 
  LANGUAGE plpgsql;
 
COMMENT ON FUNCTION utilitarios.strposicaoreversa(text,text) IS 'Retorna a posição do primeiro carcarter definido a esquerda.'; 
