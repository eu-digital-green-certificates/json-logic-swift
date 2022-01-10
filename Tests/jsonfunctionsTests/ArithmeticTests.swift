//
//  Arithmetic.swift
//  jsonfunctionsTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonfunctions

class Arithmetic: XCTestCase {

    func testAddition() {
        var rule =
        """
        { "+" : [4, 2] }
        """
        XCTAssertEqual(6, try JsonFunctions().applyRule(rule, to: nil))

        rule =
        """
        { "+" : [4, "2"] }
        """
        XCTAssertEqual(6, try JsonFunctions().applyRule(rule, to: nil))

        rule =
        """
        { "+" : [2, 2, 2, 2, 2]}
        """
        XCTAssertEqual(10, try JsonFunctions().applyRule(rule, to: nil))

        rule =
        """
        { "+" : "3.14"}
        """
        XCTAssertEqual(3.14, try JsonFunctions().applyRule(rule, to: nil))
    }

    func testSubtraction() {
        var rule =
                """
                { "-" : [4, 2] }
                """
        XCTAssertEqual(2, try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                { "-" : [2, 3] }
                """
        XCTAssertEqual(-1, try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                { "-" : [3] }
                """
        XCTAssertEqual(-3, try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                 { "-" : [1, "1"] }
                """
        XCTAssertEqual(0, try JsonFunctions().applyRule(rule, to: nil))
    }

    func testMultiplication() {
        var rule =
                """
                { "*" : [4, 2] }
                """
        XCTAssertEqual(8, try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                { "*" : [2, 2, 2, 2, 2]}
                """
        XCTAssertEqual(32, try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                { "*" : [3, 2] }
                """
        XCTAssertEqual(6, try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                { "*" : [1]}
                """
        XCTAssertEqual(1, try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                { "*" : ["1", 1]}
                """
        XCTAssertEqual(1, try JsonFunctions().applyRule(rule, to: nil))
    }

    func testMultiplication_TypeCoercion() {
        var rule =
        """
        {"*":["2","2"]}
        """
        XCTAssertEqual(4, try JsonFunctions().applyRule(rule, to: nil))

        rule =
        """
        {"*":["2"]}
        """
        XCTAssertEqual(2, try JsonFunctions().applyRule(rule, to: nil))
    }

    func testDivision() {
        var rule =
        """
        { "/" : [4, 2]}
        """
        XCTAssertEqual(2, try JsonFunctions().applyRule(rule, to: nil))

        rule =
        """
        { "/" : [2, 4]}
        """
        XCTAssertEqual(0.5, try JsonFunctions().applyRule(rule, to: nil))

        rule =
        """
        { "+" : [2, 2, 2, 2, 2]}
        """
        XCTAssertEqual(10, try JsonFunctions().applyRule(rule, to: nil))

        rule =
        """
        { "/" : ["1", 1]}
        """
        XCTAssertEqual(1, try JsonFunctions().applyRule(rule, to: nil))
    }

    func testModulo() {
        var rule =
                """
                { "%" : [1, 2]}
                """
        XCTAssertEqual(1, try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                { "%" : [2, 2]}
                """
        XCTAssertEqual(0, try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                { "%" : [3, 2]}
                """
        XCTAssertEqual(1, try JsonFunctions().applyRule(rule, to: nil))
    }

    func testUnaryMinus() {
        var rule =
                """
                { "-" : [2] }
                """
        XCTAssertEqual(-2, try JsonFunctions().applyRule(rule, to: nil))

        rule =
                """
                { "-" : [-2] }
                """
        XCTAssertEqual(2, try JsonFunctions().applyRule(rule, to: nil))
    }
}
