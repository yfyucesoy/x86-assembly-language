mov cx, 0Ah;
mov si, offset varInp;
mov di, offset varOut;

lp: call myEncFunc;
    loop lp;
    hlt;

proc myEncFunc;
    lodsw;SI'in tutdugu adresdeki veri word olarak AX'e yuklenir.
    xor ax,09FF9h;
    rol al,1;
    ror ah,1;
    xchg al,ah;
    neg al;
    not ah;
    xor ax,0F55Fh;AX'teki veriyi DI'in tutdugu adrese yazar.
    stosw;
    ret



varInp db 'BilMimLabBUygulama1', 0FFh
varOut db 'xxxxxxxxxxxxxxxxxxxx'