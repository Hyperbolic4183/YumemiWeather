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
        let weatherImage = self.getImage(from: weatherView)
        XCTAssertEqual(weatherImage,UIImage(named: "sunny"))
    }
    
    func test_天気予報がcloudyだったときに画面に曇り画像が表示される() {
        let fetcherMock = FetcherMock(result: .success(.init(weather: .cloudy, minTemperature: "", maxTemperature: "")))
        let weatherViewController = WeatherViewController(model: fetcherMock, queueScheduler: .immediate, errorHandler: .fulfillXCTestExpectation)
        fetcherMock.delegate = weatherViewController
        let weatherView = weatherViewController.weatherView
        fetcherMock.fetch()
        let weatherImage = self.getImage(from: weatherView)
        XCTAssertEqual(weatherImage,UIImage(named: "cloudy"))
    }

    func test_天気予報がrainyだったときに画面に雨画像が表示される() {
        let fetcherMock = FetcherMock(result: .success(.init(weather: .rainy, minTemperature: "", maxTemperature: "")))
        let weatherViewController = WeatherViewController(model: fetcherMock, queueScheduler: .immediate, errorHandler: .fulfillXCTestExpectation)
        fetcherMock.delegate = weatherViewController
        let weatherView = weatherViewController.weatherView
        fetcherMock.fetch()
        let weatherImage = self.getImage(from: weatherView)
        XCTAssertEqual(weatherImage,UIImage(named: "rainy"))
    }

    func test_最高気温がUILabelに反映される() {
        let testMaxTemperature = "40"
        let fetcherMock = FetcherMock(result: .success(.init(weather: .sunny, minTemperature: "", maxTemperature: testMaxTemperature)))
        let weatherViewController = WeatherViewController(model: fetcherMock, queueScheduler: .immediate, errorHandler: .fulfillXCTestExpectation)
        fetcherMock.delegate = weatherViewController
        fetcherMock.fetch()
        let maxTemperature = self.getMaxTemperatureLabel(from: weatherViewController.weatherView)

        XCTAssertEqual(testMaxTemperature, maxTemperature.text)
    }

    func test_最低気温がUILabelに反映される() {
        let testMinTemperature = "40"
        let fetcherMock = FetcherMock(result: .success(.init(weather: .sunny, minTemperature: testMinTemperature, maxTemperature: "")))
        let weatherViewController = WeatherViewController(model: fetcherMock, queueScheduler: .immediate, errorHandler: .fulfillXCTestExpectation)
        fetcherMock.delegate = weatherViewController
        fetcherMock.fetch()
        let minTemperature = self.getMaxTemperatureLabel(from: weatherViewController.weatherView)

        XCTAssertEqual(testMinTemperature, minTemperature.text)
    }
    func test_天気予報がエラーだった時に処理が行われる() {
        let expectation = Expectation.fetchFailed
        let fetcherMock = FetcherMock(result: .failure(.invalidParameterError))
        let weatherViewController = WeatherViewController(model: fetcherMock, queueScheduler: .immediate, errorHandler: .fulfillXCTestExpectation)
        fetcherMock.delegate = weatherViewController
        fetcherMock.fetch()
        wait(for: [expectation], timeout: 2)
    }
    
    private func getStackView(from view: UIView) -> UIStackView {
        view.subviews.first(where: { $0 is UIStackView})! as! UIStackView
    }
    
    private func getImage(from view: UIView) -> UIImage {
        //WeatherView含まれるstackViewForImageViewAndLabelsを取得
        let stackViewForImageViewAndLabels = getStackView(from: view)
        
        let weatherImageView = stackViewForImageViewAndLabels.subviews.first(where: { $0 is UIImageView })! as! UIImageView
        return weatherImageView.image!
    }
    
    private func getMaxTemperatureLabel(from view: UIView) -> UILabel {
        //WeatherView含まれる2つのUIStackViewのうち、2番目に追加したstackViewForLabelsを取得
        let stackViewForImageViewAndLabels = getStackView(from: view)
        //stackViewForImageViewAndLabelsに含まれるstackViewForLabelsを取得
        let stackViewForLabels = getStackView(from: stackViewForImageViewAndLabels)
        //stackViewForLabelsに2番目に追加したUILabelを取得
        let maxTemperatureLabel = stackViewForLabels.subviews[1] as! UILabel
        return maxTemperatureLabel
    }
    
    private func getMinTemperatureLabel(from view: UIView) -> UILabel {
        //WeatherView含まれるstackViewForImageViewAndLabelsを取得
        let stackViewForImageViewAndLabels = getStackView(from: view)
        //stackViewForImageViewAndLabelsに含まれるstackViewForLabelsを取得
        let stackViewForLabels = getStackView(from: stackViewForImageViewAndLabels)
        //stackViewForLabelsに初めに追加したUILabelを取得
        let minTemperatureLabel = stackViewForLabels.subviews[0] as! UILabel
        return minTemperatureLabel
    }
    
}

