import XCTest
import JSON
@testable import jsonlogic

final class JsonFunctionsTests: XCTestCase {

    func testJsonFunctions() {
        XCTAssertEqual(testCases.count, 751)

        var missingImplementation = 0
        var passed = 0
        var failed = 0

        for (index, testCase) in testCases.enumerated() {
            if let functions = testCase.functions {
                // TODO: register functions
            }

            do {
                let result: Any
                if let evaluateFunction = testCase.evaluateFunction {
                    // TODO: Evaluate function
                    print("*** ❓ test case \(index) misses implementation - \(testCase.title)")
                    missingImplementation += 1
                } else if let logic = testCase.logic, let data = testCase.data {
                    result = try applyRule(JSON(logic.value), to: JSON(data.value))

                    if index == 732 {
                        print("")
                    }

                    if let exp = testCase.exp {
                        XCTAssertEqual(JSON(result), JSON(exp.value))

                        if JSON(result) == JSON(exp.value) {
                            print("*** ✅ test case \(index) equals expected value - \(testCase.title)")
                            passed += 1
                        } else {
                            print("*** ❌ test case \(index) \"\(result)\" does not equal expected value \"\(exp)\" - \(testCase.title)")
                            failed += 1
                        }
                    }
                }
            } catch {
                if testCase.throws == nil || testCase.throws == false {
                    print("*** ‼️ test case \(index) throws incorrectly - \(testCase.title)")
                    XCTFail("test case \"\(testCase.title)\" throws unexpectedly (\(error)")
                    failed += 1
                } else {
                    print("*** ✅ test case \(index) throws correctly - \(testCase.title)")
                    passed += 1
                }
            }
        }

        print("*** missing implementation: \(missingImplementation)/\(testCases.count)")
        print("*** passed: \(passed)/\(testCases.count)")
        print("*** failed: \(failed)/\(testCases.count)")
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
