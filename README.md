# MacroTester

A tiny Swift library that simplifies testing Swift macros by driving `SwiftSyntaxMacrosTestSupport` with file-based fixtures. It provides a single helper, `MacroTester.testMacro`, which loads your input and expected output from disk and asserts the expansion matches.

## What it does

- Derives a test name from the calling test function (eg. `add3And7()` → `add3And7`).
- Looks up fixtures next to your test file at `Resources/<TestName>/Input.swift.test` and `Resources/<TestName>/Output.swift.test`.
- Calls `assertMacroExpansion` from SwiftSyntax to compare the macro expansion to your expected output.
