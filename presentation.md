# About V lang

**V** is a compiled, "simple", and safe programming language focused on **speed, safety, and productivity**. Inspired by languages such as **Go**, **Rust**, and **Python**, V is designed to be easy to use while offering low-level control and high performance.

- Seems to be very fast
- Memory safety by default
- Familiar syntax
- Cross-compilation support with a single command (`v -os windows hello.v`)
- Built-in tools like `v fmt`, `v test`, and `v doc`

#### About Safety
- Bounds checking
- No undefined values
- No variable shadowing
- Immutable variables by default
- Immutable structs by default
- Option/Result and mandatory error checks
- Sum types
- Generics
- Immutable function args by default, mutable args have to be marked on call
- No null (allowed in unsafe code)
- No undefined behavior new!
- No global variables (can be enabled for low level apps like kernels via a flag)
- It havelow-level memory management options, including a default garbage collector, an "autofree" system that automates memory deallocation, and manual memory management capabilities. 

## Key Features


---

## My sources

https://www.youtube.com/watch?v=6UAlDIzqhBo
https://www.geeksforgeeks.org/design-bookmyshow-a-system-design-interview-question/
https://dev-shivansh95.medium.com/low-level-design-for-bookmyshow-8db8465e560a
https://www.geeksforgeeks.org/design-movie-ticket-booking-system-like-bookmyshow/
https://kashish97.medium.com/how-bookmyshow-leveraged-technology-to-manage-coldplay-concert-ticket-sales-c479d1abe895
