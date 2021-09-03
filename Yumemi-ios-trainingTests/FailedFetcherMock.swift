//
//  FailedFetcherMock.swift
//  Yumemi-ios-trainingTests
//
//  Created by 大塚 周 on 2021/09/03.
//

import Foundation
@testable import Yumemi_ios_training

class FailedFetcherMock: Fetchable {
    
    var delegate: FetchableDelegate?
    let error: WeatherAppError
    
    init(error: WeatherAppError) {
        self.error = error
    }
    
    func fetch() {
        delegate?.fetch(self, didFailWithError: error)
    }
}
