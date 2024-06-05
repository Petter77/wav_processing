section .text
global echo

echo:
    enter 0,0
    push ebx
    push ecx
    push esi
    push edi
    ;Nie tykać^

    mov     eax,  [ebp + 8]      ;wskaźnik
    mov     edx,  [ebp + 12]     ;ilość sampli
    fld     dword [ebp + 16]     ;alfa (float)
    mov     ecx,  [ebp + 20]     ;offset

    mov     esi, eax             ;esi zawiera wskaźnik na tablicę
    add     esi, ecx             ;dodajemy offset do wskaźnika
    mov     edi, edx             ;edi zawiera ilość sampli
    sub     edi, ecx             ;odejmujemy offset od ilości sampli

    ;Pętla dla każdej próbki
    loop_start:
        fild    word [esi]       ;ładujemy próbkę do rejestru FPU
        fmul    st1              ;mnożymy próbkę przez alfa
        fild    word [esi + ecx] ;ładujemy wartość próbki sprzed tx próbek do rejestru FPU
        faddp   st1, st0         ;dodajemy do tego wartość próbki sprzed tx próbek
        fistp   word [esi]       ;zapisujemy wynik z powrotem do tablicy
        add     esi, 2           ;przechodzimy do następnej próbki
        dec     edi              ;zmniejszamy licznik próbek
        jnz     loop_start       ;jeśli licznik próbek nie jest równy zero, kontynuujemy pętlę

    ;Nie tykać\/
    pop edi
    pop esi
    pop ecx
    pop ebx
    leave
    ret