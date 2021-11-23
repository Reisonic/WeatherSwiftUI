//
//  APIGeocodingProtocol.swift
//  weather
//
//  Created by Владислав Космачев.
//

import Foundation

protocol APIGeocodingProtocol{
    
    /// Функция получения списка городов
    /// - Parameters:
    ///     - query: Название города
    func getCities(query:String)
}
