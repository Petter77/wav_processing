section .text
global echo

echo:
    enter 0,0

    push ebx
    push eax
    push edi
    push ecx

    mov eax, [ebp+8] ; wskaźnik na tablicę próbek
    mov ecx, [ebp+12] ; numSamples
    movss xmm2, dword [ebp+16] ; alfa
    mov ebx, [ebp+20] ; offset

    shufps xmm2, xmm2, 0x00
    sub ecx, ebx
    imul ebx, 2
    add eax, ebx
    mov edi, eax
    sub eax, ebx

loop:
    ;V_t
    movq mm0, qword [edi] ; wczytuje wartość do mmx
    movq2dq xmm0, mm0 ; przenosi wartość do sse
    pmovsxwd xmm0, xmm0 ; 16 bitów -> 32 bity
    cvtdq2ps xmm0, xmm0 ; konwersja z int na float


    ;V_t-t_x
    movq mm1, qword [eax]
    movq2dq xmm1, mm1
    pmovsxwd xmm1, xmm1
    cvtdq2ps xmm1, xmm1

    mulps xmm1, xmm2 ; mnożenie wektorów
    addps xmm0, xmm1 ; dodawanie wektorów

    cvttps2dq xmm0, xmm0 ; konwersja float na int przez obcięcie
    packssdw xmm0, xmm0 ; 32 bity -> 16 bitów
    movdq2q mm0, xmm0 ; przenoszenie wartości do mmx

    xor ebx,ebx
    pextrw ebx, mm0, 0 ;wyciągnięcie pierwszego elementu
    and ebx, 0xFFFF ; wyzerowanie 16 najstarszych bitów
    mov [edi], bx ;zapisanie wartości z powrotem do tablicy

    xor ebx,ebx
    pextrw ebx, mm0, 1
    and ebx, 0xFFFF
    mov [edi+2], bx

    xor ebx,ebx
    pextrw ebx, mm0, 2
    and ebx, 0xFFFF
    mov [edi+4], bx

    xor ebx,ebx
    pextrw ebx, mm0, 3
    and ebx, 0xFFFF
    mov [edi+6], bx

    add eax, 8
    add edi, 8
    sub ecx, 4
    cmp ecx, 0
    jg loop ;

end:

      pop ecx
        pop edi
        pop eax
    pop ebx

    leave
    ret