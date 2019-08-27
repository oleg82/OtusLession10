//
//  ViewController.swift
//  OtusLession10
//
//  Created by Олег Иванов on 27/08/2019.
//  Copyright © 2019 Otus. All rights reserved.
//

import UIKit

enum Notifications {
    static let shareText = "ShareText"
}

enum Locales {
    static let englishLocaleId = "en-us"
    static let franceLocaleId = "fr-fr"
    static let chinaLocaleId = "zh-cn"
}

enum DateFormates {
    static let base = "yyyy-MMMM-dd"
}

class ViewController: UIViewController {

    // MARK: private outlets
    @IBOutlet private weak var shareLabel: UILabel!
    @IBOutlet private weak var shareDescriptionLabel: UILabel!
    @IBOutlet private weak var exampleDateLabel: UILabel!
    @IBOutlet private weak var exampleMeasurementLabel: UILabel!
    @IBOutlet private weak var localesSegmentedControl: UISegmentedControl!

    // MARK: private properties
    private var shareText = ""
    private var isDateShareText = false {
        didSet {
            var msg = ""
            if let desc = shareDescriptionLabel.text, desc.isEmpty == false {
                msg = desc + ", "
            }
            if isDateShareText {
                shareDescriptionLabel.text = msg + "this is date"
            } else {
                shareDescriptionLabel.text = msg + "this is not date"
            }
        }
    }
    private var isMeasurementShareText = false {
        didSet {
            var msg = ""
            if let desc = shareDescriptionLabel.text, desc.isEmpty == false {
                msg = desc + ", "
            }
            if isMeasurementShareText {
                shareDescriptionLabel.text = msg + "this is measurement"
            } else {
                shareDescriptionLabel.text = msg + "this is not measurement"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(loadShareText), name: NSNotification.Name(rawValue: Notifications.shareText), object: nil)
        
        applyLocaleByExampleMeasurement()
        applyLocaleByExampleDate()
        applyLocaleByShareText()
    }

    @objc func loadShareText(notfication: NSNotification) {
        if let text = notfication.object as? String {
            shareText = text
            shareDescriptionLabel.text = ""
            shareLabel.text = text
            
            isDateShareText = isDate(text)
            isMeasurementShareText = (Double.init(text) != nil)
            applyLocaleByShareText()
        }
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        applyLocaleByExampleMeasurement()
        applyLocaleByExampleDate()
        applyLocaleByShareText()
    }
    
    private func getSelectedLocale() -> String {
        let localeId: String
        switch localesSegmentedControl.selectedSegmentIndex {
        case 0:
            localeId = Locales.englishLocaleId
        case 1:
            localeId = Locales.franceLocaleId
        default:
            localeId = Locales.chinaLocaleId
        }
        return localeId
    }
    
    private func isDate(_ value: String) -> Bool {
        let formater = DateFormatter()
        formater.dateFormat = DateFormates.base
        return (formater.date(from: value) != nil)
    }
    
    private func applyLocaleByExampleMeasurement() {
        exampleMeasurementLabel.text = applyLocaleByMeasurement(value: 1000, localeId: getSelectedLocale())
    }

    private func applyLocaleByExampleDate() {
        exampleDateLabel.text = applyLocaleByDate(date: Date(), localeId: getSelectedLocale())
    }

    private func applyLocaleByShareText() {
        if isMeasurementShareText {
            if let value = Double(shareText) {
                shareLabel.text = applyLocaleByMeasurement(value: value, localeId: getSelectedLocale())
            }
        }
        if isDateShareText {
            let formater = DateFormatter()
            formater.dateFormat = DateFormates.base
            if let date = formater.date(from: shareText) {
                shareLabel.text = applyLocaleByDate(date: date, localeId: getSelectedLocale())
            }
        }
    }
    

    private func applyLocaleByMeasurement(value: Double, localeId: String) -> String {
        let locale = Locale(identifier: localeId)
        _ = locale.usesMetricSystem
        let formatter = MeasurementFormatter()
        formatter.locale = locale
        return formatter.string(from: Measurement(value: value, unit: UnitLength.meters))
    }

    private func applyLocaleByDate(date: Date, localeId: String) -> String {
        let formater = DateFormatter()
        formater.dateFormat = DateFormates.base
        formater.locale = Locale(identifier: localeId)
        return formater.string(from: date)
    }
}

