//
//  Constants.swift
//  weather
//
//  Created by Владислав Космачев.
//

import Foundation

/// Класс констант
class Constants{
    
    /// Ссылка основного запроса
    static let apiLink:String = "http://api.openweathermap.org/data/2.5/weather"
    /// Ссылка расширенного запроса
    static let apiLinkExtendedData:String = "http://api.openweathermap.org/data/2.5/onecall"
    /// Ссылка на сбор данных состояния воздуха
    static let apiLinkAir:String = "http://api.openweathermap.org/data/2.5/air_pollution"
    /// Ссылка на геокодинг
    static let apiLinkGeocoding = "http://api.openweathermap.org/geo/1.0/direct"
    /// Ключ для api
    static let apiKey:String = "faf7b3682e2db722894e2e63c9096fd6"
    /// Система измерения - метрическая
    static let units:String = "metric"
    /// Язык ответа - русский
    static let lang:String = "ru"
    
}
