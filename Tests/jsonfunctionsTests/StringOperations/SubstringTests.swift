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
                {"substr":["jsonfunctions", 4]}
                """
        XCTAssertEqual("logic", try applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonfunctions", -5]}
                """
        XCTAssertEqual("logic", try applyRule(rule, to: nil))
    }

    func testSubstring_withRange() {
        var rule =
                """
                {"substr":["jsonfunctions", 0, 1]}
                """
        XCTAssertEqual("j", try applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonfunctions", -1, 1]}
                """
        XCTAssertEqual("c", try applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonfunctions", 4, 5]}
                """
        XCTAssertEqual("logic", try applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonfunctions", -5, 5]}
                """
        XCTAssertEqual("logic", try applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonfunctions", -5, -2]}
                """
        XCTAssertEqual("log", try applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonfunctions", 1, -5]}
                """
        XCTAssertEqual("son", try applyRule(rule, to: nil))
    }

    func testSunString_withInvalidLength() {
        let rule =
                """
                {"substr":["jsonfunctions", 1, null]}
                """
        XCTAssertNil(try applyRule(rule, to: nil))
    }

    func testSunString_withInvalidStart() {
        var rule =
                """
                {"substr":["jsonfunctions", null, 1]}
                """
        XCTAssertNil(try applyRule(rule, to: nil))

        rule =
                """
                {"substr":["jsonfunctions", null]}
                """
        XCTAssertNil(try applyRule(rule, to: nil))
    }
}
