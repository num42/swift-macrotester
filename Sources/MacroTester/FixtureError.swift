internal enum FixtureError: Error, CustomStringConvertible {
  case missingFile(path: String)

  var description: String {
    switch self {
    case .missingFile(let path):
      return "Missing fixture at path: \(path)"
    }
  }
}
