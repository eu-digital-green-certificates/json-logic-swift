import XCTest
import JSON
@testable import jsonfunctions

final class JsonFunctionsTests: XCTestCase {

    func testJsonFunctions() {
        XCTAssertEqual(testCases.count, 769)

        var passed = 0
        var failed = 0
        var throwsUnexpectedly = 0

        for (index, testCase) in testCases.enumerated() {
            let jsonFunctions = JsonFunctions()

            if let functions = testCase.functions {
                functions.forEach {
                    jsonFunctions.registerFunction(name: $0.name, definition: $0.definition)
                }
            }

            do {
                let result: Any
                if let evaluateFunction = testCase.evaluateFunction {
                    result = try jsonFunctions.evaluateFunction(name: evaluateFunction.name, parameters: evaluateFunction.parameters)

                    let exp = JSON(testCase.exp?.value as Any)
                    XCTAssert(JSON(result) === exp)

                    if JSON(result) === exp {
                        print("*** ✅ test case \(index) equals expected value - \(testCase.title)")
                        passed += 1
                    } else {
                        print("*** ❌ test case \(index) \"\(result)\" does not equal expected value \"\(String(describing: testCase.exp?.value))\" - \(testCase.title)")
                        failed += 1
                    }
                } else {
                    result = try jsonFunctions.applyRule(JSON(testCase.logic?.value as Any), to: JSON(testCase.data?.value as Any))

                    let exp = JSON(testCase.exp?.value as Any)
                    XCTAssert(JSON(result) === exp)

                    if JSON(result) === exp {
                        print("*** ✅ test case \(index) equals expected value - \(testCase.title)")
                        passed += 1
                    } else {
                        print("*** ❌ test case \(index) \"\(result)\" does not equal expected value \"\(String(describing: testCase.exp?.value))\" - \(testCase.title)")
                        failed += 1
                    }
                }
            } catch {
                if testCase.throws == nil || testCase.throws == false {
                    print("*** ‼️ test case \(index) throws unexpectedly - \(testCase.title)")
                    XCTFail("test case \"\(testCase.title)\" throws unexpectedly (\(error))")
                    throwsUnexpectedly += 1
                } else {
                    print("*** ✅ test case \(index) throws expectedly - \(testCase.title)")
                    passed += 1
                }
            }
        }

        print("*** passed: \(passed)/\(testCases.count)")
        print("*** failed: \(failed)/\(testCases.count)")
        print("*** throwsUnexpectedly: \(throwsUnexpectedly)/\(testCases.count)")
    }

    func testDecodableReturnValue() throws {
        struct TestStruct: Decodable, Equatable {
            struct SubTestStruct: Decodable, Equatable {
                let f: String
                let g: Int
                let h: Double
                let i: [String]
                let j: [String: Int]
            }

            let a: String
            let b: Int
            let c: Double
            let d: [String]
            let e: [String: Int]
            let subStruct: SubTestStruct
        }

        let data =
                """
                {
                    "struct": {
                        "a": "valueA",
                        "b": 5,
                        "c": 2.4,
                        "d": ["valueD1", "valueD2", "valueD3"],
                        "e": {"valueE1": 0, "valueE2": 1, "valueE3": -17},
                        "subStruct": {
                            "f": "valueF",
                            "g": -6947,
                            "h": -453451.7534,
                            "i": ["valueI1", "valueI2", "valueI3"],
                            "j": {"valueJ1": 0, "valueJ2": 1, "valueJ3": -17}
                        }
                    }
                }
                """

        let logic = "{ \"var\": \"struct\" }"

        let result: TestStruct = try JsonFunctions().applyRule(logic, to: data)

        let expectedResult = TestStruct(
            a: "valueA",
            b: 5,
            c: 2.4,
            d: ["valueD1", "valueD2", "valueD3"],
            e: ["valueE1": 0, "valueE2": 1, "valueE3": -17],
            subStruct: TestStruct.SubTestStruct(
                f: "valueF",
                g: -6947,
                h: -453451.7534,
                i: ["valueI1", "valueI2", "valueI3"],
                j: ["valueJ1": 0, "valueJ2": 1, "valueJ3": -17]
            )
        )

        XCTAssertEqual(result, expectedResult)
    }

    // MARK: - Private

    private lazy var testCases: [JsonFunctionsTestCase] = {
        guard let urlJsonFile = Bundle.module.url(forResource: "jfn-common-test-cases", withExtension: "json"),
              let data = try? Data(contentsOf: urlJsonFile) else {
            fatalError("Failed init json file for tests - stop here")
        }

        do {
            return try JSONDecoder().decode(JsonFunctionsTestCases.self, from: data).testCases
        } catch let DecodingError.keyNotFound(jsonKey, context) {
            fatalError("missing key: \(jsonKey)\nDebug Description: \(context.debugDescription)")
        } catch let DecodingError.valueNotFound(type, context) {
            fatalError("Type not found \(type)\nDebug Description: \(context.debugDescription)")
        } catch let DecodingError.typeMismatch(type, context) {
            fatalError("Type mismatch found \(type)\nDebug Description: \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            fatalError("Debug Description: \(context.debugDescription)")
        } catch {
            fatalError("Failed to parse JSON answer")
        }
    }()

}
