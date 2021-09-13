//
//  FetcherMock.swift
//  Yumemi-ios-trainingTests
//
//  Created by 大塚 周 on 2021/09/06.
//

@testable import Yumemi_ios_training
class FetcherMock: Fetchable {
    
    var delegate: FetchableDelegate?
    
    let result: Result<WeatherInformation, WeatherAppError>
    init(result: Result<WeatherInformation, WeatherAppError>) {
        self.result = result
    }
    
    func fetch() {
        switch result {
        case .success(let weatherInformation):
            delegate?.fetch(self, didFetch: weatherInformation)
        case .failure(let error):
            delegate?.fetch(self, didFailWithError: error)
        }
    }
    
}
