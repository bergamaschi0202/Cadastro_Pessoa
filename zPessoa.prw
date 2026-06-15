//Biblioteca
#Include "Totvs.ch"
#Include "FWMVCDef.ch"
#Include "TopConn.ch"

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
    //Variáveis
    Local aPergs := {}
    Local cCodDe := "000001"
    Local cCodAt := "999999"
    Local aReturn := {}
    Local oProcess

    aAdd(aPergs, {1, "Pessoa De", cCodDe, "", ".T.", "ZZ1", ".F.", 6, .T.})
    aAdd(aPergs, {1, "Pessoa Até", cCodAt, "", ".T.", "ZZ1", ".F.", 6, .T.})

    If ParamBox(aPergs, "Informe os parâmetros", @aReturn, , , , , , , , .F., .F.)
        cCodDe := aReturn[1]
        cCodAt := aReturn[2]

        oProcess := MsNewProcess():New({|| fMontaRel(@oProcess, cCodDe, cCodAt) }, "Impressão de Cadastros de Pessoas", "Processando", .F.)
        oProcess:Activate()
    EndIf

Return

Static Function fMontaRel(oProc, cCodDe, cCodAt)
    Local oPrintPvt
    Local cQryPes := ""
    Local cCod := ZZ1->ZZ1_COD
    ConOut(cCod)
    Local cNomeRel := "Relatório de Cadastro de Pessoas"
    Local nTotPes := 0

    oPrintPvt := FWMSPrinter():New(cNomeRel, IMP_PDF, .F., "", .T.)
    oPrintPvt:cPathPDF := GetTempPath()
    oPrintPvt:SetResolution(72)
    oPrintPvt:SetPortrait()
    oPrintPvt:SetPaperSize(DMPAPER_A4)
    oPrintPvt:SetMargin(60, 60, 60, 60)

    cQryPes := "SELECT "                                + CRLF
    cQryPes += "    ZZ1_FILIAL, "                       + CRLF
    cQryPes += "    ZZ1_COD, "                          + CRLF
    cQryPes += "    ZZ1_NOME, "                         + CRLF
    cQryPes += "    ZZ1_SEXO, "                         + CRLF
    cQryPes += "    ZZ1_DTNASC, "                       + CRLF
    cQryPes += "    ZZ1_IDADE, "                        + CRLF
    cQryPes += "    ZZ1_CEP, "                          + CRLF
    cQryPes += "    ZZ1_RUA, "                          + CRLF
    cQryPes += "    ZZ1_NUMRUA, "                       + CRLF
    cQryPes += "    ZZ1_UF, "                           + CRLF
    cQryPes += "    ZZ1_MUNICI, "                       + CRLF
    cQryPes += "    ZZ1_DDD, "                          + CRLF
    cQryPes += "    ZZ1_FONE "                          + CRLF
    cQryPes += "FROM "                                  + CRLF
    cQryPes += "    " + RetSQLName(cAliasMVC)           + CRLF
    cQryPes += "WHERE "                                 + CRLF
    cQryPes += "    ZZ1_COD >= '" + cCodDe + "' "       + CRLF
    cQryPes += "    AND ZZ1_COD <= '" + cCodAt + "' "   + CRLF
    cQryPes += "    AND D_E_L_E_T_ = ' ' "              + CRLF
    ConOut(cQryPes)
    TCQuery cQryPes New Alias "QRY_PES"
    TCSetField("QRY_PES", "ZZ1_DTNASC", "D")
    Count To nTotPes
    oProc:SetRegua1(nTotPes)

    oPrintPvt:Say(50, 100, "Código")
    oPrintPvt:Say(50, 250, "Nome")
    oPrintPvt:Say(50, 400, "Sexo")
    oPrintPvt:Say(50, 550, "Dt. Nasc.")
    oPrintPvt:Say(50, 700, "Idade")
    oPrintPvt:Say(50, 850, "CEP")
    oPrintPvt:Say(50, 1000, "Rua")
    oPrintPvt:Say(50, 1150, "Número da Rua")
    oPrintPvt:Say(50, 1300, "UF")
    oPrintPvt:Say(50, 1450, "Município")
    oPrintPvt:Say(50, 1600, "DDD")
    oPrintPvt:Say(50, 1750, "Telefone")

    If nTotPes != 0


    EndIf

    oPrintPvt:Preview()

Return oPrintPvt

