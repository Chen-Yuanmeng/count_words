# Count Words in a Text File

本项目用于统计文本文件中出现次数最多的单词，用 RISC-V64 汇编实现。

## 功能简介

- 读取指定的文本文件，统计每个单词出现的次数。
- 输出出现次数最多的单词及其出现次数。
- 提供 RISC-V64 汇编和 C 语言两种实现，便于对比和测试。

## 目录结构

- `src/`：RISC-V64 汇编实现的源代码。
- `c_src/`：C 语言实现的源代码。
- `test/`：测试用例和测试脚本。
- `run_test.sh`：自动编译并测试两种实现输出是否一致的脚本。

## 使用方法

1. **编译并测试**  
   在项目根目录下运行：
   ```bash
   bash ./run_test.sh
   ```
   脚本会自动编译汇编和 C 版本，并在多个示例文本上运行，比较输出结果。

2. **单独运行 C 版本**  
   ```bash
   gcc -o count_words_c c_src/main.c
   ./count_words_c <filename>
   ```

3. **单独运行汇编版本**  
   需使用 RISC-V64 工具链和 QEMU 仿真运行，具体见 run_test.sh。

## 依赖

- RISC-V64 交叉编译工具链（如 `riscv64-unknown-linux-gnu-gcc`）
- QEMU（用于仿真运行 RISC-V64 可执行文件）
- GCC（编译 C 版本）

## 示例输出

```
The most frequent word is "the", which appeared 12345 times.
```

