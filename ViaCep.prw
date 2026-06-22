// Biblioteca
#Include "Totvs.ch"

/*/{Protheus.doc} zViaCep
[API.VIACEP] [GET] Conecta na Api gratuita da ViaCep para retornar dados de um Endereço
a partir do CEP.
Campos Disponiveis na API:  
BAIRRO, LOCALIDADE, LOGRADOURO, UF
Uso: Incluir/Atualizar CC2 quando necessário
@since      19/06/2026
/*/
User Function zViaCep(cCep)
   
    Local aArea         := GetArea()
    Local aHeader       := {}    
    Local oRestClient   := FWRest():New("https://viacep.com.br/ws")
    Local jJson         := JsonObject():New()
       
    Default cCep        := ''
   
    fConOut("[U_zViaCep] - Entrou na função que consulta as informações do endereco pelo CEP")
   
    //Retira espaços,traços e pontos caso receba assim dos parametros
    cCep := StrTran(StrTran(StrTran(cCep," ",""),"-",""),".","")
   
    aadd(aHeader,'User-Agent: Mozilla/4.0 (compatible; Protheus '+GetBuild()+')')
    aAdd(aHeader,'Content-Type: application/json; charset=utf-8')
   
    //[GET] Consulta Dados na Api
    oRestClient:setPath("/"+cCep+"/json/")
    If oRestClient:Get(aHeader)
            
        jJson:FromJson(oRestClient:CRESULT)          
   
        //Se as keys não existirem, cria elas com conteudo vazio.
        jJson['logradouro'] := Iif( ValType(jJson['logradouro'])  != "U", jJson['logradouro'] , "")
        jJson['bairro']     := Iif( ValType(jJson['bairro'])      != "U", jJson['bairro']     , "")
        jJson['localidade'] := Iif( ValType(jJson['localidade'])  != "U", jJson['localidade'] , "")
        jJson['uf']         := Iif( ValType(jJson['uf'])          != "U", jJson['uf']         , "")
   
        VarInfo("[U_zViaCep] - Resultado da consulta ->",jJson)
    Else
        fConOut("[U_zViaCep] - ** Erro Api ViaCep: "+oRestClient:GetLastError())
    Endif  
   
   jJson['erro']:=  Iif( ValType(jJson['cep']) == "U", "Api não retornou dados do cep: "+cValTochar(cCep) ,"")      
   
    fConOut("[U_zViaCep] - Finalizou na função que consulta as informações do endereco pelo CEP") 
   
    FreeObj(oRestClient)
    RestArea(aArea)
Return jJson
   
Static Function fConOut(cLog)
       
    Default cLog := "Log empty"
           
    FwLogMsg("INFO", /*cTransactionId*/, "fConOut", FunName(), "", "01", cLog, 0, 0, {})
                
Return
