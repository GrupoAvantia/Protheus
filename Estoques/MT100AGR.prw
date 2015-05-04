#INCLUDE "RWMAKE.CH"        
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100AGR  �Autor  �Jean Valoes         � Data �  02/08/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada utilizado ao fim da gravacao do documen_  ���
���          � to de entrada para a gravacao do ICMS Retido no campo      ���
���          � F3_OBSERV dos livros fiscais. Informacao para o SEF-PE     ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 10 - Avantia                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT100AGR()    

dbSelectArea("SM0")

cCodFil := M0_CODFIL

SetPrvt("CTES")

   cTes := SD1->D1_TES
   dbSelectArea("SF4")
   dbSetOrder(1)
   dbSeek(xFilial("SF4")+cTes)

//INCLUI OBSERVACAO DO ICMS RETIDO (ST) NO LIVRO FISCAL 

   IF cTES $ GetmV("MV_XTESST") //Colocar no Parametro, todos os TES que calculam ICMS-ST | Ex.: 020/010/099 
      dbSelectArea("SF3") 
      RecLock("SF3",.F.)
      Replace F3_OBSERV   With "ICMS FONTE: R$"+STR(SF3->F3_ICMSRET,10,2)
      MsUnLock()
   ENDIF

Return