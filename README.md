# MacroTester

A tiny Swift library that simplifies testing Swift macros with Swift Testing. It drives `SwiftSyntaxMacrosGenericTestSupport` and records failures with `Issue.record`, so they fail `@Test` functions.

## Requirements

- Swift 6.3 toolchain or later (tested with Xcode 27)
- Platforms: macOS 13, iOS 13, tvOS 13, watchOS 6, macCatalyst 13

## Fixture tests: `MacroTester.testMacro`

- Derives a test name from the calling test function (eg. `add3And7()` → `add3And7`).
- Looks up fixtures next to your test file at `Resources/<TestName>/Input.swift.test` and `Resources/<TestName>/Output.swift.test`.
- Compares the macro expansion to your expected output.

```swift
@Test func add3And7() {
  MacroTester.testMacro(macros: ["Add": AddMacro.self])
}
```

## Inline tests: `MacroTester.assertMacroExpansion`

A Swift Testing variant of SwiftSyntax's `assertMacroExpansion`, for example for diagnostics. The variant in `SwiftSyntaxMacrosTestSupport` reports failures through XCTest, which Swift Testing ignores.

```swift
@Test func structThrowsError() {
  MacroTester.assertMacroExpansion(
    """
    @AutoFactory
    struct NotAClass {}
    """,
    expandedSource: """
      struct NotAClass {}
      """,
    diagnostics: [.init(message: "@AutoFactory requires a class", line: 1, column: 1)],
    macros: ["AutoFactory": AutoFactoryMacro.self]
  )
}
```
