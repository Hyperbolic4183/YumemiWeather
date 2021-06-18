//
//  Yumemi_ios_trainingTests.swift
//  Yumemi-ios-trainingTests
//
//  Created by 大塚 周 on 2021/06/18.
//

import XCTest
@testable import Yumemi_ios_training

class Yumemi_ios_trainingTests: XCTestCase {
    
    func test_天気予報がsunnyだったときに画面に晴れ画像が表示される() {
        
        struct Sunny: Testable {
            func fetchYumemiWeather() -> Result<WeatherInformation, WeatherAppError> {
                .success(WeatherInformation(weather: .sunny, minTemperature: "0", maxTemperature: "0"))
            }
        }
        let viewController = WeatherViewController(model: Sunny())
        let view = viewController.weatherView
        let imageView = view.weatherImageView
        let reloadButton = view.reloadButton
        
        viewController.viewDidLoad()
        reloadButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(imageView.image!, UIImage(named: "sunny")!)
    }
    func test_天気予報がcloudyだったときに画面に晴れ画像が表示される() {
        
        struct Cloudy: Testable {
            func fetchYumemiWeather() -> Result<WeatherInformation, WeatherAppError> {
                .success(WeatherInformation(weather: .cloudy, minTemperature: "0", maxTemperature: "0"))
            }
        }
        let viewController = WeatherViewController(model: Cloudy())
        let view = viewController.weatherView
        let imageView = view.weatherImageView
        let reloadButton = view.reloadButton
        
        viewController.viewDidLoad()
        reloadButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(imageView.image!, UIImage(named: "cloudy")!)
    }
    func test_天気予報がrainyだったときに画面に晴れ画像が表示される() {
        
        struct Rainy: Testable {
            func fetchYumemiWeather() -> Result<WeatherInformation, WeatherAppError> {
                .success(WeatherInformation(weather: .rainy, minTemperature: "0", maxTemperature: "0"))
            }
        }
        let viewController = WeatherViewController(model: Rainy())
        let view = viewController.weatherView
        let imageView = view.weatherImageView
        let reloadButton = view.reloadButton
        
        viewController.viewDidLoad()
        reloadButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(imageView.image!, UIImage(named: "rainy")!)
    }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}