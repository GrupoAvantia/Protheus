#include "rwmake.ch"
#include "TopConn.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100AGR  ºAutor  ³Josue Izidio        º Data ³  2008       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada apos a inclusao da nota fiscal             º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Compras/Estoque                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MT100AGR

Local aArea    := GetArea()
Local cDoc     := SF1->F1_DOC
Local cSerie   := SF1->F1_SERIE
Local cFornece := SF1->F1_FORNECE
Local cLoja    := SF1->F1_LOJA
Local cCCusto  := SD1->D1_CC

DbSelectArea("SDE")
DbSetOrder(1)

//Localizar se houve rateio por centro de custo das nota fiscal de entrada
If !SDE->(dbseek(xFilial("SDE")+cDoc+cSerie+cFornece+cLoja)) // Nao houve rateio do centro de custo
	dbSelectArea("SE2")
	dbSetOrder(6)
	If SE2->(dbSeek(xFilial("SE2")+cFornece+cLoja+cSerie+cDoc))
		While SE2->E2_FORNECE  == cFornece .And. ;
			SE2->E2_LOJA     == cLoja    .And. ;
			SE2->E2_PREFIXO  == cSerie   .And. ;
			SE2->E2_NUM      == cDoc
			RecLock("SE2",.F.)
			SE2->E2_CCD := cCCusto
			MsUnlock()
			SE2->(dbSkip())
		EndDo
	Endif
Endif
RestArea(aArea)


Return (Nil)
