MOV SI, OFFSET inputCodded            ; Source index'e inputCodded degiskeninin adresi atanir.
MOV DI, OFFSET outputValid            ; Destination index'e outputValid degiskeninin adresi atanir.
CALL procExtractValidText             ; procExtractValidText procedure'u cagirilir.
MOV SI, OFFSET inputCodded            ; Source index'e inputCodded degiskeninin adresi atanir.
MOV DI, OFFSET outputText             ; Destination index'e outputText desgiskeninin adresi atanir.
CALL procExtractCoddedText            ; procExtractCoddedText procedure'u cagirilir.
HLT                                   ; Program sona erdirilir.
    
PROC procExtractValidText   
              
_LOOP:          LODSB                 ; SI tarafindan point edilen karakter AL registerina yuklenir.
                CMP AL,'$'            ; Metin sonu karakteri kontrolu
                JE _RETURN            
                CMP AL,'<'            ; Metin ici code blogu kontrolu
                JNE _ISNUMBER
                ADD SI,5              ; Code bloklarindan kurtulmak icin SI 5 arttirilir ve metinde 5 karakter ileri gidilmis olunur.
                JMP _LOOP
_ISNUMBER:      CMP AL, '0'           ; Eger karakter ASCII code olarak 0'dan kucukse ozel karakter bloguna atlanir. 
                JB _ISSPECIAL
                CMP AL, '9'           ; Eger karakter ACSII code olarak 9'dan buyukse buyuk harf olup olmadigi kontrolu yapilmak uzere gerekli bloga atlanir.
                JA _ISCAPITAL
                STOSB                 ; AL tarafindan tutulan karakter DI tarafindan point edilen adrese store edilir.
                JMP _LOOP 
_ISCAPITAL:     CMP AL, 'A'           ; AL'de tutulan karakterin ASCII codu,buyuk A harfinin ASCII codundan kucukse ve rakamlarin ASCII codundan buyukse ozel karakter bloguna atlanir.
                JB _ISSPECIAL
                CMP AL, 'Z'           ; AL'de tutulan karakterin ASCII codu, buyuk Z harfinin ACSII codundan buyukse kucuk karakter kontrolu bloguna atlanir.
                JA _ISLOWER
                STOSB
                JMP _LOOP
_ISLOWER:       CMP AL, 'a'           ; AL'de tutulan karakterin ASCII codu, kucuk a harfinin ASCII codundan kucukse ozel karakter bloguna atlanir.
                JB _ISSPECIAL
                CMP AL, 'z'
                JA _ISSPECIAL         ; AL'de tutulan karakterin ASCII codu, kucuk z harfinin ASCII codundan buyukse ozel karakter bloguna atlanir.
                STOSB
                JMP _LOOP
_ISSPECIAL:     MOV AL, ' '           ; Ozel karakterin yerine AL registerine bosluk (' ') karakteri atanir.
                STOSB                 ; AL registerindeki karakter (bosluk)  DI tarafindan point edilen adrese store edilir.
                JMP _LOOP
_RETURN:        RET                   ; Prodecure return edilir.
    


PROC procExtractCoddedText 
    
_LOOP1:         LODSB                 ; SI tarafindan point edilen karakter AL registerina yuklenir.
                CMP AL,'$'            ; Metin sonu karakteri kontrolu
                JE _RETURN1
                CMP AL,'<'
                JE _DECISION          ; Metindeki Code blogunun hangi kod blogu oldugunun kontrolu icin _DECISION bloguna atlanir.
                CMP AL, '0'           ; Eger karakter ASCII code olarak 0'dan kucukse ozel karakter bloguna atlanir.
                JB _ISSPECIAL1
                CMP AL, '9'           ; Eger karakter ACSII code olarak 9'dan buyukse buyuk harf olup olmadigi kontrolu yapilmak uzere gerekli bloga atlanir.
                JA _ISCAPITAL1
                STOSB                 ; AL tarafindan tutulan karakter DI tarafindan point edilen adrese store edilir.
                JMP _LOOP1 
