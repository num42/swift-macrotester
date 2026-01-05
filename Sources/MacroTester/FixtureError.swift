internal enum FixtureError: Error, CustomStringConvertible {
  case missingFile(path: String, underlying: Error)

  var description: String {
    switch self {
    case .missingFile(let path, let underlying):
      return "Missing fixture at path: \(path) (error: \(underlying))"
    }
  }
}
