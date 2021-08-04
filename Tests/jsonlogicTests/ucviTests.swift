//
//  File.swift
//  
//
//  Created by Alexandr Chernyy on 03.08.2021.
//

import XCTest
@testable import jsonlogic
import JSON

class ucviTests: XCTestCase {
  
  func testUVCI() {
      var rule =
      """
        { "extractFromUVCI": [  { "var": "" },  -1  ] }
      """
      XCTAssertNil(try applyRule(rule, to: nil))
      XCTAssertNil(try applyRule(rule, to: "{}"))
      var data = """
        { "data": "URN:UVCI:01:NL:187/37512422923" }
      """
      XCTAssertNil(try applyRule(rule, to: data))

      rule =
      """
        { "extractFromUVCI": [  { "var": "" },  0  ] }
      """
      XCTAssertNil(try applyRule(rule, to: nil))
      data = """
        { "data": "" }
      """
      XCTAssertEqual("", try applyRule(rule, to: data))
      data = """
        { "data": "URN:UVCI:01:NL:187/37512422923" }
      """
      XCTAssertEqual("01", try applyRule(rule, to: data))

      rule =
        """
          { "extractFromUVCI": [  { "var": "" },  1  ] }
      """
      XCTAssertNil(try applyRule(rule, to: nil))
      data = """
        { "data": "" }
      """
      XCTAssertNil(try applyRule(rule, to: data))
      data = """
        { "data": "URN:UVCI:01:NL:187/37512422923" }
      """
      XCTAssertEqual("NL", try applyRule(rule, to: data))
      data = """
        { "data": "01:NL:187/37512422923" }
      """
      XCTAssertEqual("NL", try applyRule(rule, to: data))
      data = """
        { "data": "URN:UVCI:01:AT:10807843F94AEE0EE5093FBC254BD813#B" }
      """
      XCTAssertEqual("AT", try applyRule(rule, to: data))
      data = """
        { "data": "01:AT:10807843F94AEE0EE5093FBC254BD813#B" }
      """
      XCTAssertEqual("AT", try applyRule(rule, to: data))

    rule =
      """
        { "extractFromUVCI": [  { "var": "" },  2  ] }
    """
    data = """
      { "data": "URN:UVCI:01:NL:187/37512422923" }
    """
    XCTAssertEqual("187", try applyRule(rule, to: data))
    data = """
      { "data": "URN:UVCI:01:AT:10807843F94AEE0EE5093FBC254BD813#B" }
    """
    XCTAssertEqual("10807843F94AEE0EE5093FBC254BD813", try applyRule(rule, to: data))
    data = """
      { "data": "foo/bar::baz#999lizards" }
    """
    XCTAssertEqual("", try applyRule(rule, to: data))

    rule =
      """
        { "extractFromUVCI": [  { "var": "" },  3  ] }
    """
    data = """
      { "data": "URN:UVCI:01:NL:187/37512422923" }
    """
    XCTAssertEqual("37512422923", try applyRule(rule, to: data))
    data = """
      { "data": "01:NL:187/37512422923" }
    """
    XCTAssertEqual("37512422923", try applyRule(rule, to: data))
    data = """
      { "data": "URN:UVCI:01:AT:10807843F94AEE0EE5093FBC254BD813#B" }
    """
    XCTAssertEqual("B", try applyRule(rule, to: data))
    data = """
      { "data": "01:AT:10807843F94AEE0EE5093FBC254BD813#B" }
    """
    XCTAssertEqual("B", try applyRule(rule, to: data))
    data = """
      { "data": "foo/bar::baz#999lizards" }
    """
    XCTAssertEqual("baz", try applyRule(rule, to: data))
    data = """
      { "data": "a::c/#/f" }
    """
    XCTAssertEqual("", try applyRule(rule, to: data))

    rule =
      """
        { "extractFromUVCI": [  { "var": "" },  4  ] }
    """
    data = """
      { "data": "URN:UVCI:01:NL:187/37512422923" }
    """
    XCTAssertNil(try applyRule(rule, to: data))
    data = """
      { "data": "01:NL:187/37512422923" }
    """
    XCTAssertNil(try applyRule(rule, to: data))
    data = """
      { "data": "URN:UVCI:01:AT:10807843F94AEE0EE5093FBC254BD813#B" }
    """
    XCTAssertNil(try applyRule(rule, to: data))
    data = """
      { "data": "01:AT:10807843F94AEE0EE5093FBC254BD813#B" }
    """
    XCTAssertNil(try applyRule(rule, to: data))
    data = """
      { "data": "foo/bar::baz#999lizards" }
    """
    XCTAssertEqual("999lizards", try applyRule(rule, to: data))
    data = """
      { "data": "a::c/#/f" }
    """
    XCTAssertEqual("", try applyRule(rule, to: data))

    rule =
      """
        { "extractFromUVCI": [  { "var": "" },  5  ] }
    """
    data = """
      { "data": "foo/bar::baz#999lizards" }
    """
    XCTAssertNil(try applyRule(rule, to: data))
    data = """
      { "data": "a::c/#/f" }
    """
    XCTAssertEqual("f", try applyRule(rule, to: data))

  }
  
}
