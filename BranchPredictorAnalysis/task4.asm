.text
main:
    li      t0, 10000
    li      a3, 1
    li      a4, 0
    li      a1, 0

loop:
    beq     a4, zero, magic_br_1 # branch #1, 1/NT -> 3/T
    addi    a4, a4, 0

    nop
    nop
    nop
    nop
    nop
    nop

magic_br_1:
    beq     a3, zero, magic_br_2 # branch #2, 3/T -> 2/T
    addi    a3, a3, 0

magic_br_2:

# ****** ADD HERE ******
# your code for task 4
    nop
    nop
    nop
    nop
    nop
    nop
    beq     a3, zero, lol        # 2/T -> 0/NT
lol:
    
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    beq     a4, zero, kek         # 0/NT -> 1/NT
kek:
# **********************

    addi    a1, a1, 1
    bne     a1, t0, loop          # branch #3
