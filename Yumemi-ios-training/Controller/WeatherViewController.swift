//
//  ViewController.swift
//  Yumemi-ios-training
//
//  Created by 大塚 周 on 2021/04/30.
//

import UIKit

protocol WeatherViewControllerProtocol: WeatherViewDelegate, FetchableDelegate {
    var weatherView: WeatherViewProtocol { get }
    var weatherModel: Fetchable { get }
    func handle(_ error: WeatherAppError)
}

class WeatherViewController: UIViewController, WeatherViewControllerProtocol {
    
    // MARK:- WeatherViewControllerProtocol
    
    var weatherView: WeatherViewProtocol
    var weatherModel: Fetchable
    
    func handle(_ error: WeatherAppError) {
        let message: String
        switch error {
        case .invalidParameterError:
            message = "不適切な値が設定されました"
        case .unknownError:
            message = "予期せぬエラーが発生しました"
        }
        presentAlertController(with: message)
    }
    
    init(view: WeatherViewProtocol, model: Fetchable) {
        self.weatherView = view
        self.weatherModel = model
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    deinit {
        print("WeatherViewController released")
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
        weatherView.delegate = self
        weatherModel.delegate = self
    }
    
    @objc func reload() {
        NotificationCenter.default.post(name: .beginFetch, object: nil)
        weatherModel.fetch()
    }
    
    func presentAlertController(with message: String) {
        let errorAlert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
        let errorAction = UIAlertAction(title: "OK", style: .default)
        errorAlert.addAction(errorAction)
        present(errorAlert, animated: true, completion: nil)
    }
}

// MARK:- UserActionDelegate

extension WeatherViewController {
    
    func didTapReloadButton(_ view: WeatherView) {
        reload()
    }

    func didTapCloseButton(_ view: WeatherView) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- FetcherDelegate
extension WeatherViewController {
    
    func fetch(_ fetcher: Fetchable?, didFetch information: WeatherInformation) {
        DispatchQueue.main.async { [weak self] in
            self?.weatherView.weatherViewState = WeatherViewState(information: information)
            NotificationCenter.default.post(name: .endFetch, object: nil)
        }
    }
    
    func fetch(_ fetcher: Fetchable?, didFailWithError error: WeatherAppError) {
        DispatchQueue.main.async { [weak self] in
            self?.handle(error)
            NotificationCenter.default.post(name: .endFetch, object: nil)
        }
    }
}
