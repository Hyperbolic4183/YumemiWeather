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
        let weatherView = WeatherView()
        let fetcherMock = FetcherMock(result: .success(.init(weather: .sunny, minTemperature: "", maxTemperature: "")))
        let weatherViewController = WeatherViewController(view: weatherView,
                                      model: fetcherMock,
                                      errorHandler: .fulfillXCTestExpectation,
                                      queueScheduler: .immediate)
        
        weatherViewController.reload()
        let weatherImageView = weatherView.weatherImageView
        XCTAssertEqual(weatherImageView?.image,UIImage(named: "sunny"))
    }
    
    func test_天気予報がcloudyだったときに画面に曇り画像が表示される() {
        let weatherView = WeatherView()
        let fetcherMock = FetcherMock(result: .success(.init(weather: .cloudy, minTemperature: "", maxTemperature: "")))
        let weatherViewController = WeatherViewController(view: weatherView,
                                      model: fetcherMock,
                                      errorHandler: .fulfillXCTestExpectation,
                                      queueScheduler: .immediate)
        weatherViewController.reload()
        let weatherImageView = weatherView.weatherImageView
        XCTAssertEqual(weatherImageView?.image,UIImage(named: "cloudy"))
    }

    func test_天気予報がrainyだったときに画面に雨画像が表示される() {
        let weatherView = WeatherView()
        let fetcherMock = FetcherMock(result: .success(.init(weather: .rainy, minTemperature: "", maxTemperature: "")))
        let weatherViewController = WeatherViewController(view: weatherView,
                                      model: fetcherMock,
                                      errorHandler: .fulfillXCTestExpectation,
                                      queueScheduler: .immediate)
        weatherViewController.reload()
        let weatherImageView = weatherView.weatherImageView
        XCTAssertEqual(weatherImageView?.image,UIImage(named: "rainy"))
    }

    func test_最高気温がUILabelに反映される() {
        let weatherView = WeatherView()
        let testMaxTemperature = "40"
        let fetcherMock = FetcherMock(result: .success(.init(weather: .sunny, minTemperature: "", maxTemperature: testMaxTemperature)))
        let weatherViewController = WeatherViewController(view: weatherView,
                                      model: fetcherMock,
                                      errorHandler: .fulfillXCTestExpectation,
                                      queueScheduler: .immediate)
        weatherViewController.reload()
        let maxTemperatureLabel = weatherView.maxTemperatureLabel
        XCTAssertEqual(maxTemperatureLabel?.text,testMaxTemperature)
    }

    func test_最低気温がUILabelに反映される() {
        let weatherView = WeatherView()
        let testMinTemperature = "40"
        let fetcherMock = FetcherMock(result: .success(.init(weather: .sunny, minTemperature: testMinTemperature, maxTemperature: "")))
        let weatherViewController = WeatherViewController(view: weatherView,
                                      model: fetcherMock,
                                      errorHandler: .fulfillXCTestExpectation,
                                      queueScheduler: .immediate)
        weatherViewController.reload()
        let minTemperatureLabel = weatherView.minTemperatureLabel
        XCTAssertEqual(minTemperatureLabel?.text,testMinTemperature)
    }

    func test_天気予報がエラーだった時に処理が行われる() {
        let expectation = Expectation.fetchFailed
        let fetcherMock = FetcherMock(result: .failure(.invalidParameterError))
        let weatherViewController = WeatherViewController(model: fetcherMock,
                                                          errorHandler: .fulfillXCTestExpectation,
                                                          queueScheduler: .immediate)
        weatherViewController.reload()
        wait(for: [expectation], timeout: 2)
    }
    
}

private extension WeatherView {
    
    var stackViewForImageViewAndLabels: UIStackView? {
        return self
            .subviews
            .first(where: { $0.accessibilityIdentifier == AccessibilityIdentifier.stackViewForImageViewAndLabels }) as? UIStackView
    }
    
    var stackViewForLabels: UIStackView? {
        return self
            .stackViewForImageViewAndLabels?
            .subviews
            .first(where: { $0.accessibilityIdentifier! == AccessibilityIdentifier.stackViewForLabels }) as? UIStackView
    }
    
    var weatherImageView: UIImageView? {
        return self
            .stackViewForImageViewAndLabels?
            .subviews
            .first(where: { $0.accessibilityIdentifier == AccessibilityIdentifier.weatherImageView }) as? UIImageView
    }
    
    var minTemperatureLabel: UILabel? {
        return self
            .stackViewForLabels?
            .subviews
            .first(where: { $0.accessibilityIdentifier == AccessibilityIdentifier.minTemperatureLabel }) as? UILabel
    }
    
    var maxTemperatureLabel: UILabel? {
        return self
            .stackViewForLabels?
            .subviews
            .first(where: { $0.accessibilityIdentifier == AccessibilityIdentifier.maxTemperatureLabel }) as? UILabel
    }
}


