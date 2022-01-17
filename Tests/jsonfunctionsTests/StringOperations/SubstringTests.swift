//
//  IfTests.swift
//  jsonfunctionsTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonfunctions

class SubstringTests: XCTestCase {

    func testSubstring() {
        var rule =
                """
                {"substr":["jsonlogic", 4]}
                """
        XCTAssertEqual("logic", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", -5]}
                """
        XCTAssertEqual("logic", try JsonFunctions().applyRule(rule, to: nil))
    }

    func testSubstring_withRange() {
        var rule =
                """
                {"substr":["jsonlogic", 0, 1]}
                """
        XCTAssertEqual("j", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", -1, 1]}
                """
        XCTAssertEqual("c", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", 4, 5]}
                """
        XCTAssertEqual("logic", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", -5, 5]}
                """
        XCTAssertEqual("logic", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", -5, -2]}
                """
        XCTAssertEqual("log", try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonlogic", 1, -5]}
                """
        XCTAssertEqual("son", try JsonFunctions().applyRule(rule, to: nil))
    }

    func testSunString_withInvalidLength() {
        let rule =
                """
                {"substr":["jsonfunctions", 1, null]}
                """
        XCTAssertNil(try JsonFunctions().applyRule(rule, to: nil))
    }

    func testSunString_withInvalidStart() {
        var rule =
                """
                {"substr":["jsonfunctions", null, 1]}
                """
        XCTAssertNil(try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonfunctions", null]}
                """
        XCTAssertNil(try JsonFunctions().applyRule(rule, to: nil))
    }
}
