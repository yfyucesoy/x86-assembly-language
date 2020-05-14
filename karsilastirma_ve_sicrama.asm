mov si,offset nums        ; source index'e nums degiskeninin adresi atanir.
mov cx,n                  ; counter set edilir.
mov bx,01                 ; ortalama hesabi icin mevcut eleman sayisini tutan deger bx registerine atanir.

call MinMax               ; MinMax procedure'u cagirilir.
call Avg                  ; Avg procedure'u cagirilir.
hlt                       ; Program sona erdirilir.


proc MinMax
       mov ax,[si]        ; ax registerina source indexin gosterdigi dizinin ilk elemani atanir.
       mov RSTMIN,ax      ; ax registerinde tutulan dizinin ilk degeri baslangicta minimum eleman olarak belirlenir.
       mov RSTMAX,ax      ; ax registerinde tutulan dizinin ilk degeri baslangicta maximum eleman olarak belirlenir.
myloop1:mov ax,[si+2]     ; her bir dongude dizideki bir sonraki eleman ax registerine atanir.
       add si,2           ; source index dizi elemanlari arasinda gecisi saglamak icin 2 arttirilir.(dizi elemanlari word oldugu icin)
       cmp ax,RSTMIN      ; ax registerinda tutulan dizi elemani ile RSTMIN degiskenindeki deger karsilastirilir.
       JGE myblock1       ; eger suan karsilastirma yapilan dizi elemani RSTMIN'den buyuk yada esitse myblock1 bloguna sicrama yapilir.
       mov RSTMIN,ax      ; eger jump islemi gerceklesmesse bu; RSTMIN karsilastirilan dizi elemanindan daha buyuk demektir ve RSTMIN'e o dizi elemani atanir.
myblock1:cmp ax,RSTMAX    ; ax registerinda tutulan dizi elemani ile RSTMAX degiskenindeki deger karsilastirilir.
       JLE myblock2       ; eger suan karsilastirma yapilan dizi elemani RSTMIN'den kucuk yada esitse myblock2 bloguna sicrama yapilir.
       mov RSTMAX,ax      ; eger jump islemi gerceklesmesse bu; RSTMAX karsilastirilan dizi elemanindan daha kucuk demektir ve RSTMAX'e o dizi elemani atanir.
myblock2:loop myloop1     ; counter 0 olana kadar dongu devam eder.
       ret                ; procedure return eder.


proc Avg
       mov si,offset nums ; source index'e nums degiskeninin adresi atanir.
       mov cx,n           ; counter set edilir.
myloop2: add ax,[si]      ; ax registeri ile source indexin tuttugu adresteki dizi elemani toplanir ve bu ax registerine yazilir.
       cwd                ; bolme islemi yapabilmek adina sayi word boyutundan double word tipine cevrilir.
       idiv bx            ; ax registerinde tutulan deger bx registerinde yer eleman mevcut eleman sayisina bolunerek sonuc ax'e yazilir.
       mov RSTAVG,ax      ; ax registerterindaki ortalam deger RSTAVG degiskenine atanir.
       mul bx             ; ax'te yer alan degeri tekrar eleman toplamina donusturmek adina bx registerindeki degerle carpilir ve ax registerine yazilir.
       inc bx             ; bx registerindeki deger bir arttirilir. (eleman sayisi)
       add si,2           ; source index'in gosterdigi adres iki arttirilarak bir sonraki dizi elemaninin adresi elde edilmis olur.
       loop myloop2       ; counter 0 olana kadar dongu devam eder.
       ret                ; procedure return eder.


NUMS DW -117,317,-575,379,596,-1200,649,15,-145,1331 
RSTAVG  DW ?
RSTMAX  DW ?
RSTMIN  DW ?
n equ 10