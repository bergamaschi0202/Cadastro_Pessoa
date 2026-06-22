// Biblioteca
#Include "Protheus.ch"
#Include "TopConn.ch"

// Variáveis Statics
Static cAliasMVC    := "ZZ1"

/*/{Protheus.doc} MontExl
Monta a Tabela Excel
@author Arthur Bergamaschi
@since 22/06/2026
@version 1.0
@type function
/*/
User Function MontExl(oProc, cCodDe, cCodAt, cSexo, cPath)
    Local cQryReg       := ""
    Local nTotReg       := 0
    Local cWorkSheet    := "Cadastro de Pessoa"
    Local cTitulo       := "Relatório de Cadastro de Pessoa"
    Local nAtual        := 0
    Local cTelefone     := ""
    Local cArquivo      := ""
    Local cAviso        := ""

    Local oFWMsExcel
    Local oExcel

    If cSexo = "3"
        cArquivo := cPath + "Rel.xml"

        // Query SQL sem filtro de sexo
        cQryReg := "SELECT "                                    + CRLF
        cQryReg += "    ZZ1_FILIAL, "                           + CRLF
        cQryReg += "    ZZ1_COD, "                              + CRLF
        cQryReg += "    ZZ1_NOME, "                             + CRLF
        cQryReg += "    ZZ1_SEXO, "                             + CRLF
        cQryReg += "    ZZ1_DTNASC, "                           + CRLF
        cQryReg += "    ZZ1_IDADE, "                            + CRLF
        cQryReg += "    ZZ1_CEP, "                              + CRLF
        cQryReg += "    ZZ1_RUA, "                              + CRLF
        cQryReg += "    ZZ1_NUMRUA, "                           + CRLF
        cQryReg += "    ZZ1_BAIRRO, "                           + CRLF
        cQryReg += "    ZZ1_MUNICI, "                           + CRLF
        cQryReg += "    ZZ1_UF, "                               + CRLF
        cQryReg += "    ZZ1_PAIS, "                             + CRLF
        cQryReg += "    ZZ1_EMAIL, "                            + CRLF
        cQryReg += "    ZZ1_DDD, "                              + CRLF
        cQryReg += "    ZZ1_FONE "                              + CRLF
        cQryReg += "FROM "                                      + CRLF
        cQryReg += "    " + RetSQLName(cAliasMVC)               + CRLF
        cQryReg += "WHERE "                                     + CRLF
        cQryReg += "    ZZ1_COD >= '" + cCodDe + "' "           + CRLF
        cQryReg += "    AND ZZ1_COD <= '" + cCodAt + "' "       + CRLF
        cQryReg += "    AND D_E_L_E_T_ = ' ' "                  + CRLF
    Else
        If cSexo = "1"
            cArquivo := cPath + "Rel_Masculino.xml"
        Else
            cArquivo := cPath + "Rel_Feminino.xml"
        EndIf

        // Query SQL com filtro de sexo
        cQryReg := "SELECT "                                    + CRLF
        cQryReg += "    ZZ1_FILIAL, "                           + CRLF
        cQryReg += "    ZZ1_COD, "                              + CRLF
        cQryReg += "    ZZ1_NOME, "                             + CRLF
        cQryReg += "    ZZ1_SEXO, "                             + CRLF
        cQryReg += "    ZZ1_DTNASC, "                           + CRLF
        cQryReg += "    ZZ1_IDADE, "                            + CRLF
        cQryReg += "    ZZ1_CEP, "                              + CRLF
        cQryReg += "    ZZ1_RUA, "                              + CRLF
        cQryReg += "    ZZ1_NUMRUA, "                           + CRLF
        cQryReg += "    ZZ1_BAIRRO, "                           + CRLF
        cQryReg += "    ZZ1_MUNICI, "                           + CRLF
        cQryReg += "    ZZ1_UF, "                               + CRLF
        cQryReg += "    ZZ1_PAIS, "                             + CRLF
        cQryReg += "    ZZ1_EMAIL, "                            + CRLF
        cQryReg += "    ZZ1_DDD, "                              + CRLF
        cQryReg += "    ZZ1_FONE "                              + CRLF
        cQryReg += "FROM "                                      + CRLF
        cQryReg += "    " + RetSQLName(cAliasMVC)               + CRLF
        cQryReg += "WHERE "                                     + CRLF
        cQryReg += "    ZZ1_COD >= '" + cCodDe + "' "           + CRLF
        cQryReg += "    AND ZZ1_COD <= '" + cCodAt + "' "       + CRLF
        cQryReg += "    AND ZZ1_SEXO = " + cSexo                + CRLF
        cQryReg += "    AND D_E_L_E_T_ = ' ' "                  + CRLF
    EndIf
    ConOut(cQryReg)
    TCQuery cQryReg New Alias "QRY_REG"
    TCSetField("QRY_REG", "ZZ1_DTNASC", "D")
    Count To nTotReg
    oProc:SetRegua1(nTotReg)
    QRY_REG->(DbGoTop())

    oFWMsExcel := FWMSExcel():New()

    oFWMsExcel:AddworkSheet(cWorkSheet)

    oFWMsExcel:AddTable(cWorkSheet, cTitulo)
    oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Código",                 2, 1, .F.)
    oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Nome",                   2, 1, .F.)
    oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Sexo",                   2, 1, .F.)
    oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Dt. Nascimento",         2, 1, .F.)
    oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Idade",                  2, 1, .F.)
    oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "CEP",                    2, 1, .F.)
    oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Endereço",               2, 1, .F.)
    oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Número de Endereço",     2, 1, .F.)
    oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Bairro",                 2, 1, .F.)
    oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Município",              2, 1, .F.)
    oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "UF",                     2, 1, .F.)
    oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "País",                   2, 1, .F.)
    oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "E-mail",                 2, 1, .F.)
    oFWMsExcel:AddColumn(cWorkSheet, cTitulo, "Telefone",               2, 1, .F.)

    If nTotReg != 0

        While ! QRY_REG->(EoF())
            
            nAtual++

            cTelefone := QRY_REG->ZZ1_DDD + QRY_REG->ZZ1_FONE

            oFWMsExcel:AddRow(cWorkSheet, cTitulo, {;
                QRY_REG->ZZ1_COD,;
                QRY_REG->ZZ1_NOME,;
                QRY_REG->ZZ1_SEXO,;
                QRY_REG->ZZ1_DTNASC,;
                QRY_REG->ZZ1_IDADE,;
                QRY_REG->ZZ1_CEP,;
                QRY_REG->ZZ1_RUA,;
                QRY_REG->ZZ1_NUMRUA,;
                QRY_REG->ZZ1_BAIRRO,;
                QRY_REG->ZZ1_MUNICI,;
                QRY_REG->ZZ1_UF,;
                QRY_REG->ZZ1_PAIS,;
                QRY_REG->ZZ1_EMAIL,;
                cTelefone;
            })

            QRY_REG->(DbSkip())

        EndDo
        QRY_REG->(DbCloseArea())

        oFWMsExcel:Activate()
        oFWMsExcel:GetXMLFile(cArquivo)

        oExcel := MsExcel():New()
        oExcel:WorkBooks:Open(cArquivo)
        oExcel:SetVisible(.T.)
        oExcel:Destroy()

        If File(cArquivo)
            cAviso := "Ok!" + CRLF + CRLF +;
                "Relatório gerado com sucesso em " + cPath
            Aviso("Relatório Excel", cAviso, {"Ok"}, 1)
        EndIf
    Else
        cAviso := "Fala ao listar registros!" + CRLF + CRLF +;
            "Não há registros para gerar relatório"
        Aviso("Relatório Excel", cAviso, {"Ok"}, 2)
    EndIf

Return
