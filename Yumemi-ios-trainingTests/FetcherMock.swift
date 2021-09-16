//
//  FetcherMock.swift
//  Yumemi-ios-trainingTests
//
//  Created by 大塚 周 on 2021/09/06.
//

@testable import Yumemi_ios_training
class FetcherMock: Fetchable {
    
    let result: Result<WeatherInformation, WeatherAppError>
    init(result: Result<WeatherInformation, WeatherAppError>) {
        self.result = result
    }
    
    func fetch(completion: @escaping (Result<WeatherInformation, WeatherAppError>) -> Void) {
        completion(result)
    }
    
}
