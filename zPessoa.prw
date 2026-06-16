//Biblioteca
#Include "Totvs.ch"
#Include "FWMVCDef.ch"
#Include "TopConn.ch"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"

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

/*/{Protheus.doc} Imprimir
Função imprimir com Parâmetros. Chama o fMontaRel
@author Arthur Bergamaschi
@since 12/06/2026
@version 1.0
@type function
/*/
User Function Imprimir()
    //Variáveis
    Local aPergs := {}
    Local cCodDe := "000001"
    Local cCodAt := "999999"
    Local aReturn := {}
    Local oProcess

    aAdd(aPergs, {1, "Pessoa De", cCodDe, "", ".T.", "ZZ1", ".T.", 6, .T.})
    aAdd(aPergs, {1, "Pessoa Até", cCodAt, "", ".T.", "ZZ1", ".T.", 6, .T.})

    If ParamBox(aPergs, "Informe os parâmetros", @aReturn, , , , , , , , .F., .F.)
        cCodDe := aReturn[1]
        cCodAt := aReturn[2]

        oProcess := MsNewProcess():New({|| fMontaRel(@oProcess, cCodDe, cCodAt) }, "Impressão de Cadastros de Pessoas", "Processando", .F.)
        oProcess:Activate()
    EndIf

Return

/*/{Protheus.doc} fMontaRel
Função que monta o relatório
@author Arthur Bergamaschi
@since 12/06/2026
@version 1.0
@type function
/*/
Static Function fMontaRel(oProc, cCodDe, cCodAt)
    Local cQryPes := ""
    Local cCod := ZZ1->ZZ1_COD
    ConOut(cCod)
    Local cNomeRel := "Relatório de Cadastro de Pessoas"
    Local nTotPes := 0
    Local nLinha := 0
    Local nWidthText := 0
    Local cSexoN := 0
    Private oFontNormal := TFont():New('Arial', , 15, .F.)
    Private oFontNegr := TFont():New('Arial', , 15, .T.)
    Private oFontTit := TFont():New('Arial', , 30, .T.)
    Private oPrintPvt

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
    cQryPes += "    ZZ1_EMAIL, "                        + CRLF
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

    If nTotPes != 0
        QRY_PES->(DbGoTop())

        While ! QRY_PES->(EoF())

            nLinha := 155

            oProc:IncRegua1()

            oPrintPvt:StartPage()

            // Imprime cabeçalho
            fImpCab()

            // Linha
            oPrintPvt:Line(130, 50, 130, 510, 0, "-4")

            // Imprimi os dados
            oPrintPvt:Say(nLinha, 50, "Código: ", oFontNegr, , , , ,                                                      )
            nWidthText := oPrintPvt:GetTextWidth("Código: ", oFontNegr, 0)
            oPrintPvt:Say(nLinha, nWidthText - 70, AllTrim(QRY_PES->ZZ1_COD), oFontNormal, , , , ,                        )
            nLinha += 40
            oPrintPvt:Say(nLinha, 50, "Nome: ", oFontNegr, , , , ,                                                        )
            nWidthText := oPrintPvt:GetTextWidth("Nome: ", oFontNegr, 0)
            oPrintPvt:Say(nLinha, nWidthText - 60, AllTrim(QRY_PES->ZZ1_NOME), oFontNormal, , , , ,                       )
            nLinha += 40
            oPrintPvt:Say(nLinha, 50, "Sexo: ", oFontNegr, , , , ,                                                        )
            nWidthText := oPrintPvt:GetTextWidth("Sexo: ", oFontNegr, 0)
            cSexoN := AllTrim(QRY_PES->ZZ1_SEXO)
            oPrintPvt:Say(nLinha, nWidthText - 40, fVerifSexo(cSexoN), oFontNormal, , , , ,                               )
            nLinha += 40
            oPrintPvt:Say(nLinha, 50, "Data de Nascimento: ", oFontNegr, , , , ,                                          )
            nWidthText := oPrintPvt:GetTextWidth("Data de Nascimento: ", oFontNegr, 0)
            oPrintPvt:Say(nLinha, nWidthText - 274, AllTrim(DtoC(QRY_PES->ZZ1_DTNASC)), oFontNormal, , , , ,              )
            nLinha += 40
            oPrintPvt:Say(nLinha, 50, "Idade: ", oFontNegr, , , , ,                                                       )
            nWidthText := oPrintPvt:GetTextWidth("Idade: ", oFontNegr, 0)
            oPrintPvt:Say(nLinha, nWidthText - 45, AllTrim(cValToChar(QRY_PES->ZZ1_IDADE)), oFontNormal, , , , ,          )
            nLinha += 40
            oPrintPvt:Say(nLinha, 50, "CEP: ", oFontNegr, , , , ,                                                         )
            nWidthText := oPrintPvt:GetTextWidth("CEP: ", oFontNegr, 0)
            oPrintPvt:Say(nLinha, nWidthText - 35, AllTrim(QRY_PES->ZZ1_CEP), oFontNormal, , , , ,                        )
            nLinha += 40
            oPrintPvt:Say(nLinha, 50, "Endereço: ", oFontNegr, , , , ,                                                    )
            nWidthText := oPrintPvt:GetTextWidth("Endereço: ", oFontNegr, 0)
            oPrintPvt:Say(nLinha, nWidthText - 106, AllTrim(QRY_PES->ZZ1_RUA), oFontNormal, , , , ,                       )
            nLinha += 40
            oPrintPvt:Say(nLinha, 50, "Número de Endereço: ", oFontNegr, , , , ,                                          )
            nWidthText := oPrintPvt:GetTextWidth("Número de Endereço: ", oFontNegr, 0)
            oPrintPvt:Say(nLinha, nWidthText - 286, AllTrim(cValToChar(QRY_PES->ZZ1_NUMRUA)), oFontNormal, , , , ,        )
            nLinha += 40
            oPrintPvt:Say(nLinha, 50, "UF: ", oFontNegr, , , , ,                                                          )
            nWidthText := oPrintPvt:GetTextWidth("UF: ", oFontNegr, 0)
            oPrintPvt:Say(nLinha, nWidthText - 16, AllTrim(QRY_PES->ZZ1_UF), oFontNormal, , , , ,                         )
            nLinha += 40
            oPrintPvt:Say(nLinha, 50, "Município: ", oFontNegr, , , , ,                                                   )
            nWidthText := oPrintPvt:GetTextWidth("Município: ", oFontNegr, 0)
            oPrintPvt:Say(nLinha, nWidthText - 113, AllTrim(QRY_PES->ZZ1_MUNICI), oFontNormal, , , , ,                    )
            nLinha += 40
            oPrintPvt:Say(nLinha, 50, "E-mail: ", oFontNegr, , , , ,                                                      )
            nWidthText := oPrintPvt:GetTextWidth("E-mail: ", oFontNegr, 0)
            oPrintPvt:Say(nLinha, nWidthText - 70, AllTrim(QRY_PES->ZZ1_EMAIL), oFontNormal, , , , ,                      )
            nLinha += 40
            oPrintPvt:Say(nLinha, 50, "DDD: ", oFontNegr, , , , ,                                                         )
            nWidthText := oPrintPvt:GetTextWidth("DDD: ", oFontNegr, 0)
            oPrintPvt:Say(nLinha, nWidthText - 50, AllTrim(QRY_PES->ZZ1_DDD), oFontNormal, , , , ,                        )
            nLinha += 40
            oPrintPvt:Say(nLinha, 50, "Telefone: ", oFontNegr, , , , ,                                                    )
            nWidthText := oPrintPvt:GetTextWidth("Telefone: ", oFontNegr, 0)
            oPrintPvt:Say(nLinha, nWidthText - 92, AllTrim(QRY_PES->ZZ1_FONE), oFontNormal, , , , ,                       )
            nLinha += 40    

            // Linha
            oPrintPvt:Line(770, 50, 770, 510, 0, "-4")

            // Imprime Rodapé
            fImpRod()

            QRY_PES->(DbSkip())

            oPrintPvt:EndPage()

        EndDo

        QRY_PES->(DbCloseArea())

    EndIf

    oPrintPvt:Preview()

