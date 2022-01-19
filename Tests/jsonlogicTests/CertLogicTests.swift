//
//  File.swift
//
//
//  Created by Steffen on 22.06.21.
//

import Foundation
import JSON
import XCTest

@testable import jsonlogic

final class CertLogicTests: XCTestCase {

    func testEmptyData() {
        XCTAssertFalse(try applyRule("{}"))
    }

    func testCertLogic() throws {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! + "/dgc-business-rules/certlogic/specification/testSuite"

        let rulefiles = fm.enumerator(atPath: path)
        try XCTSkipIf(rulefiles == nil)

        while let rulefile = rulefiles?.nextObject() {
            let rPath = try XCTUnwrap(rulefile as? String)
            let jsonPath = path + "/" + rPath
            let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .mappedIfSafe)
            let json = JSON.init(data)

            let cases = try XCTUnwrap(json["cases"].array)

            guard json["directive"] != "skip" else {
                return
            }

            for c in cases.enumerated() {

                let asserts = try XCTUnwrap(c.element["assertions"].array)
                let name = try XCTUnwrap(c.element["name"].string)
                var counter = 0
                for a in asserts.enumerated() {
                    counter = counter + 1
                    print(name + " Assertion : \(counter)")
                    let clogic = c.element["certLogicExpression"]

                    if clogic.truthy() {
                        let expectedType = a.element["expected"].type

                        switch expectedType {
                        case JSON.ContentType.string:
                            XCTAssertEqual(
                                    try applyRule(c.element["certLogicExpression"], to: a.element["data"]),
                                    a.element["expected"].string)
                        case JSON.ContentType.bool:
                            XCTAssertEqual(
                                    try applyRule(c.element["certLogicExpression"], to: a.element["data"]),
                                    a.element["expected"].bool)
                        case JSON.ContentType.null:
                            XCTAssertNil(try applyRule(c.element["certLogicExpression"], to: a.element["data"]))
                        case JSON.ContentType.object:
                            switch name {
                            case "should work as binary operator":
                                XCTAssertEqual(
                                        try applyRule(c.element["certLogicExpression"], to: a.element["data"]),
                                        a.element["expected"].dictionary)
                            case "should return data context on \"\"":
                                XCTAssertEqual(
                                        try applyRule(c.element["certLogicExpression"], to: a.element["data"]),
                                        ["foo": "bar"])
                            default: XCTAssertFalse(true)
                            }
                        case JSON.ContentType.number:
                            switch name {
                            case "should drill into data (1)":
                                XCTAssertEqual(
                                        try applyRule(c.element["certLogicExpression"], to: a.element["data"]), 1)
                            case "should drill into data (2)":
                                XCTAssertEqual(
                                        try applyRule(c.element["certLogicExpression"], to: a.element["data"]), 1)
                            case "should drill into data (3)":
                                XCTAssertEqual(
                                        try applyRule(c.element["certLogicExpression"], to: a.element["data"]), 1)
                            case "var-ing non-existing array elements":
                                XCTAssertEqual(
                                        try applyRule(c.element["certLogicExpression"], to: a.element["data"]), 2)
                            default:
                                XCTAssertFalse(true)
                            }
                        case JSON.ContentType.array:
                            XCTAssertEqual(
                                    try applyRule(c.element["certLogicExpression"], to: a.element["data"]),
                                    a.element["expected"])
                        default:
                            XCTAssertEqual(
                                    try applyRule(c.element["certLogicExpression"], to: a.element["data"]),
                                    a.element["expected"])
                        }
                    } else {

                        let expectedType = a.element["expected"].type

                        switch expectedType {
                        case JSON.ContentType.string:
                            XCTAssertEqual(
                                    try applyRule(a.element["certLogicExpression"], to: a.element["data"]),
                                    a.element["expected"].string)
                        case JSON.ContentType.bool:
                            XCTAssertEqual(
                                    try applyRule(a.element["certLogicExpression"], to: a.element["data"]),
                                    a.element["expected"].bool)
                        case JSON.ContentType.null:
                            XCTAssertNil(try applyRule(a.element["certLogicExpression"], to: a.element["data"]))
                        case JSON.ContentType.number:
                            switch name {
                            case "# Non-rules get passed through":
                                XCTAssertEqual(
                                        try applyRule(a.element["certLogicExpression"], to: a.element["data"]), 17)
                            case "# Single operator tests":
                                XCTAssertEqual(
                                        try applyRule(a.element["certLogicExpression"], to: a.element["data"]), 3)
                            case "Truthy and falsy definitions matter in Boolean operations":
                                XCTAssertEqual(
                                        try applyRule(a.element["certLogicExpression"], to: a.element["data"]), 0)
                            case "# Data-Driven":
                                XCTAssertEqual(
                                        try applyRule(a.element["certLogicExpression"], to: a.element["data"]), 1)
                            case "Filter, map, all, none, and some":
                                if a.element["expected"].int == 10 {
                                    XCTAssertEqual(
                                            try applyRule(a.element["certLogicExpression"], to: a.element["data"]), 10)
                                }
                                if a.element["expected"].int == 0 {
                                    XCTAssertEqual(
                                            try applyRule(a.element["certLogicExpression"], to: a.element["data"]), 0)
                                }
                                if a.element["expected"].int == 6 {
                                    XCTAssertEqual(
                                            try applyRule(a.element["certLogicExpression"], to: a.element["data"]), 6)
                                }
                            default:
                                XCTAssertFalse(true)
                            }

                        case JSON.ContentType.array:
                            switch name {
                            case "# Non-rules get passed through":
                                XCTAssertEqual(
                                        try applyRule(a.element["certLogicExpression"], to: a.element["data"]),
                                        ["a", "b"])
                            case "Truthy and falsy definitions matter in Boolean operations":
                                XCTAssertEqual(
                                        try applyRule(a.element["certLogicExpression"], to: a.element["data"]),
                                        a.element["expected"].array)
                            default:
                                XCTAssertFalse(true)
                            }
                        default:
                            XCTAssertEqual(
                                    try applyRule(a.element["certLogicExpression"], to: a.element["data"]),
                                    a.element["expected"])
                        }
                    }
                }
            }
        }
    }

    func testRunner() throws {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath! + "/dgc-business-rules-testdata"

        let rulefiles = fm.enumerator(atPath: path)
        try XCTSkipIf(rulefiles == nil)
        
        while let rulefile = rulefiles?.nextObject() {

            let rulepath = try XCTUnwrap(rulefile as? String)
            guard rulepath.contains("rule.json") else {
                continue
            }

            let jsonpath = path + "/" + rulepath
            let data = try Data(contentsOf: URL(fileURLWithPath: jsonpath), options: .mappedIfSafe)
            let json = JSON.init(data)

            let components = (rulepath as NSString).pathComponents

            let testfpath = path + "/" + components[0] + "/" + components[1] + "/tests"
            let testfiles = fm.enumerator(atPath: testfpath)

            while let testfile = testfiles?.nextObject() {
                let testpath = try XCTUnwrap(testfile as? String)
                let tjsonpath = testfpath + "/" + testpath
                let tdata = try Data(
                        contentsOf: URL(fileURLWithPath: tjsonpath), options: .mappedIfSafe)
                let tjson = JSON.init(tdata)
                let expectedValue = tjson["expected"].bool

                if expectedValue != nil {
                    print("Test " + tjsonpath)
                    if expectedValue.unsafelyUnwrapped {
                        XCTAssertTrue(try applyRule(json["Logic"], to: tjson))
                    } else {
                        XCTAssertFalse(try applyRule(json["Logic"], to: tjson))
                    }
                }
            }
        }
    }
}
