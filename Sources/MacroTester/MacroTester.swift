import Foundation
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport

/// A lightweight helper to test Swift macro expansions using file-based fixtures.
///
/// `MacroTester` wraps `assertMacroExpansion` from `SwiftSyntaxMacrosTestSupport` and
/// loads fixtures from disk based on the calling test function name. It expects a
/// `Resources/<TestName>/` folder next to the test source file, containing
/// `Input.swift.test` and `Output.swift.test`.
public struct MacroTester {
  /// Assert that expanding the provided macros transforms the test input into the expected output.
  ///
  /// `MacroTester` derives the test name from the calling function by stripping the trailing
  /// `"()"` from `#function`. It then loads fixtures relative to the directory of the test file
  /// (`#filePath`).
  ///
  /// Fixture layout (relative to the test source file):
  ///
  /// ```
  /// <Tests>/YourMacroTests/
  ///   YourTestFile.swift
  ///   Resources/
  ///     <TestName>/
  ///       Input.swift.test
  ///       Output.swift.test
  /// ```
  ///
  /// - Parameters:
  ///   - test: The calling test function name (defaults to `#function`). Used to derive `<TestName>`
  ///           by removing a trailing `()`.
  ///   - filePath: The full path of the calling test source file (defaults to `#filePath`). Used to
  ///               resolve the `Resources` folder next to the test file.
  ///   - macros: A dictionary mapping the macro name as it appears in source (e.g. `"AutoInit"`,
  ///             `"stringify"`) to its corresponding macro type.
  ///
  /// - Important: This helper force-unwraps fixture loading. If a file is missing or unreadable,
  ///              the test will crash. Ensure both `Input.swift.test` and `Output.swift.test` exist
  ///              under the expected folder for the given test name.
  public static func testMacro(
    test: String = #function,
    filePath: String = #filePath,
    macros: [String: Macro.Type]
  ) {
    let testName = test.replacingOccurrences(of: "()", with: "")

    assertMacroExpansion(
        inputSourceCode(
            for: testName,
            filePath: filePath
        ),
        expandedSource: outputSourceCode(
            for: testName,
            filePath: filePath
        ),
      macros: macros
    )
  }

  /// Load the contents of `Input.swift.test` for the given test name.
  ///
  /// - Parameters:
  ///   - test: The test name (folder under `Resources`).
  ///   - filePath: The path of the calling test source file used to resolve the fixture directory.
  /// - Returns: The input source code as a `String`.
  private static func inputSourceCode(
      for test: String,
      filePath: String
  ) -> String {
      sourceCode(
        fileName: "Input",
        test: test,
        filePath: filePath
      )
  }

  /// Load the contents of `Output.swift.test` for the given test name.
  ///
  /// - Parameters:
  ///   - test: The test name (folder under `Resources`).
  ///   - filePath: The path of the calling test source file used to resolve the fixture directory.
  /// - Returns: The expected expanded source code as a `String`.
  private static func outputSourceCode(
      for test: String,
      filePath: String
  ) -> String {
      sourceCode(
        fileName: "Output",
        test: test,
        filePath: filePath
      )
  }

  /// Load a fixture file from the path:
  ///
  /// `dir(#filePath)/Resources/<test>/<fileName>.swift.test`
  ///
  /// Uses `try!` and will crash if the file cannot be read. If you prefer graceful failures,
  /// consider changing this to `throws` and surfacing a clearer error.
  ///
  /// - Parameters:
  ///   - fileName: The base name of the fixture file (e.g., `"Input"` or `"Output"`).
  ///   - test: The test name (folder under `Resources`).
  ///   - filePath: The path of the calling test source file used to resolve the fixture directory.
  /// - Returns: The file contents as a `String`. 
  private static func sourceCode(
      fileName: String,
      test: String,
      filePath: String
  ) -> String {
    try! String(
      contentsOf: URL(fileURLWithPath: filePath)
        .deletingLastPathComponent()
        .appendingPathComponent("Resources")
        .appendingPathComponent(test)
        .appendingPathComponent("\(fileName).swift.test")
    )
  }
}
