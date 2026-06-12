//Biblioteca
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variáveis Static
Static cTitulo := "Cadastro de Pessoa"
Static cAliasMVC := "ZZ1"

/*/{Protheus.doc} zPessoa
Cadastro de Pessoa
@author Arthur Bergamaschi
@since 10/06/2026
@version 1.0
/*/
User Function zPessoa()
    Local oBrowse
    Local aRotina := {}

    aRotina := MenuDef()

    oBrowse := FWMBrowse():New()
    oBrowse:SetDescription(cTitulo)
    oBrowse:SetAlias(cAliasMVC)
    oBrowse:Activate()

Return Nil

/*/{Protheus.doc} MenuDef
Menu de opcoes na funcao zPessoa
@author Arthur Bergamaschi
@since 11/06/2026
@version 1.0
@type function
/*/
Static Function MenuDef()
    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.zPessoa" OPERATION 1 ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.zPessoa" OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.zPessoa" OPERATION 4 ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.zPessoa" OPERATION 5 ACCESS 0
    ADD OPTION aRotina TITLE "Copiar" ACTION "VIEWDEF.zPessoa" OPERATION 9 ACCESS 0
    ADD OPTION aRotina TITLE "Imprir Cadastro" ACTION "U_Imprimir()" OPERATION 1 ACCESS 0

Return aRotina

/*/{Protheus.doc} MenuDef
Model de dados
@author Arthur Bergamaschi
@since 11/06/2026
@version 1.0
@type function
/*/
Static Function ModelDef()
    //Montando a estrutua da tabela no Struct
    Local oStruct := FWFormStruct(1, cAliasMVC)
    Local oModel

    oModel := MPFormModel():New("zPessoaModel")
    //Registrando os campos do Struct no MASTER dentro do model
    oModel:AddFields("ZZ1MASTER", Nil, oStruct)
    oModel:SetPrimaryKey({})

Return oModel

/*/{Protheus.doc} MenuDef
View dos campos
@author Arthur Bergamaschi
@since 12/06/2026
@version 1.0
@type function
/*/
Static Function ViewDef()
    Local oModel := FWLoadModel("zPessoa")
    Local oStruct := FWFormStruct(2, cAliasMVC)
    Local oView

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZZ1", oStruct, "ZZ1MASTER")
    oView:CreateHorizontalBox("Tela", 100)
    oView:SetOwnerView("VIEW_ZZ1", "Tela")

Return oView

User Function Imprimir()
    
    fMontaRel()

Return 

Static Function fMontaRel()
    Local oPrintPvt
    Local cQryPes := ""
    Local cCod := ZZ1->ZZ1_COD
    ConOut(cCod)

    cQryPes := "SELECT "                          + CRLF
    cQryPes += "    ZZ1_FILIAL, "                 + CRLF
    cQryPes += "    ZZ1_COD, "                    + CRLF
    cQryPes += "    ZZ1_NOME, "                   + CRLF
    cQryPes += "    ZZ1_SEXO, "                   + CRLF
    cQryPes += "    ZZ1_DTNASC, "                 + CRLF
    cQryPes += "    ZZ1_IDADE, "                  + CRLF
    cQryPes += "    ZZ1_CEP, "                    + CRLF
    cQryPes += "    ZZ1_RUA, "                    + CRLF
    cQryPes += "    ZZ1_NUMRUA, "                 + CRLF
    cQryPes += "    ZZ1_UF, "                     + CRLF
    cQryPes += "    ZZ1_MUNICI, "                 + CRLF
    cQryPes += "    ZZ1_DDD, "                    + CRLF
    cQryPes += "    ZZ1_FONE "                    + CRLF
    cQryPes += "FROM "                            + CRLF
    cQryPes += "    " + RetSQLName(cAliasMVC)     + CRLF
    cQryPes += "WHERE "                           + CRLF
    cQryPes += "    ZZ1_COD = '" + cCod + "' "    + CRLF
    cQryPes += "    AND D_E_L_E_T_ = ' ' "        + CRLF
    ConOut(cQryPes)
    TCQuery cQryPes New Alias "QRY_PES"

Return oPrintPvt
