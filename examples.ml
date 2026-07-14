# ============================================================
# examples.ml — MiniLang showcase programs
# Run: ./minilang examples.ml
# ============================================================

# ─── 1. Hello World ───────────────────────────────────────
print("Hello, World!")

# ─── 2. Variables & Arithmetic ────────────────────────────
let x = 10
let y = 3
print(x + y)        # 13
print(x - y)        # 7
print(x * y)        # 30
print(x / y)        # 3.333...
print(x % y)        # 1

# ─── 3. Strings ───────────────────────────────────────────
let name = "MiniLang"
print("Welcome to " + name + "!")

# ─── 4. Booleans & Comparisons ────────────────────────────
print(10 > 5)       # true
print(10 == 10)     # true
print(10 != 5)      # true

# ─── 5. If / Else ─────────────────────────────────────────
let score = 85
if (score >= 90) {
    print("Grade: A")
} else {
    if (score >= 80) {
        print("Grade: B")
    } else {
        print("Grade: C or below")
    }
}

# ─── 6. While Loop — sum 1..10 ────────────────────────────
let i = 1
let total = 0
while (i <= 10) {
    total = total + i
    i = i + 1
}
print("Sum 1-10: " + str(total))   # 55

# ─── 7. Functions — factorial ─────────────────────────────
fn factorial(n) {
    if (n <= 1) {
        return 1
    }
    return n * factorial(n - 1)
}
print("10! = " + str(factorial(10)))  # 3628800

# ─── 8. Functions — fibonacci ─────────────────────────────
fn fib(n) {
    if (n <= 1) { return n }
    return fib(n - 1) + fib(n - 2)
}
let k = 0
while (k <= 10) {
    print("fib(" + str(k) + ") = " + str(fib(k)))
    k = k + 1
}

# ─── 9. Native functions ──────────────────────────────────
print(sqrt(144))        # 12
print(abs(-99))         # 99
print(type(42))         # number
print(type("hi"))       # string
print(type(true))       # bool
print(toNum("3.14"))    # 3.14

# ─── 10. Closures via global scope ────────────────────────
fn counter_start(start) {
    return start
}
let c = counter_start(100)
print("Counter: " + str(c))

# ─── 11. String + number coercion ─────────────────────────
print("Answer: " + str(6 * 7))   # Answer: 42

# ─── 12. FizzBuzz ─────────────────────────────────────────
let n = 1
while (n <= 20) {
    if (n % 15 == 0) {
        print("FizzBuzz")
    } else {
        if (n % 3 == 0) {
            print("Fizz")
        } else {
            if (n % 5 == 0) {
                print("Buzz")
            } else {
                print(n)
            }
        }
    }
    n = n + 1
}
