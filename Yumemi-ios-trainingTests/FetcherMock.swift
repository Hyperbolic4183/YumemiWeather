//
//  FetcherMock.swift
//  Yumemi-ios-trainingTests
//
//  Created by 大塚 周 on 2021/09/06.
//

@testable import Yumemi_ios_training
class FetcherMock: Fetchable {
    
    var delegate: FetchableDelegate?
    
    var weatherInformation: WeatherInformation!
    var error: WeatherAppError!
    let isFetchSucceed: Bool
    //fetchが成功したモックを作成するときに使うイニシャライザ
    init(weatherInformation: WeatherInformation) {
        self.weatherInformation = weatherInformation
        isFetchSucceed = true
    }
    
    //fetchが失敗したモック作成するときに使うイニシャライザ
    init(error: WeatherAppError) {
        self.error = error
        isFetchSucceed = false
    }
    
    func fetch() {
        if isFetchSucceed {
            delegate?.fetch(self, didFetch: weatherInformation)
        } else {
            delegate?.fetch(self, didFailWithError: error)
        }
    }
    
}
