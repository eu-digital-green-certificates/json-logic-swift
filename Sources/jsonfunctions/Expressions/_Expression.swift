//
// json-functions-swift
//

import Foundation
import JSON

protocol Expression {

    func evalWithData(_ data: JSON?) throws -> JSON

}
