import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

extension XCTestCase {
  public func testMacro(test: String = #function, filePath: String = #filePath, macros: [String: Macro.Type]) {
    let testName = test.replacingOccurrences(of: "()", with: "")

    assertMacroExpansion(
      inputSourceCode(for: testName, filePath: filePath),
      expandedSource: outputSourceCode(for: testName, filePath: filePath),
      macros: macros
    )
  }

  private func inputSourceCode(for test: String, filePath: String) -> String {
    sourceCode(fileName: "Input", test: test, filePath: filePath)
  }

  private func outputSourceCode(for test: String, filePath: String) -> String {
    sourceCode(fileName: "Output", test: test, filePath: filePath)
  }

  private func sourceCode(fileName: String, test: String, filePath: String) -> String {
    try! String(
      contentsOf: URL(fileURLWithPath: filePath)
        .deletingLastPathComponent()
        .appendingPathComponent("Resources")
        .appendingPathComponent(test)
        .appendingPathComponent("\(fileName).swift.test")
    )
  }
}
