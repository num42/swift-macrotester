internal import MacroTester
internal import SwiftSyntax
internal import SwiftSyntaxMacros
internal import Testing

struct AddsMemberMacro: MemberMacro {
  static func expansion(
    of attribute: AttributeSyntax,
    providingMembersOf declaration: some DeclGroupSyntax,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [DeclSyntax] {
    ["var added: Int { 1 }"]
  }
}

let testMacros: [String: Macro.Type] = [
  "AddsMember": AddsMemberMacro.self
]

@Suite
struct MacroTesterTests {
  @Test func addsMember() {
    MacroTester.testMacro(macros: testMacros)
  }
}
