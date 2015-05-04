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
±±ºAlterado dia 13/03/06 por Adriana Silva - Microsiga-NE                 º±±
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

Campo........: B1_SUBGRP
Tipo.........: Caracter
Tamanho......: 3
Formato......: @!
Contexto.....: Real
Propriedade..: Alterar
Titulo.......: SubGrupo
Descrição....: Codigo do SubGrupo


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

Campo........: B1_SUBGRP
Cnt. Dominio.: B1_COD
Tipo.........: Primario
Regra........: U_ProdSEQ() ou EXECBLOCK("ProdSEQ",.F.,.F.)

Campo........: B1_GRUPO
Cnt. Dominio.: B1_SUBGRP
Tipo.........: Primario
Regra........: " " (POreencher com Aspas duplas + 1 espaço + Aspas Duplas)

Regra alterada para IIF(INCLUI," ",M->B1_SUBGRP) em 06/08/2008



3. Alterar a propriedade e a ordem dos campos abaixo;

Campo........: B1_COD
Propriedade..: Visualizar


4. Criar o seguinte Indice para pesquisa ser realizada pelo Grupo e Subgrupo

Chave.......: B1_FILIAL + B1_GRUPO + B1_SUBGRP + B1_COD
NICKNAME....: "SUBGRUPORD"
Ordem.......: Sistema Criará automaticamente


Ordem;
1. B1_FILIAL
2. B1_GRUPO
3. B1_GRPDESC
4. B1_SUBGRP

*/

User Function ProdSEQ()

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Declaracao de Variaveis  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


SetPrvt("_xGrp,_xRETORNO,_nUP,_cALIAS,_nRECNO,_nORDEM,_n")


//Retorna sem efetuar modificações caso não esteja em modo de INCLUSAO
If !INCLUI
   Return()
Endif

//Salva a area corrente
_cALIAS := SELECT()
_nORDEM := INDEXORD()
_nRECNO := RECNO()
//_xClas  := AllTrim(M->B1_CLASPRO)
//_xArma  := AllTrim(M->B1_LOCPAD)
_xSGrp  := AllTrim(M->B1_SUBGRP)
_xGrp := AllTrim(M->B1_GRUPO)     //  EX.: 1001
If Alltrim(_xGrp) == "MOD"
	_cUP := "MOD"
Else
	
   DBSelectArea("SB1")
   //DBSetOrder(4) //B1_FILIAL+B1_GRUPO+B1_COD
   //DBSetOrder(9) 				//B1_FILIAL+B1_GRUPO+B1_SUBGRP+B1_COD
   dbOrderNickName("SUBGRUPORD")
	
   DBSeek(xFilial("SB1")+M->B1_GRUPO+M->B1_SUBGRP) //DBSeek(xFilial("SB1")+AllTrim(M->B1_GRUPO))
	
   //Inicializando a constante que contem a subcadeia do codigo de formara o codigo final.

   If Found()
		
      If (Len(AllTrim(_xGrp)) = 4)
			
         If !EMPTY(SB1->B1_COD)  //  "B1_COD"
				
            //Se o contador esta sendo utilizado no gatilho
				
			//While !EOF() .And. AllTrim(_xGrp) == AllTrim(SB1->B1_GRUPO)
			While !EOF() .And. AllTrim(_xGrp) == AllTrim(SB1->B1_GRUPO) .And. AllTrim(_xSGrp) == AllTrim(SB1->B1_SUBGRP)
               //armazena o ultimo codigo para o subgrupo especificado
			   _xRETORNO := SUBSTR(alltrim(SB1->B1_COD),8,5) //,6,5)
					
			   dbSkip()
					
			EndDo
				
         EndIf 
						
         //_nUP := VAL(substr(AllTrim(_xRETORNO),6,5))
         If Empty(_xRETORNO)
            _xRETORNO := "00000"
         Endif

		 _nUP := VAL(_xRETORNO)
		 _nUP++
		 _nUP := INT(_nUP)
		 //_cUP := AllTrim(_xGrp)+STRzero(_nUP,5)
		 _cUP := AllTrim(_xGrp)+_xSGrp+STRzero(_nUP,5)    //_xClas+_xArma
	
      Else
         MsgInfo('Esse grupo não pode montar um codigo de produto, verifique o tamanho do codigo.')
         _cUP := ' '
      Endif
		
   Else // se nao encontrou: dbSeek(xFILIAL("SB1")+M->B1_GRUPO)
		
      If (Len(AllTrim(_xGrp)) = 4)

         _cUP := AllTrim(_xGrp)+_xSGrp+STRzero(1,5)
			
      Else
         MsgInfo('Esse grupo não pode montar um codigo de produto, verifique o tamanho do codigo.')
         _cUP   := ' '
      Endif
		
   Endif

Endif

DBSELECTAREA(_cALIAS)
DBSETORDER(_nORDEM)
RECNO(_nRECNO)

Return(_cUP)
