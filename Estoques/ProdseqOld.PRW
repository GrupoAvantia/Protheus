#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PSEQ      ºAutor  ³ Nelson R. Petrucci º Data ³  28/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que gera o codigo do produto concatenado com o grupo ±±
±± do produto mais um sequencial automatico.                               ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geracao automatica dos codigos dos produtos                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlterado dia 25/04/08 por Roseane Correia - Microsiga-NE               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
1. Criar o campo

Campo........: B1_GRPDESC
Tipo.........: Caracter
Tamanho......: 20
Formato......: @!
Contexto.....: Real
Propriedade..: Visualizar
Titulo.......: Desc. Grupo
Descrição....: Descricäo do Grupo

2. Criar gatilhos para alimentar o campo criado com a descrição do grupo,
e para executar a rotina do codigo do produto;

a)

Campo........: B1_GRUPO
Cnt. Dominio.: B1_GRPDESC
Tipo.........: Primario
Regra........: SBM->BM_DESC
Posiciona....: Sim
Alias........: SBM
Ordem........: 1
Chave........: xFilial("SBM")+M->B1_GRUPO

b)

Campo........: B1_GRUPO
Cnt. Dominio.: B1_COD
Tipo.........: Primario
Regra........: EXECBLOCK("ProdSEQ",.F.,.F.)

3. Alterar a propriedade e a ordem dos campos abaixo;

Campo........: B1_COD
Propriedade..: Visualizar

Ordem;
1. B1_FILIAL
2. B1_GRUPO
3. B1_GRPDESC

*/

User Function ProdSEQ()

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Declaracao de Variaveis  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


SetPrvt("_xC,_xRETORNO,_nUP,_cALIAS,_nRECNO,_nORDEM,_n")


//Salva a area corrente
_cALIAS := SELECT()
_nORDEM := INDEXORD()
_nRECNO := RECNO()
//_xClas  := AllTrim(M->B1_CLASPRO)
//_xArma  := AllTrim(M->B1_LOCPAD)
_xSGrp  := AllTrim(M->B1_SUBGRP)
_xC := AllTrim(M->B1_GRUPO)     //  EX.: 1001
If Alltrim(_xC) == "MOD"
	_cUP := "MOD"
Else
	
	DBSelectArea("SB1")
	DBSetOrder(4)
	
	DBSeek(xFilial("SB1")+AllTrim(M->B1_GRUPO))
	
	//Inicializando a constante que contem a subcadeia do codigo de formara o codigo final.

	If Found()
		
		If (Len(AllTrim(_xC)) = 4)
			
			If !EMPTY(SB1->B1_COD)  //  "B1_COD"
				
				//Se o contador esta sendo utilizado no gatilho
				
				While !EOF() .And. AllTrim(_xC) == AllTrim(SB1->B1_GRUPO)
					//armazena o ultimo codigo para o subgrupo especificado
					_xRETORNO := SUBSTR(alltrim(SB1->B1_COD),8,5) //,6,5)
					
					dbSkip()
					
				EndDo
				
			EndIf 
						
			//    _nUP := VAL(substr(AllTrim(_xRETORNO),6,5))
			If Empty(_xRETORNO)
			   _xRETORNO := "00000"
			Endif
			_nUP := VAL(_xRETORNO)
			_nUP++
			_nUP := INT(_nUP)
			//_cUP := AllTrim(_xC)+STRzero(_nUP,5)
			_cUP := AllTrim(_xC)+_xSGrp+STRzero(_nUP,5)    //_xClas+_xArma
	
		Else
			MsgInfo('Esse grupo não pode montar um codigo de produto, verifique o tamanho do codigo.')
			_cUP := ' '
		endif
		
	Else // se nao encontrou: dbSeek(xFILIAL("SB1")+M->B1_GRUPO)
		
		If (Len(AllTrim(_xC)) = 4)
			_cUP := AllTrim(_xC)+_xSGrp+STRzero(1,5)
			
		Else
			MsgInfo('Esse grupo não pode montar um codigo de produto, verifique o tamanho do codigo.')
			_cUP   := ' '
		endif
		
	Endif
Endif

DBSELECTAREA(_cALIAS)
DBSETORDER(_nORDEM)
RECNO(_nRECNO)

Return(_cUP)
