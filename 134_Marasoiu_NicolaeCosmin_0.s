.data
    formatScanf: .asciz "%d"
    formatPrintf: .asciz "%d "
    newLine: .asciz "\n"
    contorEvo: .asciz "Evolutie %d:\n"

    m: .space 4
    n: .space 4
    p: .space 4
    k: .space 4

    mVerif: .space 4
    nVerif: .space 4

    indexP: .space 4
    pozX: .space 4
    pozY: .space 4

    indexLinie: .space 4
    indexColoana: .space 4

    matrice: .space 1600
    matriceNoua: .space 1600

    indexK: .space 4
    nrVecini: .space 4

    x: .space 4
    valoareCurenta: .space 4

.text

.global main

main:           # citim nr linii, col si celule vii

    pushl $m
    pushl $formatScanf
    call scanf
    popl %edx
    popl %edx
    addl $2, m  # pentru bordarea matricei, liniile 0 si m vor fi bordate si nefolosite

    pushl $n
    pushl $formatScanf
    call scanf
    popl %edx
    popl %edx
    addl $2, n  # pentru bordarea matricei, coloanele 0 si n vor fi bordate si nefolosite

    pushl $p
    pushl $formatScanf
    call scanf
    popl %edx
    popl %edx

    # in mVerif si nVerif vom salva valoarea pana la care parcurgem matricea in verificari si afisari
    movl m, %ecx
    decl %ecx
    movl %ecx, mVerif

    movl n, %ecx
    decl %ecx
    movl %ecx, nVerif

    movl $0, indexP

et_citire_celule:   # citim cele p celule vii
    movl indexP, %ecx
    cmp %ecx, p
    je et_citire_k

    pushl $pozX
    pushl $formatScanf
    call scanf
    popl %edx
    popl %edx

    pushl $pozY
    pushl $formatScanf
    call scanf
    popl %edx
    popl %edx

    # trebuie sa plasam valoarea v[pozX][pozY] in vectorul matrice, ( pozX * n + pozY )
    # consideram matricea bordata, astfel (pozX, pozY) va fi (pozX + 1, pozY + 1) (liniile 0 si m vor fi bordura, coloanele 0 si n vor fi bordura)
    movl pozX, %eax
    incl %eax
    movl $0, %edx
    mull n
    addl pozY, %eax
    incl %eax

    lea matrice, %edi
    movl $1, (%edi, %eax, 4)

    incl indexP
    jmp et_citire_celule

et_citire_k:                # citim numarul de evolutii
    pushl $k
    pushl $formatScanf
    call scanf
    popl %edx
    popl %edx

    movl $0, indexK

et_evolutie:                # un loop in care executam cele k evolutii
    movl indexK, %ecx
    cmp %ecx, k
    je et_afisare_mat       # cand toate cele k evolutii au avut loc, afisam matricea finala

    incl indexK
        
    movl $1, indexLinie     # resetam indexul matricei pentru a o reparcurge

    et_linie_evo:
        movl indexLinie, %ecx
        cmp %ecx, mVerif    # atunci cand am parcurs toata matricea, poate avea loc interschimbarea intre matricea veche si cea noua (dupa evolutie)
        je et_interschimbare_matrice

        movl $1, indexColoana
        et_coloana_evo:
            movl indexColoana, %ecx
            cmp %ecx, nVerif
            je et_linia_urmatoare_evo

            movl indexLinie, %eax
            movl $0, %edx
            mull n
            addl indexColoana, %eax

            lea matrice, %edi
            movl (%edi, %eax, 4), %ebx
            movl %ebx, valoareCurenta

            # in ebx si valoareCurenta avem valoarea celulei de pe pozitia curenta
            # in edx vom incepe sa retinem cei 8 vecini ai elementului din ebx
            movl $0, nrVecini   # numarul de vecini ai celulei curente

            # Vecinul 1) (indexLinie-1, indexColoana-1)
            movl indexLinie, %eax
            movl $0, %edx
            decl %eax
            mull n
            addl indexColoana, %eax
            decl %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, nrVecini # daca in edx avem o celula vie, nrVecini va creste


            # Vecinul 2) (indexLinie -1, indexColoana)
            movl indexLinie, %eax
            movl $0, %edx
            decl %eax
            mull n
            addl indexColoana, %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, nrVecini

            # Vecinul 3) (indexLinie -1, indexColoana + 1)
            movl indexLinie, %eax
            movl $0, %edx
            decl %eax
            mull n
            addl indexColoana, %eax
            incl %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, nrVecini

            # Vecinul 4) (indexLinie, indexColoana + 1)
            movl indexLinie, %eax
            movl $0, %edx
            mull n
            addl indexColoana, %eax
            incl %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, nrVecini

            # Vecinul 5) (indexLinie + 1, indexColoana + 1)
            movl indexLinie, %eax
            movl $0, %edx
            incl %eax
            mull n
            addl indexColoana, %eax
            incl %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, nrVecini

            # Vecinul 6) (indexLinie + 1, indexColoana)
            movl indexLinie, %eax
            movl $0, %edx
            incl %eax
            mull n
            addl indexColoana, %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, nrVecini

            # Vecinul 7) (indexLinie + 1, indexColoana - 1)
            movl indexLinie, %eax
            movl $0, %edx
            incl %eax
            mull n
            addl indexColoana, %eax
            decl %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, nrVecini

            # Vecinul 8) (indexLinie, indexColoana - 1)
            movl indexLinie, %eax
            movl $0, %edx
            mull n
            addl indexColoana, %eax
            decl %eax
            movl (%edi, %eax, 4), %edx

            addl %edx, nrVecini

            # Jump in functie de valoarea lui ebx (celula curenta)
            cmp $0, %ebx
            je et_celula_moarta

            jmp et_celula_vie

            et_coloana_urmatoare_evo:
                incl indexColoana
                jmp et_coloana_evo

    et_linia_urmatoare_evo:

        incl indexLinie
        jmp et_linie_evo

