//
//  API.swift
//  weather
//
//  Created by Владислав Космачев.
//

import Foundation
import Alamofire
import SwiftyJSON

/// Класс Api
class API: ObservableObject, APIProtocol{    
    
    /// Название города
    @Published var nameCity:String = ""
    /// Иконка текущей погоды
    @Published var icon:String = ""
    /// Описание погоды
    @Published var description:String = ""
    /// Текущая температура
    @Published var temp:Double = 0.0
    /// Температура по ощущению
    @Published var feelsLike:Double = 0.0
    /// Атмосферное давление
    @Published var pressure:Int = 0
    /// Влажность
    @Published var humidity:Int = 0
    /// Температура минимальная
    @Published var tempMin:Double = 0
    /// Температура максимальная
    @Published var tempMax:Double = 0
    /// Скорость ветра
    @Published var windSpeed:Double = 0.0
    /// Направление ветра
    @Published var windDeg:Int = 0
    /// Облачность
    @Published var clouds:Int = 0
    /// Видимость
    @Published var visibility:Int = 0
    /// Восход
    @Published var sunrise:Int = 0
    /// Закат
    @Published var sunset:Int = 0
    
    /// Индекс AQI
    @Published var aqi:Int = 0
    /// Статус AQI
    @Published var aqiStatus:String = "aqi.low"
    /// Концентрация o3
    @Published var o3:Double = 0.0
    /// Концентрация co
    @Published var co:Double = 0.0
    /// Концентрация no
    @Published var no:Double = 0.0
    /// Концентрация so2
    @Published var so2:Double = 0.0
    /// Концентрация no2
    @Published var no2:Double = 0.0
    /// Концентрация pm2.5
    @Published var pm25:Double = 0.0
    /// Концентрация nh3
    @Published var nh3:Double = 0.0
    /// Концентрация pm10
    @Published var pm10:Double = 0.0
    
    /// Список важных погодных предупреждений
    @Published var alerts:[String] = []
    /// Список почасового прогноза
    @Published var hourly:[Model.Hourly] = []
    /// Список дневного прогноза
    @Published var daily:[Model.Daily] = []

    func getData(lat:Double, lon:Double) {
        
        let param = [
            "lat":lat,
            "lon":lon,
            "units":Constants.units,
            "lang":Constants.lang,
            "APPID":Constants.apiKey
        ] as [String : Any]
        
        let request = AF.request(Constants.apiLink, method: .get, parameters: param)
        request.responseJSON{ (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                
                    self.nameCity = json["name"].stringValue
                    self.description = json["weather"][0]["description"].stringValue
                    self.icon = json["weather"][0]["icon"].stringValue
                    self.sunset = json["sys"]["sunset"].intValue
                    self.sunrise = json["sys"]["sunrise"].intValue
                    self.visibility = json["visibility"].intValue
                    self.clouds = json["clouds"]["all"].intValue
                    self.windDeg = json["wind"]["deg"].intValue
                    self.windSpeed = json["wind"]["speed"].doubleValue
                
                    self.tempMax = json["main"]["temp_max"].doubleValue
                    self.tempMin = json["main"]["temp_min"].doubleValue
                
                    self.humidity = json["main"]["humidity"].intValue
                    self.pressure = json["main"]["pressure"].intValue
                
                    self.feelsLike = json["main"]["feels_like"].doubleValue
                    self.temp = json["main"]["temp"].doubleValue
                    debugPrint(json)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func getAirPollution(lat:Double, lon:Double){
        
        let param = [
            "lat":lat,
            "lon":lon,
            "units":Constants.units,
            "lang":Constants.lang,
            "APPID":Constants.apiKey
        ] as [String : Any]
        
        let request = AF.request(Constants.apiLinkAir, method: .get, parameters: param)
        request.responseJSON{ (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    self.aqi = json["list"][0]["main"]["aqi"].intValue
                    if (self.aqi == 1){
                        self.aqiStatus = "aqi.low"
                    } else if (self.aqi == 2 || self.aqi == 3) {
                        self.aqiStatus = "aqi.medium"
                    } else {
                        self.aqiStatus = "aqi.high"
                    }
                    self.o3 = json["list"][0]["components"]["o3"].doubleValue
                    self.co = json["list"][0]["components"]["co"].doubleValue
                    self.no = json["list"][0]["components"]["no"].doubleValue
                    self.so2 = json["list"][0]["components"]["so2"].doubleValue
                    self.no2 = json["list"][0]["components"]["no2"].doubleValue
                    self.pm25 = json["list"][0]["components"]["pm2_5"].doubleValue
                    self.nh3 = json["list"][0]["components"]["nh3"].doubleValue
                    self.pm10 = json["list"][0]["components"]["pm10"].doubleValue
                
                    debugPrint(json)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func getExtendedData(lat:Double, lon:Double){
        
        let param = [
            "lat":lat,
            "lon":lon,
            "units":Constants.units,
            "lang":Constants.lang,
            "APPID":Constants.apiKey
        ] as [String : Any]
        
        let request = AF.request(Constants.apiLinkExtendedData, method: .get, parameters: param)
        request.responseJSON{ (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                for i in 0...json["alerts"].count{
                    if !json["alerts"][i]["description"].stringValue.isEmpty{
                        self.alerts.append(json["alerts"][i]["description"].stringValue)
                    }
                }
                
                for i in 0...json["hourly"].count-1{
                    self.hourly.append(Model.Hourly(id: i, temp: json["hourly"][i]["temp"].doubleValue, dt: json["hourly"][i]["dt"].intValue, icon: json["hourly"][i]["weather"][0]["icon"].stringValue, snow: json["hourly"][i]["snow"]["1h"].doubleValue))
                }
                
                for i in 0...json["daily"].count-1{
                    let daily = Model.Daily(id: i, temp: json["daily"][i]["temp"]["day"].doubleValue, dt: json["daily"][i]["dt"].intValue, icon: json["daily"][i]["weather"][0]["icon"].stringValue, pop: json["daily"][i]["pop"].doubleValue, tempEve: json["daily"][i]["temp"]["eve"].doubleValue, tempNight: json["daily"][i]["temp"]["night"].doubleValue, tempDay: json["daily"][i]["temp"]["day"].doubleValue, tempMorn: json["daily"][i]["temp"]["morn"].doubleValue, feelsLikeEve: json["daily"][i]["feels_like"]["eve"].doubleValue, feelsLikeNight: json["daily"][i]["feels_like"]["night"].doubleValue, feelsLikeDay: json["daily"][i]["feels_like"]["day"].doubleValue, feelsLikeMorn: json["daily"][i]["feels_like"]["morn"].doubleValue, min: json["daily"][i]["temp"]["min"].doubleValue , max:json["daily"][i]["temp"]["max"].doubleValue, description: json["daily"][i]["weather"][0]["description"].stringValue)
                        self.daily.append(daily)
                }
                
                    debugPrint(json)
                case .failure(let error):
                    print(error)
                }
        }
    }
}
