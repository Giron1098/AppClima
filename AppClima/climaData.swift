//
//  climaData.swift
//  AppClima
//
//  Created by Mac15 on 20/10/21.
//

import Foundation

struct climaData:Codable {
    let name:String
    let timezone:Int
    let main:Main
    //let coord:Coord
    //let weather:[Weather]
}

struct Main:Codable {
    let temp:Double
    let humidity:Int
}
