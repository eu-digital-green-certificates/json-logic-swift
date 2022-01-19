//
//  IfTests.swift
//  jsonfunctionsTests
//
//  Created by Christos Koninis on 11/02/2019.
//

import XCTest
@testable import jsonfunctions

class InTests: XCTestCase {

    func testIn_StringArgument() {
        var rule =
        """
        { "in" : ["Spring", "Springfield"] }
        """
        XCTAssertEqual(true, try JsonFunctions().applyRule(rule, to: nil))

        rule =
        """
        {"in":["Spring","Springfield"]}
        """
        XCTAssertEqual(true, try JsonFunctions().applyRule(rule, to: nil))

        rule =
        """
        {"in":["i","team"]}
        """
        XCTAssertEqual(false, try JsonFunctions().applyRule(rule, to: nil))
    }

    func testIn_ArrayArgument() {
        var rule =
        """
        {"in":["Bart",["Bart","Homer","Lisa","Marge","Maggie"]]}
        """
        XCTAssertEqual(true, try JsonFunctions().applyRule(rule, to: nil))

        rule =
        """
        {"in":["Milhouse",["Bart","Homer","Lisa","Marge","Maggie"]]}
        """
        XCTAssertEqual(false, try JsonFunctions().applyRule(rule, to: nil))
    }
}
