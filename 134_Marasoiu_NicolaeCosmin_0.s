.data
    formatScanf: .asciz "%d"
    formatPrintf: .asciz "%d "
    newLine: .asciz "\n"

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

    nrVecini: .space 4

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
    je et_afisare_mat

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

# vecinii elementelor:
# 1) poz - n - 1
# 2) poz - n
# 3) poz - n + 1
# 4) poz - 1
# 5) poz + 1
# 6) poz + n - 1
# 7) poz + n
# 8) poz + n + 1

et_evolutie:
    movl $1, indexLinie
    et_linie_evo:
        movl indexLinie, %ecx
        cmp %ecx, m
        je et_afisare_mat

        movl $1, indexColoana
        et_coloana_evo:
            movl indexColoana, %ecx
            cmp %ecx, n
            je et_next_evo

            movl indexLinie, %eax
            movl $0, %edx
            mull n
            addl indexColoana, %eax

            lea matrice, %edi
            movl (%edi, %eax, 4), %ebx

            # in ebx avem elementul POZ

            # Vecinul 1) poz - n - 1
            movl indexLinie, %eax
            movl $0, %edx
            decl %eax
            mull n
            addl indexColoana, %eax
            decl %eax
            movl (%edi, %eax, 4), %edx






            incl indexColoana
            jmp et_coloana_evo

    et_next_evo:
        
        movl $4, %eax
        movl $1, %ebx
        movl $newLine, %ecx
        movl $2, %edx
        int $0x80

        incl indexLinie
        jmp et_linie_evo


et_afisare_mat:
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