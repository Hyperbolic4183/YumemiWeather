//
//  Yumemi_ios_trainingTests.swift
//  Yumemi-ios-trainingTests
//
//  Created by 大塚 周 on 2021/06/18.
//

import XCTest
@testable import Yumemi_ios_training

class Yumemi_ios_trainingTests: XCTestCase {
    
    var successFetcherMock: SuccessFetcherMock!
    var failedFetcherMock: FailedFetcherMock!
    let weatherViewControllerMock = WeatherViewControllerMock()
    
    func test_天気予報がsunnyだったときに画面に晴れ画像が表示される() {
        successFetcherMock = SuccessFetcherMock(weatherInformation: WeatherInformation(weather: .sunny, minTemperature: "", maxTemperature: ""))
        successFetcherMock.delegate = weatherViewControllerMock
        successFetcherMock.fetch()
        let weatherImageView = getImage(from: weatherViewControllerMock.view)
        XCTAssertEqual(weatherImageView, UIImage(named: "sunny"))
    }

    func test_天気予報がcloudyだったときに画面に曇り画像が表示される() {
        successFetcherMock = SuccessFetcherMock(weatherInformation: WeatherInformation(weather: .cloudy, minTemperature: "", maxTemperature: ""))
        successFetcherMock.delegate = weatherViewControllerMock
        successFetcherMock.fetch()
        let weatherImageView = getImage(from: weatherViewControllerMock.view)
        XCTAssertEqual(weatherImageView, UIImage(named: "cloudy"))
    }

    func test_天気予報がrainyだったときに画面に雨画像が表示される() {
        successFetcherMock = SuccessFetcherMock(weatherInformation: WeatherInformation(weather: .rainy, minTemperature: "", maxTemperature: ""))
        successFetcherMock.delegate = weatherViewControllerMock
        successFetcherMock.fetch()
        let weatherImageView = getImage(from: weatherViewControllerMock.view)
        XCTAssertEqual(weatherImageView, UIImage(named: "rainy"))
    }

    func test_最高気温がUILabelに反映される() {
        let testMaxTemperature = "40"
        successFetcherMock = SuccessFetcherMock(weatherInformation: WeatherInformation(weather: .sunny, minTemperature: "", maxTemperature: testMaxTemperature))
        successFetcherMock.delegate = weatherViewControllerMock
        successFetcherMock.fetch()
        let maxTemperature = self.getMaxTemperatureLabel(from: weatherViewControllerMock.view)

        XCTAssertEqual(testMaxTemperature, maxTemperature.text)
    }

    func test_最低気温がUILabelに反映される() {
        let testMinTemperature = "-40"
        successFetcherMock = SuccessFetcherMock(weatherInformation: WeatherInformation(weather: .sunny, minTemperature: testMinTemperature, maxTemperature: ""))
        successFetcherMock.delegate = weatherViewControllerMock
        successFetcherMock.fetch()
        let minTemperature = self.getMinTemperatureLabel(from: weatherViewControllerMock.view)
        XCTAssertEqual(testMinTemperature, minTemperature.text)
    }
    
    func test_Fetcherでエラーが起きた時にWeatherViewControllerのdelegateが動く() {
        failedFetcherMock = FailedFetcherMock(error: .invalidParameterError)
        failedFetcherMock.delegate = weatherViewControllerMock
        failedFetcherMock.fetch()
        wait(for: [.expectationOfError], timeout: 2)
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
    
    private func getReloadButton(from view: UIView) -> UIButton {
        view.subviews.filter({ type(of: $0) == UIButton.self }).map({ $0 as! UIButton })[1]
    }
    
}

extension XCTestExpectation {
    static let expectationOfError = XCTestExpectation(description: "error")
}
