//
// json-functions-swift
//

import Foundation
import JSON

/**
    It parses json rule strings and executes the rules on provided data.
*/
public final class JsonFunctions {

    // MARK: - Init

    public init() { }

    // MARK: - Public

    /**
     It parses the string containing a json rule and applies that rule, you can optionally pass data to be used for the rule.

    - parameters:
         - jsonRule: A valid json rule string
         - jsonDataOrNil: Data for the rule to operate on
         - customOperators: custom operations that will be used during evalution

    - throws:
     - `JsonFunctionsError.canNotParseJSONRule`
     If The jsonRule could not be parsed, possible the syntax is invalid
     - `ParseError.UnimplementedExpressionFor(_ operator: String)` :
     If you pass an json logic operation that is not currently implemented
     - `ParseError.GenericError(String)` :
     An error occurred during parsing of the rule
      - `JsonFunctionsError.canNotConvertResultToType(Any.Type)` :
            When the result from the calculation can not be converted to the return type

            // This throws JsonFunctionsError.canNotConvertResultToType(Double)
            let r: Double = JsonFunctions("{ "===" : [1, 1] }").applyRule()
     - `JsonFunctionsError.canNotParseJSONData(String)` :
     If `jsonDataOrNil` is not valid json
    */
    public func applyRule<T>(_ jsonRule: String, to jsonDataOrNil: String? = nil, customOperators: [String: (JSON?) -> JSON]? = nil) throws -> T {
        guard let rule = JSON(string: jsonRule) else {
            throw JsonFunctionsError.canNotParseJSONRule("Not valid JSON object")
        }

        var jsonData: JSON?

        if let jsonDataOrNil = jsonDataOrNil {
            jsonData = JSON(string: jsonDataOrNil)
        }

        return try self.applyRule(rule, to: jsonData, customOperators: customOperators)
    }
    
    public func applyRule<T>(_ jsonRule: JSON, to jsonData: JSON? = nil, customOperators: [String: (JSON?) -> JSON]? = nil) throws -> T {
        let parsedRule = try Parser(json: jsonRule, customOperators: customOperators).parse()
        let result = try parsedRule.evalWithData(jsonData)

        let convertedToSwiftStandardType = try result.convertToSwiftTypes()

        switch convertedToSwiftStandardType {
        case let .some(value):
            guard let convertedResult = value as? T else {
                print(" canNotConvertResultToType \(T.self) from \(type(of: value))")
                throw JsonFunctionsError.canNotConvertResultToType(T.self)
            }

            return convertedResult
        default:
            // workaround for swift bug that cause to fail when casting
            // from generic type that resolves to Any? in certain compilers, see SR-14356
            #if compiler(>=5) && swift(<5)
            guard let convertedResult = (convertedToSwiftStandardType as Any) as? T else {
                // print("canNotConvertResultToType \(T.self) from \(type(of: convertedToSwiftStandardType))")
                throw JsonFunctionsError.canNotConvertResultToType(T.self)
            }
            #else
            guard let convertedResult = convertedToSwiftStandardType as? T else {
                // print("canNotConvertResultToType \(T.self) from \(type(of: convertedToSwiftStandardType))")
                throw JsonFunctionsError.canNotConvertResultToType(T.self)
            }
            #endif

            return convertedResult
        }
    }

    public func registerFunction(name: String, definition: JSON) {
        registeredFunctions[name] = definition
    }

    public func evaluateFunction(name: String, parameters: JSON) {

    }

    // MARK: - Private

    private var registeredFunctions = [String: JSON]()

}
