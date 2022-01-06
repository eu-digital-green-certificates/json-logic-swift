import XCTest
import JSON
import AnyCodable
@testable import jsonlogic

struct JsonFunctionsTestCases: Decodable {

    let testCases: [JsonFunctionsTestCase]

}

struct JsonFunctionsTestCase: Decodable {

    let title: String
    let functions: [JsonFunctionDescriptor]?
    let evaluateFunction: JsonFunctionCall?
    let logic: AnyDecodable?
    let data: AnyDecodable?
    let exp: AnyDecodable?
    let `throws`: Bool?

}

struct JsonFunctionDescriptor: Decodable {

    let name: String

}

struct JsonFunctionCall: Decodable {

    let name: String

}
