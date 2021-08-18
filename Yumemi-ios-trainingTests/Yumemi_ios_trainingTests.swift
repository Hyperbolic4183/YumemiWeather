//
//  Yumemi_ios_trainingTests.swift
//  Yumemi-ios-trainingTests
//
//  Created by 大塚 周 on 2021/06/18.
//

import XCTest
@testable import Yumemi_ios_training

class TestWeatherModel: Fetchable {
    
    var delegate: FetchableDelegate?
    let weatherInformation: WeatherInformation
    
    init(weatherInformation: WeatherInformation) {
        self.weatherInformation = weatherInformation
    }
    
    func fetch(completion: (() -> Void)?) {
        DispatchQueue.main.async {
            sleep(2)
            self.delegate?.fetch(self, didFetch: self.weatherInformation)
            if let completion = completion {
                completion()
            }
        }
    }
}

class Yumemi_ios_trainingTests: XCTestCase {
    func test_天気予報がsunnyだったときに画面に晴れ画像が表示される() {
        let testView = TestWeatherView()
        let sunnyWeatherInformation = WeatherInformation(weather: .sunny, minTemperature: "0", maxTemperature: "0")
        let model = TestWeatherModel(weatherInformation: sunnyWeatherInformation)
        let viewController = WeatherViewController(model: model, view: testView)
        let weatherImageView = testView.testWeatherImageView
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        
        viewController.viewDidLoad()
        model.fetch() {
            DispatchQueue.main.async {
                XCTAssertEqual(weatherImageView.image, UIImage(named: "sunny"))
                expectation?.fulfill()
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    func test_天気予報がcloudyだったときに画面に曇り画像が表示される() {
        let testView = TestWeatherView()
        let cloudyWeatherInformation = WeatherInformation(weather: .cloudy, minTemperature: "0", maxTemperature: "0")
        let model = TestWeatherModel(weatherInformation: cloudyWeatherInformation)
        let viewController = WeatherViewController(model: model, view: testView)
        let weatherImageView = testView.testWeatherImageView
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        
        viewController.viewDidLoad()
        model.fetch() {
            DispatchQueue.main.async {
                XCTAssertEqual(weatherImageView.image, UIImage(named: "cloudy"))
                expectation?.fulfill()
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    func test_天気予報がrainyだったときに画面に雨画像が表示される() {
        let testView = TestWeatherView()
        let rainyWeatherInformation = WeatherInformation(weather: .rainy, minTemperature: "0", maxTemperature: "0")
        let model = TestWeatherModel(weatherInformation: rainyWeatherInformation)
        let viewController = WeatherViewController(model: model, view: testView)
        let weatherImageView = testView.testWeatherImageView
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        
        viewController.viewDidLoad()
        model.fetch() {
            DispatchQueue.main.async {
                XCTAssertEqual(weatherImageView.image, UIImage(named: "rainy"))
                expectation?.fulfill()
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    func test_最高気温がUILabelに反映される() {
        let testMaxTemperature = "40"
        let testView = TestWeatherView()
        let maxTemperatureWeatherInformation = WeatherInformation(weather: .sunny, minTemperature: "0", maxTemperature: testMaxTemperature)
        let maxTemperatureModel = TestWeatherModel(weatherInformation: maxTemperatureWeatherInformation)
        let viewController = WeatherViewController(model: maxTemperatureModel, view: testView)
        let maxTemperature = testView.testMaxTemperatureLabel
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")

        viewController.viewDidLoad()
        maxTemperatureModel.fetch() {
            DispatchQueue.main.async {
                XCTAssertEqual(maxTemperature.text, testMaxTemperature)
                expectation?.fulfill()
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    func test_最低気温がUILabelに反映される() {
        let testMinTemperature = "40"
        let testView = TestWeatherView()
        let minTemperatureWeatherInformation = WeatherInformation(weather: .sunny, minTemperature: testMinTemperature, maxTemperature: "0")
        let minTemperatureModel = TestWeatherModel(weatherInformation: minTemperatureWeatherInformation)
        let viewController = WeatherViewController(model: minTemperatureModel, view: testView)
        let minTemperature = testView.testMinTemperatureLabel
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")

        viewController.viewDidLoad()
        minTemperatureModel.fetch() {
            DispatchQueue.main.async {
                XCTAssertEqual(minTemperature.text, testMinTemperature)
                expectation?.fulfill()
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
}
