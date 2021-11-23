//
//  Model.swift
//  weather
//
//  Created by Владислав Космачев.
//

import Foundation

class Model{
    
    struct Hourly:Identifiable{
        var id:Int
        var temp:Double
        var dt:Int
        var icon:String
        var snow:Double
    }

    struct Daily:Identifiable{
        var id:Int
        var temp:Double
        var dt:Int
        var icon:String
        var pop:Double
        var tempEve:Double
        var tempNight:Double
        var tempDay:Double
        var tempMorn:Double
        var feelsLikeEve:Double
        var feelsLikeNight:Double
        var feelsLikeDay:Double
        var feelsLikeMorn:Double
        var min:Double
        var max:Double
        var description:String
    }
    
    struct Cities:Identifiable{
        var id:Int
        var name:String
        var lat:Double
        var lon:Double
    }
    
}
