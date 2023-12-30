.data
    formatNrScanf: .asciz "%d"
    formatPairScanf: .asciz "%d %d"
    formatStringScanf: .asciz "%s"

    formatPrintf: .asciz "%d"
    formatStringPrintf: .asciz "%s"
    newLine: .asciz "\n"

    m: .space 4
    n: .space 4
    p: .space 4
    k: .space 4
    task: .space 4
    mesaj: .space 100

    mVerif: .space 4
    nVerif: .space 4

    indexP: .space 4
    pozX: .space 4
    pozY: .space 4

    indexLinie: .space 4
    indexColoana: .space 4

    matrice: .space 1600
    matriceNoua: .space 1600
    lungimeMatrice: .space 4

    indexK: .space 4
    nrVecini: .space 4

    valoareCurenta: .space 4

    cheie: .space 1600
    indexMesaj: .space 4
    lungimeMesaj: .space 4

    indexBit: .space 4

    indexParcurgereCheie: .space 4
    indexParcurgereMatrice: .space 4
    indexParcurgereXor: .space 4
    limita: .space 4

.text

.global main

main:           # citim nr linii, col si celule vii

    pushl $m
    pushl $formatNrScanf
    call scanf
    popl %edx
    popl %edx
    addl $2, m  # pentru bordarea matricei, liniile 0 si m vor fi bordate si nefolosite

    pushl $n
    pushl $formatNrScanf
    call scanf
    popl %edx
    popl %edx
    addl $2, n  # pentru bordarea matricei, coloanele 0 si n vor fi bordate si nefolosite

    pushl $p
    pushl $formatNrScanf
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
    je et_citire

    pushl $pozY
    pushl $pozX
    pushl $formatPairScanf
    call scanf
    popl %edx
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

et_citire:                # citim numarul de evolutii, taskul cerut si mesajul
    pushl $k
    pushl $formatNrScanf
    call scanf
    popl %edx
    popl %edx

    pushl $task
    pushl $formatNrScanf
    call scanf
    popl %edx
    popl %edx

    pushl $mesaj
    pushl $formatStringScanf
    call scanf
    popl %edx
    popl %edx

    movl $0, indexK

et_evolutie:                # un loop in care executam cele k evolutii
    movl indexK, %ecx
    cmp %ecx, k
    je et_creare_mesaj      # cand toate cele k evolutii au avut loc, afisam matricea finala

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

/*
parcurgem cuvantul litera cu litera
parcurgem litera bit cu bit (o sa fie 8 biti mereu)
punem fiecare bit parcurs in parola
*/
et_creare_mesaj:
    movl $0, %eax
    lea mesaj, %edi

    et_lungime_mesaj:
        cmpb $0, (%edi)
        je et_end_lungime_mesaj
        incl %eax
        inc %edi
        jmp et_lungime_mesaj

    et_end_lungime_mesaj:
        movl %eax, lungimeMesaj
        movl $0, indexMesaj
        movl $0, indexParcurgereCheie

    et_parcurgere_mesaj:
        movl indexMesaj, %eax

        lea mesaj, %edi
        movl $0, %ebx
        movb (%edi, %eax, 1), %bl # vom pune in ebx valoarea ascii a fiecarei litere din mesaj

        movl $0, indexBit

        et_parcurgere_litera:   # vom parcurge fiecare bit din ebx (8 biti, fiind totul in bl) pentru a-l memora
            movl %ebx, %ecx # vom muta numarul in ecx pentru a-l putea shifta fara sa pierdem valoarea
            andl $1, %ecx # in ecx va ramane doar lsb, pe care il vom pune in cheie
            # problema este ca folosind acest algoritm, cheia va fi in ordine inversa
            # putem rezolva asta folosind o formula, astfel gasim ca pozitia bitului in cheie este 8 * (indexMesaj+1) - indexBit - 1

            lea cheie, %edi
            movl indexMesaj, %eax
            incl %eax
            movl $8, %edx
            mull %edx
            decl %eax
            subl indexBit, %eax

            movl %ecx, (%edi, %eax, 4)  # punem fiecare bit intr-un long, astfel vectorii "matrice" si "cheie" vor avea
            # aceeasi structura si ii putem xora mai usor

            incl indexBit
            incl indexParcurgereCheie
            shrl $1, %ebx
            movl indexBit, %eax
            cmpl $8, %eax
            je et_continuare_parcurgere_mesaj

            jmp et_parcurgere_litera

    et_continuare_parcurgere_mesaj:

        incl indexMesaj
        movl indexMesaj, %eax
        cmpl lungimeMesaj, %eax
        je et_corectare_siruri

        jmp et_parcurgere_mesaj