et_celula_moarta:

    # vom verifica daca celula moarta are exact 3 vecini vii
    movl nrVecini, %eax
    cmp $3, %eax
    je et_creare_celula

    # daca are alt numar de vecini vii, vom pune in matriceNoua 0 (celula ramane moarta in urmatoarea evolutie)

    movl indexLinie, %eax
    movl $0, %edx
    mull n
    addl indexColoana, %eax

    lea matriceNoua, %edi
    movl $0, (%edi, %eax, 4)

    jmp et_coloana_urmatoare_evo    # ne intoarcem in loop-ul principal, unde vom trece la urmatoarea coloana


et_celula_vie:
    
    # vom verifica daca celula vie are 2 sau 3 vecini vii
    movl nrVecini, %eax
    cmp $2, %eax
    je et_creare_celula

    movl nrVecini, %eax
    cmp $3, %eax
    je et_creare_celula

    # daca are alt numar de vecini vii, vom pune in matriceNoua 0 (celula moare in urmatoarea evolutie)

    movl indexLinie, %eax
    movl $0, %edx
    mull n
    addl indexColoana, %eax

    lea matriceNoua, %edi
    movl $0, (%edi, %eax, 4)

    jmp et_coloana_urmatoare_evo    # ne intoarcem in loop-ul principal, unde vom trece la urmatoarea coloana

et_creare_celula:

    # vom pune 1 in matriceNoua

    movl indexLinie, %eax
    movl $0, %edx
    mull n
    addl indexColoana, %eax

    lea matriceNoua, %edi
    movl $1, (%edi, %eax, 4)

    jmp et_coloana_urmatoare_evo    # ne intoarcem in loop-ul principal, unde vom trece la urmatoarea coloana

et_interschimbare_matrice:

    # vom pune matricea noua in matricea pe care o verificam pentru urmatorul pas
   movl $1, indexLinie
    et_linie_inter:
        movl indexLinie, %ecx
        cmp %ecx, mVerif
        je et_evolutie

        movl $1, indexColoana
        et_coloana_inter:
            movl indexColoana, %ecx
            cmp %ecx, nVerif
            je et_next_inter

            movl indexLinie, %eax
            movl $0, %edx
            mull n
            addl indexColoana, %eax

            lea matriceNoua, %edi
            movl (%edi, %eax, 4), %ebx
            # in ebx vom avea valoarea elementului pe care vrem sa il punem in matricea cu care lucram

            lea matrice, %edi
            movl %ebx, (%edi, %eax, 4)

            incl indexColoana
            jmp et_coloana_inter

    et_next_inter:

        incl indexLinie
        jmp et_linie_inter


    jmp et_evolutie

et_afisare_mat:
    movl $4, %eax
    movl $1, %ebx
    movl $newLine, %ecx
    movl $2, %edx
    int $0x80

    movl $1, indexLinie

    et_linie:
        movl indexLinie, %ecx
        cmp %ecx, mVerif
        je et_exit

        movl $1, indexColoana
        et_coloana:
            movl indexColoana, %ecx
            cmp %ecx, nVerif
            je et_next

            movl indexLinie, %eax
            movl $0, %edx
            mull n
            addl indexColoana, %eax

            lea matrice, %edi
            movl (%edi, %eax, 4), %ebx

            pushl %ebx
            pushl $formatPrintf
            call printf
            popl %edx
            popl %edx

            pushl $0
            call fflush
            popl %edx


            incl indexColoana
            jmp et_coloana

    et_next:
        
        movl $4, %eax
        movl $1, %ebx
        movl $newLine, %ecx
        movl $2, %edx
        int $0x80

        incl indexLinie
        jmp et_linie

et_exit:
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80