//
//  climaData.swift
//  AppClima
//
//  Created by Mac15 on 20/10/21.
//

import Foundation

struct climaData:Codable {
    let name:String
    let main:Main
    let weather:[Weather]
    let sys:Sys
    let coord:Coord
}

struct Coord:Codable {
    let lat:Double
    let lon:Double
}

struct Sys:Codable {
    let country:String
}

struct Weather:Codable {

    let id:Int
    let description:String
    let icon:String
}

struct Main:Codable {
    let temp:Double
}
