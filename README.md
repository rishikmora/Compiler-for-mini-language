# MiniLang Compiler

A compiler and interpreter for a small, dynamically-typed scripting language, built from scratch in C++17 — hand-written lexer, recursive-descent parser, AST, and a real implementation of the Cytron et al. SSA construction algorithm over a custom control-flow graph.

## What this actually does

MiniLang programs support variables, arithmetic, string concatenation, comparisons, `if`/`else`, `while` loops, user-defined functions (including recursion), and a handful of built-in functions (`sqrt`, `abs`, `type`, `toNum`, `str`). See [`examples.ml`](./examples.ml) for a full sample program — factorial, Fibonacci, and FizzBuzz all run correctly end to end.

```
$ g++ -std=c++17 -O2 -pthread -o minilang minilang.cpp
$ ./minilang examples.ml
Hello, World!
...
10! = 3628800 
fib(0) = 0
fib(1) = 1
...
fib(10) = 55
...
```

## Architecture

```
Source (.ml)
   │
   ▼
Lexer  ──▶  tokens
   │
   ▼
Recursive-descent Parser  ──▶  AST
   │
   ├──▶  Tree-walking Interpreter  (executes the program directly)
   │
   └──▶  TAC IR Generator  ──▶  Control-Flow Graph (CFG)
                                    │
                                    ▼
                            Cytron SSA Construction
                       (dominator trees, dominance frontiers,
                              phi-node placement)
```

The interpreter executes the AST directly and is what actually produces program output. The CFG/SSA pipeline is a separate analysis path, inspectable via `--dump-cfg` and `--dump-ssa`, and does not currently feed back into code generation or optimization of the interpreted output.

## Verified — what's real and tested

- **Lexer, parser, AST, interpreter**: correctly executes arithmetic, string ops, conditionals, loops, recursive functions, and built-ins. Verified against `examples.ml`, including a 20-iteration FizzBuzz and 11-value Fibonacci sequence, all matching expected output exactly.
- **Cytron et al. SSA construction** (`CytronSSA`, Section 30): real dominator-tree computation via iterative fixpoint, real dominance-frontier computation, and correct phi-node placement at join points. Verified via `--dump-ssa` producing a fully correct dominator tree and DF sets across every reachable block in a multi-function program.
- **Bug found and fixed**: an earlier version of `computeDominators()` would infinite-loop/crash on any program with more than one function, because unreachable trailing dead-code blocks (e.g. an unreachable `ret nil` after an exhaustive `if`/`else`) broke the dominator fixpoint. Fixed by having the CFG builder connect `FUNC_END` blocks to subsequent top-level code, and having `CytronSSA` seed a fresh dominator-tree root for each disconnected reachable region rather than treating everything past the first gap as permanently unreachable. Verified with targeted stress tests (200+ repeated runs) before and after the fix.

## Known limitations — not yet real

Being direct about this rather than overselling it:

- **No x86-64 code generation.** There is no working assembler backend.
- **No real register allocation.** A "graph-coloring register allocator" exists in the source but currently maps source-level variable *names* (including function and built-in names) to labels rather than performing actual liveness-based allocation over IR values — it does not reflect a working allocator yet.
- **No working LLVM IR backend.** An LLVM IR emitter exists in the source but produces text that resembles LLVM IR without being valid, verifiable IR (e.g. duplicate basic block labels, SSA-violating reassignments, and hardcoded literal arguments in recursive calls instead of the actual runtime values).
- **No CI pipeline currently configured** for this repository.

## Usage

```
./minilang <file.ml>              # run a program
./minilang <file.ml> --dump-cfg   # print the control-flow graph
./minilang <file.ml> --dump-ssa   # print dominator tree, DF sets, and SSA form
./minilang <file.ml> --stats      # print compiler statistics (token/IR counts, timing)
```

## Requirements

- A C++17-capable compiler (verified working with GCC 16.1.0 via MSYS2 on Windows; GCC 6.3.0 is **not** sufficient — it lacks full `<optional>`/C++17 support)

```
g++ -std=c++17 -O2 -pthread -o minilang minilang.cpp
```
