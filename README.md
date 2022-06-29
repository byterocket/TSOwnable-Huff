<h1 align=center><code>
TSOwnable in Huff
</code></h1>

`TSOwnable` is a Two-Step Transfer Ownable contract implemented in [Huff](https://github.com/huff-language),
a low-level EVM programming language.

## Installation

1. Install Huff's [huff-rs](https://github.com/huff-language/huff-rs) compiler and the [foundry](https://github.com/foundry-rs/foundry) toolchain
2. Clone and `cd` into the repository
3. Run `forge install`

## Compilation

This project uses Huff's [HuffDeployer](https://github.com/huff-language/foundry-huff) library to
easily compile and test Huff contracts.

## Tests

Run tests with `forge test --ffi`.

> **Warning**
>
> The `HuffDeployer` library uses Huff's `huff-rs` compiler to compile and deploy Huff contracts.
> In order to call the `huff-rs` compiler, foundry's FFI cheatcode needs to be activated.
> **ONLY USE THE FFI FLAG IF YOU ARE CERTAIN THAT THE CODE IS NOT MALICIOUS!**

## Disclaimer

This is experimental software and is provided on an "as is" and "as available"
basis.

We do not give any warranties and will not be liable for any loss incurred
through any use of this codebase.