_ISCAPITAL1:    CMP AL, 'A'           ; AL'de tutulan karakterin ASCII codu,buyuk A harfinin ASCII codundan kucukse ve rakamlarin ASCII codundan buyukse ozel karakter bloguna atlanir.
                JB _ISSPECIAL1
                CMP AL, 'Z'           ; AL'de tutulan karakterin ASCII codu, buyuk Z harfinin ACSII codundan buyukse kucuk karakter kontrolu bloguna atlanir.
                JA _ISLOWER1
                STOSB
                JMP _LOOP1
_ISLOWER1:      CMP AL, 'a'           ; AL'de tutulan karakterin ASCII codu, kucuk a harfinin ASCII codundan kucukse ozel karakter bloguna atlanir.
                JB _ISSPECIAL1
                CMP AL, 'z'           ; AL'de tutulan karakterin ASCII codu, kucuk z harfinin ASCII codundan buyukse ozel karakter bloguna atlanir.
                JA _ISSPECIAL1
                STOSB
                JMP _LOOP1
_ISSPECIAL1:    MOV AL, ' '           ; Ozel karakterin yerine AL registerine bosluk (' ') karakteri atanir.
                STOSB                 ; AL registerindeki karakter (bosluk)  DI tarafindan point edilen adrese store edilir.
                JMP _LOOP1
_DECISION:      MOV AL,[si+1]         ; AL registerine metin icinde bulunan code blogunun 2.harfi atanir.
                CMP AL,'a'            ; Harf a ise code=<save>
                JE _SAVECONDITION
                CMP AL,'w'            ; Harf w ise code= <swap>
                JE _SWAPCONDITION      
_SAVECONDITION: ADD SI,5              ; Metin icindeki code blogundan kurtulmak icin SI 5 arttirilir ve  metin icinde 5 karakter gidilmis olunur.
_LOOP2:         LODSB   
                CMP AL,'<'            ;  Save codu metine uygulanirken End codu gelip gelmediginin kontrolu yapilir.
                JE _INTERVALEND
                STOSB
                JMP _LOOP2    
_INTERVALEND:   ADD SI,5              ; End codundan kurtulmak icin SI 5 arttirilir ve metin icinde 5 karakter ilenlemis olunur.
                JMP _LOOP1 
_SWAPCONDITION: ADD SI,5              ; Metin icindeki code blogundan kurtulmak icin SI 5 arttirilir ve  metin icinde 5 karakter gidilmis olunur.
_LOOP3:         LODSB
                CMP AL,'<'            ; Swap kodu metine ugulanirken End codu gelip gelmediginin kontrolu yapilir.
                JE _INTERVALEND2
                CMP AL, 'Z'           ; Kucuk buyuk harf kontrolu yapilir.
                JB _TOLOWER
                CMP AL, 'a'           ; Kucuk buyuk harf kontrolu yapilir.
                JG _TOUPPER
_TOLOWER:       ADD AL,20h            ; ASCII aritmetigi ile buyuk harf 20h eklenerek kucuk harf yapilir.
                STOSB
                JMP _LOOP3
_TOUPPER:       SUB AL,20h            ; ASCII aritmetigi ile kucuk harf 20h cikarilarak buyuk harf yapilir.
                STOSB
                JMP _LOOP3            
_INTERVALEND2:  ADD SI,5              ; End codundan kurtulmak icin SI 5 arttirilir ve metin icinde 5 karakter ilenlemis olunur.
                JMP _LOOP1
_RETURN1:       RET                   ; Prodecure return edilir.





codeSave db '<save>' ; save the unusual characters
codeSwap db '<swap>' ; only low2up or vice versa
inputCodded db 'B<swap>ILGmIM<!end>_19-20<save>#Lab-<!end>AB<save>Uyg-4<!end>-STR<swap>ing<!end>+ISLem#$'
outputValid db '****************************************************' ;pre-allocated space to see the changes.
outputText db 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
