//
//  IfTests.swift
//  jsonfunctionsTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonfunctions

//swiftlint:disable function_body_length
class IfTests: XCTestCase {

    func testIf_ToofewArgs() {
        var rule =
                """
                { "if":[ [], "apple", "banana"] }
                """
        XCTAssertEqual("banana", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                { "if":[ [1], "apple", "banana"] }
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                { "if":[ [1,2,3,4], "apple", "banana"] }
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))
    }

    func testIf_SimpleCases() {
        var rule =
                """
                    {"if":[ {">":[2,1]}, "apple", "banana"]}
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                   {"if":[ {">":[1,2]}, "apple", "banana"]}
                """
        XCTAssertEqual("banana", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", true, "banana", "carrot"]}
                """
        XCTAssertEqual("banana", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", true, "banana", true, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))
    }

    func testIf_EmptyArraysAreFalsey() {
        var rule =
                """
                { "if" : [] }
                """
        XCTAssertNil(try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                { "if" : [true] }
                """
        XCTAssertEqual(true, try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                { "if" : [false] }
                """
        XCTAssertEqual(false, try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                { "if" : ["apple"] }
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))
    }

    func testIf_NonEmptyOtherStringsAreTruthy() {
        var rule =
                """
                {"if":[ "", "apple", "banana"]}
                """
        XCTAssertEqual("banana", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[ "zucchini", "apple", "banana"]}
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[ "0", "apple", "banana"]}
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))
    }

    func testIf_IfThenElseIfThenCases() {
        var rule =
                """
                {"if":[true, "apple", true, "banana"]}
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", false, "banana"]}
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", true, "banana"]}
                """
        XCTAssertEqual("banana", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", false, "banana"]}
                """
        XCTAssertNil(try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", true, "banana", "carrot"]}
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", false, "banana", "carrot"]}
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", true, "banana", "carrot"]}
                """
        XCTAssertEqual("banana", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", false, "banana", "carrot"]}
                """
        XCTAssertEqual("carrot", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", false, "banana", false, "carrot"]}
                """
        XCTAssertNil(try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", false, "banana", false, "carrot", "date"]}
                """
        XCTAssertEqual("date", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[false, "apple", true, "banana", false, "carrot", "date"]}
                """
        XCTAssertEqual("banana", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", false, "banana", false, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", false, "banana", true, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", true, "banana", false, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"if":[true, "apple", true, "banana", true, "carrot", "date"]}
                """
        XCTAssertEqual("apple", try JsonFunctions().applyRule(rule, to: nil))
    }

    func testIf_FizzBuzz() {
        let rule =
                """
                {
                "if": [
                {"==": [ { "%": [ { "var": "i" }, 15 ] }, 0]},
                "fizzbuzz",

                {"==": [ { "%": [ { "var": "i" }, 3 ] }, 0]},
                "fizz",

                {"==": [ { "%": [ { "var": "i" }, 5 ] }, 0]},
                "buzz",

                { "var": "i" }
                ]
                }
                """

        XCTAssertEqual("fizzbuzz", try JsonFunctions().applyRule(rule, to: "{\"i\" : 0}"))
        XCTAssertEqual(1, try JsonFunctions().applyRule(rule, to: "{\"i\" : 1}"))
        XCTAssertEqual(2, try JsonFunctions().applyRule(rule, to: "{\"i\" : 2}"))
        XCTAssertEqual("fizz", try JsonFunctions().applyRule(rule, to: "{\"i\" : 3}"))
        XCTAssertEqual("buzz", try JsonFunctions().applyRule(rule, to: "{\"i\" : 5}"))
        XCTAssertEqual("fizzbuzz", try JsonFunctions().applyRule(rule, to: "{\"i\" : 15}"))
        XCTAssertEqual("fizzbuzz", try JsonFunctions().applyRule(rule, to: "{\"i\" : 45}"))
    }
}