et_corectare_siruri:

    movl m, %eax
    mull n
    movl %eax, lungimeMatrice   # lungimea sirului dat de matricea bordata

    movl lungimeMesaj, %eax
    movl $8, %edx
    mull %edx
    movl %eax, lungimeMesaj     # lungimea sirului dat de mesaj (fiecare litera are cate 8 bytes)

    # acum vrem sa vedem care lungime este mai mica pentru a completa matricea cu elemente pana lungimile sunt egale

    cmpl lungimeMatrice, %eax
    jg et_crestere_matrice
    jl et_crestere_mesaj
    jmp et_afisare

et_crestere_matrice:    # vrem sa crestem vectorul "matrice" pana cand va avea aceeasi lungime ca si vectorul "cheie"
    
    movl lungimeMesaj, %eax
    subl lungimeMatrice, %eax 
    movl %eax, limita   # cu cat vrem sa crestem vectorul "matrice"
    movl $0, indexParcurgereMatrice

    et_for_loop:        # va trebui sa completam elementele v[lungimeMatrice] cu valorea din v[indexParcurgereMatrice]
        lea matrice, %edi
        movl indexParcurgereMatrice, %ebx
        movl (%edi, %ebx, 4), %eax  # valoarea pe care vrem sa o punem
        movl %eax, valoareCurenta

        movl lungimeMatrice, %ecx  # pozitia unde vrem sa punem valorea

        movl valoareCurenta, %eax
        movl %eax, (%edi, %ecx, 4)
        incl lungimeMatrice

        incl indexParcurgereMatrice
        movl indexParcurgereMatrice, %eax
        cmpl limita, %eax
        je et_afisare
        jmp et_for_loop

et_crestere_mesaj:   # vrem sa crestem vectorul "cheie" pana cand va avea aceeasi lungime ca si vectorul "matrice"
    movl lungimeMatrice, %eax
    subl lungimeMesaj, %eax 
    movl %eax, limita   # cu cat vrem sa crestem vectorul "cheie"
    movl $0, indexParcurgereCheie

    et_for_loop_msj:        # va trebui sa completam elementele v[lungimeCheie] cu valorea din v[indexParcurgereCheie]
        lea cheie, %edi
        movl indexParcurgereCheie, %ebx
        movl (%edi, %ebx, 4), %eax  # valoarea pe care vrem sa o punem
        movl %eax, valoareCurenta

        movl lungimeMesaj, %ecx  # pozitia unde vrem sa punem valorea

        movl valoareCurenta, %eax
        movl %eax, (%edi, %ecx, 4)
        incl lungimeMesaj

        incl indexParcurgereCheie
        movl indexParcurgereCheie, %eax
        cmpl limita, %eax
        je et_afisare
        jmp et_for_loop_msj


et_afisare:

    movl $0, indexParcurgereMatrice
    et_for_matrice:
        lea matrice, %edi
        movl indexParcurgereMatrice, %eax
        movl (%edi, %eax, 4), %ebx

        pushl %ebx
        pushl $formatPrintf
        call printf
        popl %edx
        popl %edx

        pushl $0
        call fflush
        popl %edx

        incl indexParcurgereMatrice
        movl indexParcurgereMatrice, %eax
        cmpl lungimeMatrice, %eax
        je next_step
        jmp et_for_matrice
    next_step:
        movl $0, indexParcurgereCheie

        pushl $newLine
        call printf
        popl %edx

        pushl $0
        call fflush
        popl %edx

        jmp et_for_cheie
    et_for_cheie:
        lea cheie, %edi
        movl indexParcurgereCheie, %eax
        movl (%edi, %eax, 4), %ebx

        pushl %ebx
        pushl $formatPrintf
        call printf
        popl %edx
        popl %edx

        pushl $0
        call fflush
        popl %edx

        incl indexParcurgereCheie
        movl indexParcurgereCheie, %eax
        cmpl lungimeMesaj, %eax
        je et_xorare
        jmp et_for_cheie

et_xorare:
    pushl $newLine
    call printf
    popl %edx
    pushl $0
    call fflush
    popl %edx

    movl $0, indexParcurgereXor
    et_for_xor:

        lea matrice, %edi
        movl indexParcurgereXor, %eax
        movl (%edi, %eax, 4), %ebx
        lea cheie, %edi
        movl indexParcurgereXor, %eax
        movl (%edi, %eax, 4), %ecx
        xorl %ecx, %ebx

        pushl %ebx
        pushl $formatPrintf
        call printf
        popl %edx
        popl %edx
        pushl $0
        call fflush
        popl %edx

        incl indexParcurgereXor
        movl indexParcurgereXor, %eax
        cmpl lungimeMesaj, %eax
        je et_exit
        jmp et_for_xor

et_exit:

    pushl $newLine
    call printf
    popl %edx
    pushl $0
    call fflush
    popl %edx

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80