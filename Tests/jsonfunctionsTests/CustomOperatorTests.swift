//
//  CustomOperatorTests.swift
//  jsonfunctionsTests
//
//  Created by Christos Koninis on 3/15/21.
//

import XCTest
@testable import jsonfunctions
import JSON

private class CustomOperatorWrapper {
    var isCustomOperatorCalled = false
    var evalutedJSONInput: JSON?

    lazy var customOperator: ((JSON?) -> JSON) = { [weak self] json in
        guard let strongSelf = self else { return JSON.Null }
        strongSelf.isCustomOperatorCalled = true
        strongSelf.evalutedJSONInput = json

        guard let array = json?.array else { return JSON.Null }

        return array.reduce(into: JSON(0)) { (result, arrayItem) in
            //swiftlint:disable:next shorthand_operator
            result = result + arrayItem.toNumber()
        }
    }
}

class CustomOperatorTests: XCTestCase {

    func testCustomOperatorIsCalled_GivenItIsRegisted() throws {
        let rule =
            """
            { "plus" : [1, 2] }
            """

        let customOperatorWrapper = CustomOperatorWrapper()
        let customOperators = ["plus": customOperatorWrapper.customOperator]

        XCTAssertEqual(3, try JsonFunctions().applyRule(rule, customOperators: customOperators))
        XCTAssertTrue(customOperatorWrapper.isCustomOperatorCalled)
    }

    func testCustomOperatorIsNotCalled_GivenItIsNotRegisted() throws {
        let rule =
            """
            { "plus" : [1, 2] }
            """

        let customOperatorWrapper = CustomOperatorWrapper()

        let block = {
            try JsonFunctions().applyRule(rule, customOperators: [:]) as Int
        }

        try _XCTAssertThrowsError(try block(), "") {
            let parseError: ParseError = try XCTUnwrap($0 as? ParseError)
            XCTAssertEqual(parseError, .UnimplementedExpressionFor("plus"))
        }
        XCTAssertFalse(customOperatorWrapper.isCustomOperatorCalled)
    }

    func testCustomOperatorIsNotCalled_GivenItIsRegistedWithSameNameAsInternalOperators() {
        let rule =
            """
            { "*" : [1, 2] }
            """

        let customOperatorWrapper = CustomOperatorWrapper()
        let customOperators = ["*": customOperatorWrapper.customOperator]

        XCTAssertEqual(2, try JsonFunctions().applyRule(rule, customOperators: customOperators))
        XCTAssertFalse(customOperatorWrapper.isCustomOperatorCalled,
                       "the custom operator should not override the internal")
    }

    func testCustomOperatorIsGivenExpetedJSONToEvaluate() throws {
        let rule =
            """
            { "plus" : [1, {"var" : "aVariable"}] }
            """

        let data =
            """
            { "aVariable" : 3 }
            """

        let expectedJSONInput = JSON(string: "[1, 3]")

        let customOperatorWrapper = CustomOperatorWrapper()
        let customOperators = ["plus": customOperatorWrapper.customOperator]

        let result: Int = try JsonFunctions().applyRule(rule, to: data, customOperators: customOperators)
        XCTAssertEqual(4, result)
        XCTAssertEqual(expectedJSONInput, customOperatorWrapper.evalutedJSONInput)
    }
}
