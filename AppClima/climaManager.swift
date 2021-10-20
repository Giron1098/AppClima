//
//  climaManager.swift
//  AppClima
//
//  Created by Mac15 on 20/10/21.
//

import Foundation


struct climaManager {
    let apy_id = "dc499537196483d36222379e13d2e0f2"
    
    func buscarClima(nombreCiudad: String)
    {
        let api_url = "https://api.openweathermap.org/data/2.5/weather?q=\(nombreCiudad)&appid=\(apy_id)&units=metric&lang=es"
        
        print("API URL: \(api_url)")
        realizarSolicitud(urlString: api_url)
    
    }
    
    func realizarSolicitud(urlString:String)
    {
        //1.- Crear URL
        if let url = URL(string: urlString)
        {
            //2.- Crear sesión con la URL
            let session = URLSession(configuration: .default)
            
            //3.- Asignarle una tarea a la sesión para recuperar el contenido
            let tarea = session.dataTask(with: url, completionHandler: handler(datos:respuesta:error:))
            
            //4.- Iniciar
            tarea.resume()
        }
    }
    
    //Creación de la tarea a ejecutar
    func handler(datos:Data?, respuesta:URLResponse?, error: Error?)
    {
        if error != nil
        {
            print("Error al procesar la petición. Error: \(error?.localizedDescription)")
            return
        } else {
            if let datosSeguros = datos
            {
                let datosString = String(data:datosSeguros, encoding: .utf8)
                print("Datos seguros: \(datosString)")
            }
        }
    }
}
