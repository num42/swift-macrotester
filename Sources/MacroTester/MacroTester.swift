import Foundation
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport

public struct MacroTester {
    public static func testMacro(
        testName: String,
        filePath: String = #filePath,
        macros: [String: Macro.Type]
    ) {
        assertMacroExpansion(
            inputSourceCode(for: testName, filePath: filePath),
            expandedSource: outputSourceCode(for: testName, filePath: filePath),
            macros: macros
        )

        assertMacroExpansion(
            inputSourceCode(for: testName, filePath: filePath),
            expandedSource: outputSourceCode(for: testName, filePath: filePath),
            macros: macros
        )
    }

    private static func inputSourceCode(for test: String, filePath: String) -> String {
        sourceCode(fileName: "Input", test: test, filePath: filePath)
    }

    private static func outputSourceCode(for test: String, filePath: String) -> String {
        sourceCode(fileName: "Output", test: test, filePath: filePath)
    }

    private static func sourceCode(fileName: String, test: String, filePath: String) -> String {
        try! String(
            contentsOf: URL(fileURLWithPath: filePath).deletingLastPathComponent().appendingPathComponent("Resources").appendingPathComponent(test).appendingPathComponent("\(fileName).swift.test")
        )
    }
}
