//
//  CityViewController.swift
//  WeatherApplication
//
//  Created by val on 23/4/20.
//  Copyright © 2020 Munis Adilov. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    
    var weatherViewController: WeatherViewController?
    
    @IBOutlet weak var updateWeatherButton: UIButton!
   
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        cityTextField.layer.cornerRadius = 5
        updateWeatherButton.layer.cornerRadius = 5
        cityTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        cityTextField.leftViewMode = .always
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateWeatherByCityTapped(_ sender: UIButton) {
        weatherViewController?.receivedCityName(city: cityTextField.text ?? "")
        dismiss(animated: true, completion: nil)
    }
    
}
