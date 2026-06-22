// Biblioteca
#Include "Totvs.ch"

/*/{Protheus.doc} CEP
Gatilho de CEP para preencher os campos Endereço
@author Arthur Bergamaschi
@since 18/06/2026
@version 1.0
/*/
User Function Cep()
    Local aArea     := GetArea()
    Local lContinua := .T.
    Private jJson
 
    // Busca o CEP conforme o campo informado
    jJson := u_zViaCep(M->ZZ1_CEP)
       
    // Se não veio erro
    If Type("jJson[erro]") == "U"
    
        // Atualiza os campos com o retorno da função
        M->ZZ1_RUA      := AllTrim(jJson['logradouro'])
        M->ZZ1_BAIRRO   := AllTrim(jJson['bairro'])
        M->ZZ1_MUNICI   := AllTrim(jJson['localidade'])
        M->ZZ1_UF       := AllTrim(jJson['uf'])
        If M->ZZ1_RUA != "" .And. M->ZZ1_BAIRRO != "" .And. M->ZZ1_MUNICI != "" .And. M->ZZ1_UF != ""
            M->ZZ1_PAIS := "Brasil"
        Else
            M->ZZ1_PAIS := "Estrangeiro"
        EndIf
 
        // Atualiza a tela
        GetDRefresh()
    EndIf
 
    RestArea(aArea)
Return lContinua
