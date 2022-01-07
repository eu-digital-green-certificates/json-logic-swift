//
//  ExtractFromUVCI.swift
//  json-functions-swift
//
//  Created by Nick Guendling on 2022-01-07.
//  Licensed under MIT
//

import Foundation
import JSON

public let optionalPrefix = "URN:UVCI:"

struct ExtractFromUVCI: Expression {

    let expression: Expression
    
    func evalWithData(_ data: JSON?) throws -> JSON {
        guard let data = data else { return JSON.Null }

        let result = try expression.evalWithData(data)
        if let arr = result.array,
           let uvci = arr[0]["data"].string,
           let index = arr[1].int
        {
            guard let extractedUVCI = fromUVCI(uvci: uvci, index: Int(index)) else { return JSON.Null}
            return JSON(extractedUVCI)
        }

        if let arr = result.array,
           let uvci = arr[0].string,
           let index = arr[1].int
        {
            guard let extractedUVCI = fromUVCI(uvci: uvci, index: Int(index)) else { return JSON.Null}
            return JSON(extractedUVCI)
        }
        
        return .Null
    }

    func evaluateVarPathFromData(_ data: JSON) throws -> String? {
        let variablePathAsJSON = try self.expression.evalWithData(data)

        switch variablePathAsJSON {
        case let .String(string):
            return string
        case let .Array(array):
            return array.first?.string
        default:
            return nil
        }
    }

}

/**
 * @returns The fragment with given index from the UVCI string
 *  (see Annex 2 in the [UVCI specification](https://ec.europa.eu/health/sites/default/files/ehealth/docs/vaccination-proof_interoperability-guidelines_en.pdf)),
 *  or `null` when that fragment doesn't exist.
 */
func fromUVCI(uvci: String?, index: Int) -> String? {
    guard let uvci = uvci, index >= 0 else  {
        return nil
    }

    let prefixlessUvci = uvci.starts(with: optionalPrefix) ? uvci.substring(from: optionalPrefix.count) : uvci
    let separators = CharacterSet(charactersIn: "/#:")
    let fragments = prefixlessUvci.components(separatedBy: separators)

    return index < fragments.count ? fragments[index] : nil
}
