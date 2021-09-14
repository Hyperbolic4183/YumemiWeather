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
        let fetcherMock = FetcherMock(result: .success(.init(weather: .sunny, minTemperature: "", maxTemperature: "")))
        let weatherViewController = WeatherViewController(model: fetcherMock, queueScheduler: .immediate, errorHandler: .fulfillXCTestExpectation)
        fetcherMock.delegate = weatherViewController
        let weatherView = weatherViewController.weatherView
        fetcherMock.fetch()
        let weatherImageView = weatherView.weatherImageView
        XCTAssertEqual(weatherImageView?.image,UIImage(named: "sunny"))
    }
    
    func test_天気予報がcloudyだったときに画面に曇り画像が表示される() {
        let fetcherMock = FetcherMock(result: .success(.init(weather: .cloudy, minTemperature: "", maxTemperature: "")))
        let weatherViewController = WeatherViewController(model: fetcherMock, queueScheduler: .immediate, errorHandler: .fulfillXCTestExpectation)
        fetcherMock.delegate = weatherViewController
        let weatherView = weatherViewController.weatherView
        fetcherMock.fetch()
        let weatherImageView = weatherView.weatherImageView
        XCTAssertEqual(weatherImageView?.image,UIImage(named: "cloudy"))
    }

    func test_天気予報がrainyだったときに画面に雨画像が表示される() {
        let fetcherMock = FetcherMock(result: .success(.init(weather: .rainy, minTemperature: "", maxTemperature: "")))
        let weatherViewController = WeatherViewController(model: fetcherMock, queueScheduler: .immediate, errorHandler: .fulfillXCTestExpectation)
        fetcherMock.delegate = weatherViewController
        let weatherView = weatherViewController.weatherView
        fetcherMock.fetch()
        let weatherImageView = weatherView.weatherImageView
        XCTAssertEqual(weatherImageView?.image,UIImage(named: "rainy"))
    }

    func test_最高気温がUILabelに反映される() {
        let testMaxTemperature = "40"
        let fetcherMock = FetcherMock(result: .success(.init(weather: .sunny, minTemperature: "", maxTemperature: testMaxTemperature)))
        let weatherViewController = WeatherViewController(model: fetcherMock, queueScheduler: .immediate, errorHandler: .fulfillXCTestExpectation)
        let weatherView = weatherViewController.weatherView
        fetcherMock.delegate = weatherViewController
        fetcherMock.fetch()
        let maxTemperature = weatherView.maxTemperatureLabel
        XCTAssertEqual(testMaxTemperature, maxTemperature?.text)
    }

    func test_最低気温がUILabelに反映される() {
        let testMinTemperature = "40"
        let fetcherMock = FetcherMock(result: .success(.init(weather: .sunny, minTemperature: testMinTemperature, maxTemperature: "")))
        let weatherViewController = WeatherViewController(model: fetcherMock, queueScheduler: .immediate, errorHandler: .fulfillXCTestExpectation)
        fetcherMock.delegate = weatherViewController
        fetcherMock.fetch()
        let minTemperature = weatherViewController.weatherView.minTemperatureLabel
        XCTAssertEqual(testMinTemperature, minTemperature?.text)
    }
    
    func test_天気予報がエラーだった時に処理が行われる() {
        let expectation = Expectation.fetchFailed
        let fetcherMock = FetcherMock(result: .failure(.invalidParameterError))
        let weatherViewController = WeatherViewController(model: fetcherMock, queueScheduler: .immediate, errorHandler: .fulfillXCTestExpectation)
        fetcherMock.delegate = weatherViewController
        fetcherMock.fetch()
        wait(for: [expectation], timeout: 2)
    }
    
}

private extension WeatherView {
    
    var stackViewForImageViewAndLabels: UIStackView? {
        return self
            .subviews
            .filter{$0.accessibilityIdentifier == AccessibilityIdentifier.stackViewForImageViewAndLabels}
            .compactMap{$0 as? UIStackView}
            .first
    }
    
    var stackViewForLabels: UIStackView? {
        return self
            .stackViewForImageViewAndLabels?
            .subviews
            .filter{$0.accessibilityIdentifier! == AccessibilityIdentifier.stackViewForLabels}
            .compactMap{$0 as? UIStackView}
            .first
    }
    
    var weatherImageView: UIImageView? {
        return self
            .stackViewForImageViewAndLabels?
            .subviews
            .filter{$0.accessibilityIdentifier == AccessibilityIdentifier.weatherImageView}
            .compactMap{$0 as? UIImageView}
            .first
    }
    
    var minTemperatureLabel: UILabel? {
        return self
            .stackViewForLabels?
            .subviews
            .filter{ $0.accessibilityIdentifier == AccessibilityIdentifier.minTemperatureLabel }
            .compactMap{$0 as? UILabel}
            .first
    }
    
    var maxTemperatureLabel: UILabel? {
        return self
            .stackViewForLabels?
            .subviews
            .filter{ $0.accessibilityIdentifier == AccessibilityIdentifier.maxTemperatureLabel }
            .compactMap{$0 as? UILabel}
            .first
    }
}


