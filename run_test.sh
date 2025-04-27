#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR"
riscv64-unknown-linux-gnu-gcc -static -o test/test_assembly \
    src/freeHashTable.s \
    src/get_most_frequent_word.s \
    src/hash.s \
    src/insertWord.s \
    src/main.s \
    src/processLine.s

riscv64-unknown-linux-gnu-gcc -static -o test/test_c c_src/main.c

cd test

# Test the code on three examples
EXAMPLE_LST=(
    1000000_Pound_note.txt
    Gone_with_the_wind.txt
    Jane_Eyre.txt
)

for FILENAME in "${EXAMPLE_LST[@]}"; do
    echo "Testing on $FILENAME..."

    asm_output=$(qemu-riscv64 test_assembly "$FILENAME" | head -n 1)
    c_output=$(qemu-riscv64 test_c "$FILENAME" | head -n 1)

    echo "Assembly version output: $asm_output"
    echo "C version output: $c_output"

    if [ "$asm_output" = "$c_output" ]; then
        echo "Outputs are identical."
    else
        echo "Outputs differ."
    fi

    echo "----------------------------------------"
done
