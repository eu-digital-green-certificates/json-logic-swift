//
// json-functions-swift
//

import Foundation
import JSON
import AnyCodable

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
        let parsedRule = try Parser(
            json: jsonRule,
            customOperators: customOperators,
            registeredFunctions: registeredFunctions
        ).parse()

        let data = jsonData ?? .Null
        let result = try parsedRule.eval(with: data)

        return try convertToSwiftType(result)
    }

    public func registerFunction(name: String, definition: JsonFunctionDefinition) {
        registeredFunctions[name] = definition
    }

    public func evaluateFunction<T>(name: String, parameters: [String: AnyDecodable]) throws -> T {
        guard let definition = registeredFunctions[name] else {
            throw JsonFunctionsError.noSuchFunction
        }

        let data = definition.parameters.reduce(into: [String: JSON]()) {
            $0[$1.name] = JSON(parameters[$1.name]?.value ?? $1.`default`?.value as Any)
        }

        guard let logicArray = definition.logic.value as? Array<Any> else {
            throw ParseError.InvalidParameters("Logic in function definition must be array")
        }

        return try applyRule(JSON(["script": logicArray]), to: JSON(data))
    }

    // MARK: - Private

    private var registeredFunctions = [String: JsonFunctionDefinition]()

    private func convertToSwiftType<T>(_ json: JSON) throws -> T {
        let convertedToSwiftStandardType = try json.convertToSwiftTypes()

        switch convertedToSwiftStandardType {
        case let .some(value):
            guard let convertedResult = value as? T else {
                print("canNotConvertResultToType \(T.self) from \(type(of: value))")
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

}
