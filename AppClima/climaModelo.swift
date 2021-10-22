//
//  climaModelo.swift
//  AppClima
//
//  Created by Mac15 on 20/10/21.
//

import Foundation

struct climaModelo {
    let nombreCiudad:String
    let temperaturaCelcius:Double
    let descripcionClima:String
    let country:String
    let latitud:Double
    let longitud:Double
    let conditionID:Int
    let weather_icon:String
    
    var obtenerCondicionClima:String
    {
        switch conditionID {
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        case 701...781:
            return "sun.haze"
        case 600...622:
            return "snow"
        case 500...531:
            return "cloud.rain"
        case 300...321:
            return "cloud.drizzle"
        case 200...232:
            return "cloud.bolt"
        
        default:
            return "xmark.icloud"
        }
    }
    
    var obtenerCondicionClimaFondo:String
    {
        switch conditionID {
        case 800:
            return "soleado"
        case 801...804:
            return "nublado"
        case 701...781:
            return "neblina"
        case 600...622:
            return "nevando"
        case 500...531:
            return "lluvia"
        case 300...321:
            return "llovizna"
        case 200...232:
            return "tormenta_electrica"
        
        default:
            return "clima_app2"
        }
        
    }
    
}

