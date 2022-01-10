//
// json-functions-swift
//

import jsonfunctions

//Example parsing

let rule =
"""
{ "var" : "name" }
"""
let data =
"""
{ "name" : "Jon" }
"""

let result: String? = try? JsonFunctions().applyRule(rule, to: data)

print("result = \(String(describing: result))")
