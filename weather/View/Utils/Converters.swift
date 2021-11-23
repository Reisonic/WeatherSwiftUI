//
//  Converters.swift
//  weather
//
//  Created by Владислав Космачев.
//

import Foundation

/// Класс конвертации данных
class Converter{
    
    /// Конвертация данных в часы: минуты
    ///  - Parameters:
    ///     - value: Unix формат времени
    func converterDate(value:Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(value))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ru_Ru")
        let dateString = formatter.string(from: date as Date)
        return dateString
    }
    
    /// Конвертация данных в часы
    ///  - Parameters:
    ///     - value: Unix формат времени
    func converterDateHour(value:Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(value))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        formatter.locale = Locale(identifier: "ru_Ru")
        let dateString = formatter.string(from: date as Date)
        return dateString
    }
    
    /// Конвертация данных в дни недели
    ///  - Parameters:
    ///     - value: Unix формат времени
    func converterDateWeek(value:Int) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(value))
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "ru_Ru")
        let dateString = formatter.string(from: date as Date)
        return dateString
    }
    
    /// Округление до 2 знаков после запятой
    ///  - Parameters:
    ///     - value: Число с плавующей точкой
    func converter2F(value:Double) -> String {
        return String.init(format: "%.2f", value)
    }
    
}
