<h1 align=center><code>
A TSOwnable Contract implemented in Huff
</code></h1>

`TSOwnable` is a Two-Step Transfer Ownable contract implemented in [Huff](https://github.com/huff-language),
a low-level EVM programming language.

## Installation

1. Install Huff's [huffc](https://github.com/huff-language/huffc) compiler and the [foundry](https://github.com/foundry-rs/foundry) toolchain
2. Clone and `cd` into the repository
3. Run `forge install`

## Compilation

Compile huff contract via `huffc --bytecode src/TSOwnable.huff` and paste
the bytecode into the `test/TSOwnable.t.sol#setUp()` function.

## Tests

Run tests with `forge test`.

## Disclaimer

This is experimental software and is provided on an "as is" and "as available"
basis.

We do not give any warranties and will not be liable for any loss incurred
through any use of this codebase.
