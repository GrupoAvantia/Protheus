#include "PROTHEUS.CH"  
#include "Fileio.ch"

User Function impAragao()
 /* Autor : Eliabe Rodrigues - Desenvolvedor
    Data  : 14/05/2008
    Descricao : esta funcao carrega o arquivo a ser importado
 */

  Local cCaminho := ""
  Local cType   := "Arquivo CSV | *.csv"
  
  Local cTitulo := "Importando Planilha"

  private oFile := TCsvGomes():New()
  
  // posicoes das colunas no aheader
  private codGrupo  := 1
  private descGrupo := 2  //descricao do grupo
  private codSubGrp := 3
  private codProd   := 5 
  private descProd  := 8
  private desItem   := 7
  
  private tpMercadoria := 6
  private armPadrao    := 9
  private uniMedida    := 10 //unidade
  
  
  cCaminho = cGetFile(cType, OemToAnsi("Selecione a Planilha que ser� Importada"),0,"c:\",.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE) 
  
  if alltrim(cCaminho) == ""
    return .T.
  endif

  oFile:SetFile(AllTrim(cCaminho))
  if !Empty(oFile:GetFile())
    oFile:n_FieldLine := 1
    oFile:Load()
  else
    APMsgInfo("O arquivo n�o pode ser carregado.")
    return .F.
  endif 
  
  if len(oFile:a_HeaderFile) == 0 
    APMsgInfo("O arquivo n�o pode ser carregado corretamente."+chr(13)+;
              "Por favor, verifique se o arquivo est� sendo utilizado ou est� no formato correto (*.csv).","Aten��o")
    return .F.
  elseif len(oFile:a_DataFile) == 0
    APMsgInfo("O arquivo n�o pode ser carregado corretamente."+chr(13)+;
              "Por favor, verifique se o arquivo est� sendo utilizado ou est� no formato correto (*.csv).","Aten��o")
    return .F. 
  endif
  
  if checACols(oFile:a_HeaderFile,oFile:a_DataFile)
      Import_SB1(oFile:a_DataFile)  
  else
    return .F.
  endif
  
  APMsgInfo("Inforta��o conclu�da com sucesso.","Aten��o")

return .T.

Static function checACols(aHeader,aCols)
/* Autor : Eliabe Rodrigues - Desenvolvedor
    Data  : 14/05/2008
    Descricao : checa se todas as linhas possui a mesma quantidade de colunas
 */
  Local b_retorno  := .T.
  Local tamAHeader := len(aHeader)
  Local tamACols   := len(aCols)
  Local ind        := 0


  for ind := 1 to tamACols
    if (len(aCols[ind]) > tamAHeader) .or. (len(aCols[ind]) < tamAHeader)
       APMSgInfo("a linha de n�mero "+alltrim(str(ind))+" n�o possui a mesma quantidade de colunas do cabe�alho.","Aten��o")
       ind := tamAcols + 1
       return .F.
    endif    

  next
  
return b_retorno

Static Function Import_SB1(aCols)
 /* Autor : Eliabe Rodrigues - Desenvolvedor
    Data  : 14/05/2008
    Descricao : esta funcao alimenta a table de produtos SB1
 */
 
  Local aArea    := getArea()
  Local tamACols := len(aCols)
  Local ind      := 0  

  DBSelectArea("SB1")
  dbSetOrder(1)

  for ind := 1 to tamACols
 
   if RecLock("SB1",.T.)
   
     SB1->B1_FILIAL := "01"//xFilial("SB1")
     SB1->B1_COD := aCols[ind][codProd]   //codigo do produto 
     SB1->B1_GRPDESC := aCols[ind][descGrupo] // descricao do grupo
     SB1->B1_DESC := aCols[ind][descProd] // descricao do produto 
	 SB1->B1_TIPO := aCols[ind][tpMercadoria] // tipo de mercadoria (ex: descricao do produto)
	 SB1->B1_UM := aCols[ind][uniMedida] // unidade de medida
	 SB1->B1_LOCPAD := aCols[ind][armPadrao]  // armazem padrao
	 SB1->B1_GRUPO := aCols[ind][codGrupo] // codigo do grupo
	 SB1->B1_SUBGRP := aCols[ind][codSubGrp] // codigo do subGrupo

    else
      APMSgInfo("O registro da linha "+alltrim(str(ind))+" n�o consegiu obter acesso ao banco.","Aten��o")
    endif
    DBUNLOCK()
  next
  
 restArea(aArea)
 Import_SB5(aCols) // complemento do produto
return .T.

Static Function Import_SB5(aCols) // complemento do produto
/* Autor : Eliabe Rodrigues - Desenvolvedor
    Data  : 14/05/2008
    Descricao : esta funcao alimenta a tabela de complemento do produto SB5
 */
 
  Local aArea    := getArea()
  Local tamACols := len(aCols)
  Local ind      := 0  

  DBSelectArea("SB5")
  dbSetOrder(1)

  ProcRegua(len(aCols))

  for ind := 1 to tamACols
 
   if RecLock("SB5",.T.)
      SB5->B5_FILIAL := "01" //xFilial("SB5")
      SB5->B5_COD := aCols[ind][codProd]   //codigo do produto
      SB5->B5_CEME := aCols[ind][desItem] // descricao do produto 
    else
      APMSgInfo("O registro da linha "+alltrim(str(ind))+" n�o consegiu obter acesso ao banco.","Aten��o")
    endif
    DBUNLOCK()
  next
  
 restArea(aArea)

return .T.