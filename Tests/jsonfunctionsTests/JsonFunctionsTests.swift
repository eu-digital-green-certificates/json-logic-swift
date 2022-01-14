import XCTest
import JSON
@testable import jsonfunctions

final class JsonFunctionsTests: XCTestCase {

    func testJsonFunctions() {
        XCTAssertEqual(testCases.count, 767)

        var passed = 0
        var failed = 0
        var throwsUnexpectedly = 0

        for (index, testCase) in testCases.enumerated() {
            let jsonFunctions = JsonFunctions()

//            if index != 426 {
//                continue
//            }

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
