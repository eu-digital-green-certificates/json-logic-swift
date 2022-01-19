//
// json-functions-swift
//

import Foundation
import AnyCodable

public struct JsonFunctionDescriptor: Decodable {

    let name: String
    let definition: JsonFunctionDefinition

}

public struct JsonFunctionDefinition: Decodable {

    let parameters: [JsonFunctionParameter]
    let logic: AnyDecodable

}

public struct JsonFunctionParameter: Decodable {

    let name: String
    let `default`: AnyDecodable?

}
