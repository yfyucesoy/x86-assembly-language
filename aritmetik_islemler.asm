mov si, offset nums
mov di, offset rslt  
mov cx, n/2 ;herbir döngüde 2 matematik işlemi (toplama ve çıkarma) yapıldığı için eleman sayısının yarısı kadar dönmesi yeterlidir.
call execBCDFormulaLab2A
hlt


proc execBCDFormulaLab2A
          mov dx,[di] ;Destination Index'in point ettiği deger(rslt) dx registerina atiliyor. yapılacak islemlerde dx registerından faydalanmak adına.
_loop:    call sumBCDTwoNums
          mov [di],dx ; procedure sonucunda set edilmis olan dx registerindaki deger Destination Indextin point ettiği degisken(rslt)'e atanır.
          call subBCDTwoNums  
          mov [di],dx ;procedure sonucunda set edilmis olan dx registerindaki deger Destination Indextin point ettiği degisken(rslt)'e atanır.
          add si,4 ;herbir adımda si in point ettigi verilerde 2 word seklinde ilerleyebilmek adına Source Index' 4 eklenir.
          dec cx   ; Couter--
          cmp cx,0  ; Counter sıfır mi degil mi
          jnz _loop  ; Sıfır Degilse döngüye devam
          ret



proc sumBCDTwoNums
    clc      ; Carry Flag'ı temizle
    mov ax,[si] ; Accumulator'e Source Index'in point ettigi deger [nums] atiliyor.
    add al,dl   ; daa sadece Accumulator Low'da çalıstıgı için  önce sayının low kısmı toplanır.
    daa         ; AL'deki sayı ondalık olarak ayarlanır.
    xchg al,ah  ; Accumulator High kısmındaki sayı ile dh'ta tutulan sayinin sonucuna adjusment işlemi yapabilmek için Accumulator'deki High ve Low exchange edilir.
    adc al,dh   ; toplama işleminde Add with Carry operasyonu ile yapılır (Add kısmında yapılan islemin Carry kısmını kaybetmemek adına)
    daa         ; AL'deki sayi ondalık olarak ayarlanir.
    xchg al, ah ; Sayımızı tekrar olması gereken formata getirmek adına Acummulator'deki High ve Low exchange elidir.
    mov dx,ax   ; Accumulator'deki olusan sonucumuz Dx registerine atılır.
    ret
    
proc subBCDTwoNums
    clc             ;Carry Flag'ı temizle
    mov ax,dx
    mov dx,[si+2]   ;Accumulator'e Source Index'in point ettigi deger [nums] atiliyor. (si+2 ile bir sonraki elemanı point ediyoruz.)
    sub al,dl       ; daa sadece Accumulator Low'da çalıstıgı için  önce sayının low kısmı çıkarılır.
    das             ; AL'deki sayı ondalık olarak ayarlanır.
    xchg al,ah      ; Accumulator High kısmındaki sayı ile dh'ta tutulan sayinin sonucuna adjusment işlemi yapabilmek için Accumulator'deki High ve Low exchange edilir.	
    sbb  al,dh      ; Çıkarma işleminde Subtract with Barrow operasyonu ile yapılır (Sub kısmında yapılan islemin borrow kısmını kaybetmemek adına)
    das             ; AL'deki sayi ondalık olarak ayarlanir.
    xchg al, ah     ; Sayımızı tekrar olması gereken formata getirmek adına Acummulator'deki High ve Low exchange elidir.
    mov dx,ax       ; Accumulator'deki olusan sonucumuz Dx registerine atılır.
    ret

n equ 10
nums dw 09845h, 08867h, 07265h, 05153h, 04127h, 05357h, 08111h, 07654h, 05852h, 03167h
rslt dw 0    
    
    
    