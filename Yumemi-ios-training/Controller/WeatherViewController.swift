//
//  ViewController.swift
//  Yumemi-ios-training
//
//  Created by 大塚 周 on 2021/04/30.
//

import UIKit


class WeatherViewController: UIViewController {
    let weatherView = WeatherView()
    var weatherModel: Fetchable
    
    init(model: Fetchable) {
        self.weatherModel = model
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    @available(*, unavailable, message: "init(coder:) has not been implemented")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherView.reloadButton.addTarget(self, action: #selector(reload(_:)), for: .touchUpInside)
        weatherView.closeButton.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
    }
    
    func updateView(_ result: Result<WeatherInformation, WeatherAppError>) {
        switch result {
        case .success(let information):
            let weatherViewState = WeatherViewState(information: information)
            weatherView.changeDisplay(weatherViewState)
        case .failure(let error):
            var message = ""
            switch error {
            case .invalidParameterError:
                message = "不適切な値が設定されました"
            case .unknownError:
                message = "予期せぬエラーが発生しました"
            }
            presentAlertController(message)
        }
    }
    
    func showIndicator(_ fetch:@escaping @autoclosure () -> Result<WeatherInformation, WeatherAppError>, completion: @escaping (_ result: Result<WeatherInformation, WeatherAppError>) -> Void) {
        let globalQueue = DispatchQueue.global(qos: .userInitiated)
        let mainQueue = DispatchQueue.main
        weatherView.indicator.startAnimating()
        globalQueue.async {
            let fetch = fetch()
            mainQueue.async {
                completion(fetch)
                self.weatherView.indicator.stopAnimating()
            }
        }
    }
    
    @objc func reload(_ sender: UIButton) {
        showIndicator(self.weatherModel.fetchYumemiWeather()) { result in
            self.updateView(result)
        }
    }
    
    @objc func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentAlertController(_ message: String) {
        let errorAlert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        let errorAction = UIAlertAction(title: "OK", style: .default)
        errorAlert.addAction(errorAction)
        present(errorAlert, animated: true, completion: nil)
    }
}