Return oPrintPvt

/*/{Protheus.doc} fImpCab
Imprime o Cabeçalho
@author Arthur Bergamaschi
@since 15/06/2026
@version 1.0
@type function
/*/
Static Function fImpCab()

    oPrintPvt:SayAlign(80, 5, "Cadastro de Pessoa", oFontTit, 550, 500, , 2, 0)

Return

/*/{Protheus.doc} fImpRod
Imprime o Rodapé
@author Arthur Bergamaschi
@since 15/06/2026
@version 1.0
@type function
/*/
Static Function fImpRod()
    Local dData := Date()
    Local cHora := Time()

    //Empresa
    oPrintPvt:SayAlign(800, 50, "Empresa: ", oFontNormal, 500, 200, , , )
    oPrintPvt:SayAlign(800, 110, cEmpAnt, oFontNormal, 500, 200, , , )

    oPrintPvt:SayAlign(800, 250, DtoC(dData), oFontNormal, 500, 200, , , )
    oPrintPvt:SayAlign(800, 463, cHora, oFontNormal, 500, 200, , , )

Return

/*/{Protheus.doc} fVerificaSexo
Função que recebe o código do sexo e retorna se Masculino ou Feminino
@author Arthur Bergamaschi
@since 16/06/2026
@version 1.0
@type function
/*/
Static Function fVerifSexo(cSexoN)
    Local cSexoText

    If cSexoN = '1'
        cSexoText := "Masculino"
    Else
        cSexoText := "Feminino"
    EndIf

Return cSexoText
