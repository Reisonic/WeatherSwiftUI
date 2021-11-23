//
//  ColorGrad.swift
//  weather
//
//  Created by Владислав Космачев.
//

import Foundation

/// Класс цвета фона в зависимости от температуры
class GradientColor {
    
    /// функция расчета цвета
    private func calc(value:Int, maxValue:Int) -> Int {
        return ((-1*value)*(maxValue+((value*(-1))*2))) + 255
    }

    /// функция выбора текущего цвета
    func grad(value: Int, maxValue:Int) -> (colorR:Int, colorG:Int ,colorB:Int) {
        if (value == 0){
            return (255,255,255)
        } else if (value > 0 && value <= maxValue/2){
            return (calc(value: value, maxValue: maxValue),255,0)
        } else if (value > maxValue/2){
            return (255,calc(value: value, maxValue: maxValue),0)
        } else if (value < 0 && value >= (maxValue*(-1))/2){
            return (0,255,calc(value: value, maxValue: maxValue))
        } else if (value > (maxValue*(-1))/2){
            return (0,calc(value: value, maxValue: maxValue),255)
        } else {
            return (0,0,0)
        }
    }
}
