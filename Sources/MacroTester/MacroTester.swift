import Foundation
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

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
  public static func testMacro(
    test: String = #function,
    filePath: String = #filePath,
    macros: [String: Macro.Type],
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    let testName = test.replacingOccurrences(of: "()", with: "")

    var input: String?
    var output: String?
    
    do {
        input = try sourceCode(
          fileName: "Input",
          test: testName,
          filePath: filePath
        )
        
        output = try sourceCode(
          fileName: "Output",
          test: testName,
          filePath: filePath
        )
    } catch let FixtureError.missingFile(path, _) {
        Issue.record("Did not find file at \(path)")
        return
    } catch {
        Issue.record("Unexpected error while loading fixtures for test \(testName): \(error)")
        return
    }

    guard let input else {
      return
    }
      
    guard let output else {
      return
    }
    
    assertMacroExpansion(
      input,
      expandedSource: output,
      macros: macros,
      file: file,
      line: line
    )
  }

  /// Load a fixture file from the path:
  ///
  /// Throws error if the file cannot be read.
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
  ) throws(FixtureError) -> String? {
    let url = URL(fileURLWithPath: filePath)
      .deletingLastPathComponent()
      .appendingPathComponent("Resources")
      .appendingPathComponent(test)
      .appendingPathComponent("\(fileName).swift.test")

    do {
      return try String(contentsOf: url, encoding: .utf8)
    } catch {
      throw FixtureError.missingFile(path: url.path, underlying: error)
    }
  }
}
