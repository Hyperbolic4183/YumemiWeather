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
        let sunnyWeatherInformation = WeatherInformation(weather: .sunny, minTemperature: "0", maxTemperature: "0")
        let viewController = WeatherViewController(model: TestWeatherModel(weatherInformation: sunnyWeatherInformation))
        let weatherImageView = viewController.weatherView.weatherImageView
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        
        viewController.viewDidLoad()
        viewController.weatherModel.fetch() {
            DispatchQueue.main.async {
                XCTAssertEqual(weatherImageView.image, UIImage(named: "sunny"))
                expectation?.fulfill()
            }
            
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    func test_天気予報がcloudyだったときに画面に曇り画像が表示される() {
        let cloudyWeatherInformation = WeatherInformation(weather: .cloudy, minTemperature: "0", maxTemperature: "0")
        let viewController = WeatherViewController(model: TestWeatherModel(weatherInformation: cloudyWeatherInformation))
        let weatherImageView = viewController.weatherView.weatherImageView
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        
        viewController.viewDidLoad()
        viewController.weatherModel.fetch() {
            DispatchQueue.main.async {
                XCTAssertEqual(weatherImageView.image, UIImage(named: "cloudy"))
                expectation?.fulfill()
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    func test_天気予報がrainyだったときに画面に雨画像が表示される() {
        let rainyWeatherInformation = WeatherInformation(weather: .rainy, minTemperature: "0", maxTemperature: "0")
        let viewController = WeatherViewController(model: TestWeatherModel(weatherInformation: rainyWeatherInformation))
        let weatherImageView = viewController.weatherView.weatherImageView
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        
        viewController.viewDidLoad()
        viewController.weatherModel.fetch() {
            DispatchQueue.main.async {
                XCTAssertEqual(weatherImageView.image, UIImage(named: "rainy"))
                expectation?.fulfill()
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    func test_最高気温がUILabelに反映される() {
        let testingMaxTemperature = "40"
        let maxTemperatureWeatherInformation = WeatherInformation(weather: .sunny, minTemperature: "0", maxTemperature: testingMaxTemperature)
        let maxTemperatureModel = TestWeatherModel(weatherInformation: maxTemperatureWeatherInformation)
        let viewController = WeatherViewController(model: maxTemperatureModel)
        let view = viewController.weatherView
        let maxTemperature = view.maxTemperatureLabel
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")
        
        viewController.viewDidLoad()
        viewController.weatherModel.fetch() {
            DispatchQueue.main.async {
                XCTAssertEqual(maxTemperature.text, testingMaxTemperature)
                expectation?.fulfill()
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    func test_最低気温がUILabelに反映される() {
        let testingMinTemperature = "-40"
        let minTemperatureWeatherInformation = WeatherInformation(weather: .sunny, minTemperature: testingMinTemperature, maxTemperature: "0")
        let minTemperatureModel = TestWeatherModel(weatherInformation: minTemperatureWeatherInformation)
        let viewController = WeatherViewController(model: minTemperatureModel)
        let view = viewController.weatherView
        let expectation: XCTestExpectation? = self.expectation(description: "fetch")

        viewController.viewDidLoad()
        viewController.weatherModel.fetch() {
            DispatchQueue.main.async {
                XCTAssertEqual(testingMinTemperature,view.minTemperatureLabel.text)
                expectation?.fulfill()
            }
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
}
