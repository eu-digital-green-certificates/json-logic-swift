//
// json-functions-swift
//

import Foundation
import JSON

/**
    It parses json rule strings and executes the rules on provided data.
*/
public final class JsonLogic {

    // The parsed json string to an Expression that can be used for evaluation upon specific data
    private let parsedRule: Expression

    /**
    It parses the string containing a json logic and caches the result for reuse.

    All calls to `applyRule()` will use the same parsed rule.

    - parameters:
        - jsonRule: A valid json rule string

    - throws:
      - `JSONLogicError.canNotParseJSONRule`
     If The jsonRule could not be parsed, possible the syntax is invalid
      - `ParseError.UnimplementedExpressionFor(_ operator: String)` :
     If you pass an json logic operation that is not currently implemented
      - `ParseError.GenericError(String)` :
     An error occurred during parsing of the rule
    */
    public convenience init(_ jsonRule: String) throws {
        try self.init(jsonRule, customOperators: nil)
    }

    public convenience init(_ jsonRule: JSON) throws {
        try self.init(jsonRule, customOperators: nil)
    }

    /**
    It parses the string containing a json logic and caches the result for reuse.

    All calls to `applyRule()` will use the same parsed rule.

    - parameters:
        - jsonRule: A valid json rule string
        - customOperators: custom operations that will be used during evalution

    - throws:
      - `JSONLogicError.canNotParseJSONRule`
     If The jsonRule could not be parsed, possible the syntax is invalid
      - `ParseError.UnimplementedExpressionFor(_ operator: String)` :
     If you pass an json logic operation that is not currently implemented
      - `ParseError.GenericError(String)` :
     An error occurred during parsing of the rule
    */
    public init(_ jsonRule: String, customOperators: [String: (JSON?) -> JSON]?) throws {
        guard let rule = JSON(string: jsonRule) else {
            throw JSONLogicError.canNotParseJSONRule("Not valid JSON object")
        }
        parsedRule = try Parser(json: rule, customOperators: customOperators).parse()
    }
    public init(_ jsonRule: JSON, customOperators: [String: (JSON?) -> JSON]?) throws {
        parsedRule = try Parser(json: jsonRule, customOperators: customOperators).parse()
    }

    /**
    It applies the rule, you can optionally pass data to be used for the rule.

    - parameter jsonDataOrNil: Data for the rule to operate on

    - throws:
      - `JSONLogicError.canNotConvertResultToType(Any.Type)` :
              When the result from the calculation can not be converted to the return type

            //This throws JSONLogicError.canNotConvertResultToType(Double)
            let r: Double = JsonLogic("{ "===" : [1, 1] }").applyRule()
      - `JSONLogicError.canNotParseJSONData(String)` :
     If `jsonDataOrNil` is not valid json
    */
    public func applyRule<T>(to jsonDataOrNil: String? = nil) throws -> T {
        var jsonData: JSON?

        if let jsonDataOrNil = jsonDataOrNil {
            jsonData = JSON(string: jsonDataOrNil)
        }
         return try self.applyRuleInternal(to: jsonData)
    }
    
    public func applyRuleInternal<T>(to jsonData: JSON? = nil) throws -> T {
        let result = try parsedRule.evalWithData(jsonData)

        let convertedToSwiftStandardType = try result.convertToSwiftTypes()

        switch convertedToSwiftStandardType {
        case let .some(value):
            guard let convertedResult = value as? T else {
                print(" canNotConvertResultToType \(T.self) from \(type(of: value))")
                throw JSONLogicError.canNotConvertResultToType(T.self)
            }

            return convertedResult
        default:
            // workaround for swift bug that cause to fail when casting
            // from generic type that resolves to Any? in certain compilers, see SR-14356
            #if compiler(>=5) && swift(<5)
            guard let convertedResult = (convertedToSwiftStandardType as Any) as? T else {
                // print("canNotConvertResultToType \(T.self) from \(type(of: convertedToSwiftStandardType))")
                throw JSONLogicError.canNotConvertResultToType(T.self)
            }
            #else
            guard let convertedResult = convertedToSwiftStandardType as? T else {
                // print("canNotConvertResultToType \(T.self) from \(type(of: convertedToSwiftStandardType))")
                throw JSONLogicError.canNotConvertResultToType(T.self)
            }
            #endif

            return convertedResult
        }
    }

}
