import XCTest
import JSON
import AnyCodable
@testable import jsonfunctions

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
    let definition: AnyDecodable

}

struct JsonFunctionDefinition: Decodable {

    let parameters: AnyDecodable
    let logic: AnyDecodable

}

struct JsonFunctionCall: Decodable {

    let name: String
    let parameters: AnyDecodable

}
