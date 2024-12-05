.intel_syntax noprefix
.global _day01

/* ------------------------ MAIN ------------------------ */
# rdi = pointer to input file
# rsi = length of input file
# rax = return value; part 1 in high 32 bits, part 2 in low 32 bits
# r8 = 1st column (array1)
# r9 = 2nd column (array2)
# r10 = current array size

.bss
    # resb
    .lcomm array1, 8*1000
    .lcomm array2, 8*1000

.text
_day01:
    push rsi
    push rdx
    # create copies of the array pointers
    lea r8, array1[rip]
    lea r9, array2[rip]
    call .L_parse_input
    call .L_part1_calculate_distance # part 1
    shl rax, 32
    push rax
    push rax # stack alignment
    call .L_part2_multiply_occ # part 2
    pop r10
    pop r10
    add rax, r10
    pop rdx
    pop rsi
    ret


/* ------------------------ IMPLEMENTATIONS ------------------------ */
# part 1
.L_part1_calculate_distance:
    xor rax, rax
    mov r10, 1000
.L_part1_calculate_distance_loop:
    mov rsi, [r8+r10*8-8]
    mov rdx, [r9+r10*8-8]
    cmp rsi, rdx
    jl .L_part1_calculate_distance_alt
    sub rsi, rdx
    add rax, rsi
    jmp .L_part1_calculate_distance_next
.L_part1_calculate_distance_alt:
    sub rdx, rsi
    add rax, rdx
.L_part1_calculate_distance_next:
    dec r10
    jnz .L_part1_calculate_distance_loop
    ret


# part 2
.L_part2_multiply_occ:
    xor rax, rax
    xor rsi, rsi
    xor r10, r10
    xor r11, r11
.L_part2_multiply_occ_loop:
    mov rdx, [r8+r11*8]
    mov rdi, r9
    call .L_part2_find_occ # occ of value from array1 in array2
    imul rax, rdx 
    add r10, rax
    inc r11
    cmp r11, 1000
    jnz .L_part2_multiply_occ_loop
    mov rax, r10
    ret

# rdi = array2; rsi = start position 2nd aray; rdx = value
.L_part2_find_occ:
    xor rax, rax
    xor rsi, rsi
.L_part2_find_occ_loop:
    cmp rdx, [rdi+rsi*8]
    jg .L_part2_find_occ_greater
    jl .L_part2_find_occ_end
    inc rax
.L_part2_find_occ_greater:
    inc rsi
    cmp rsi, 1000
    jnz .L_part2_find_occ_loop
.L_part2_find_occ_end:
    ret



/* ------------------------ HELPERS ------------------------ */
# split input data column to 2 arrays of integers
.L_parse_input:
    xor r10, r10

.L_parse_input_loop:
    # stop, compare with '\n'
    cmp byte ptr [rdi], 0
    jz .L_parse_input_end
    # split columns
    call .L_get_int
    # insert sorted to array1
    push rax
    push rdi
    mov rdi, r8  # array1
    mov rsi, r10 # current size
    mov rdx, rax # value from get_int
    call .L_sorted_insert
    pop rdi
    # skip 3 spaces and get the next int
    add rdi, 3
    call .L_get_int
    # insert sorted to array2
    push rdi
    mov rdi, r9  # array2
    mov rsi, r10 # current size
    mov rdx, rax # value from get_int
    call .L_sorted_insert
    pop rdi
    pop rax
    # next
    inc rdi
    inc r10
    jmp .L_parse_input_loop

.L_parse_input_end:
    ret


# Helper: sorted insert; rdi = array, rsi = current size, rdx = value; ascending
.L_sorted_insert:
    test rsi, rsi
    jz .L_sorted_insert_first
    cmp rdx, [rdi+rsi*8-8]
    # ifs the value is greater than the last element, append it
    jge .L_sorted_insert_append
    # find the right position
.L_sorted_insert_loop:
    cmp rdx, [rdi]
    jge .L_sorted_insert_next
    mov rcx, rsi
.L_sorted_insert_shift:
    mov rax, [rdi+rcx*8-8]
    mov [rdi+rcx*8], rax
    dec rcx
    jnz .L_sorted_insert_shift
    mov [rdi], rdx
    jmp .L_sorted_insert_end
.L_sorted_insert_next:
    add rdi, 8
    dec rsi
    jnz .L_sorted_insert_loop
.L_sorted_insert_append:
    mov [rdi+rsi*8], rdx
.L_sorted_insert_end:
    ret
.L_sorted_insert_first:
    mov [rdi], rdx
    ret



# Helper: get int
.L_get_int:
    xor rax, rax
.L_get_int_loop:
    # stop, compare with '\n' OR space
    cmp byte ptr [rdi], 0xa
    jz .L_get_int_end
    cmp byte ptr [rdi], 0x20
    jz .L_get_int_end
    # get int
    xor rdx, rdx
    mov dl, byte ptr [rdi]
    sub dl, 48
    cmp dl, 9
    ja .L_get_int_end
    # add to rax as the next digit
    imul rax, 10
    add rax, rdx
    # next
    inc rdi
    jmp .L_get_int_loop

.L_get_int_end:
    ret
