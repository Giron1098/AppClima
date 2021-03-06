//
//  climaManager.swift
//  AppClima
//
//  Created by Mac15 on 20/10/21.
//

import Foundation

//MARK:- Creación del protocolo

protocol ClimaManagerDelegate {
    func actualizarClima(clima:climaModelo)
    func huboError(error:climaModeloError)
}

struct climaManager {
    
    var delegado:ClimaManagerDelegate?
    
    let api_id = "dc499537196483d36222379e13d2e0f2"
    
    
    func buscarClima(nombreCiudad: String)
    {
        let api_url = "https://api.openweathermap.org/data/2.5/weather?q=\(nombreCiudad)&appid=\(api_id)&units=metric&lang=es"
        
        print("API URL: \(api_url)")
        realizarSolicitud(urlString: api_url)
    
    }
    
    func buscarClimaGPS(latitud:String, longitud:String)
    {
        let api_url_gps = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitud)&lon=\(longitud)&appid=\(api_id)&units=metric&lang=es"
        print("API URL GPS: \(api_url_gps)")
        realizarSolicitud(urlString: api_url_gps)
        
    }
    
    func realizarSolicitud(urlString:String)
    {
        //1.- Crear URL
        if let url = URL(string: urlString)
        {
            //2.- Crear sesión con la URL
            let session = URLSession(configuration: .default)
            
            //3.- Asignarle una tarea a la sesión para recuperar el contenido
            //let tarea = session.dataTask(with: url, completionHandler: handler(datos:respuesta:error:))
            let tarea = session.dataTask(with: url){datos, respuesta, error in
                if error != nil
                {
                    print("Error al relizar solicitud. Error: \(error?.localizedDescription)")
                } else {
                    if let datosSeguros = datos
                    {
                        //let datosString = String(data:datosSeguros, encoding: .utf8)
                        //print("Datos seguros: \(datosString)")
                        
                        //Creaciòn del objeto personalizado
                        
                        if let objClima = parseJSON(clima_data: datosSeguros)
                        {
                            delegado?.actualizarClima(clima: objClima)
                        }
                        
                        if let objClimaError = parseJSON_Error(clima_data_error: datosSeguros)
                        {
                            //print("ENTRÓ")
                            delegado?.huboError(error: objClimaError)
                        }
                        
                        //parseJSON(clima_data: datosSeguros)
                    }
                }
                
            }
            
            //4.- Iniciar
            tarea.resume()
        }
    }
    
    func parseJSON_Error(clima_data_error:Data) -> climaModeloError?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let datosError = try decoder.decode(climaDataError.self, from: clima_data_error)
            
            print(datosError.cod)
            print(datosError.message)
            
            
            let objClimaJSON_Error = climaModeloError(codigoError: datosError.cod, mensajeError: datosError.message)
            
            return objClimaJSON_Error
        } catch {
            //print("Error al parsear el JSON del Error: \(error.localizedDescription)")
            return nil
            
        }
    }
    
    func parseJSON(clima_data:Data) -> climaModelo?
    {
        let decoder = JSONDecoder()
        
        do
        {
            let datosDecodificados = try decoder.decode(climaData.self, from: clima_data)
            
            print(datosDecodificados.name)
            print(datosDecodificados.main.temp)
            print(datosDecodificados.weather[0].description)
            print(datosDecodificados.sys.country)
            print(datosDecodificados.coord.lat)
            print(datosDecodificados.coord.lon)
            print(datosDecodificados.weather[0].id)
            print(datosDecodificados.weather[0].icon)
            
            //Creación del objeto con los parámetros
            
            let objClimaJSON = climaModelo(nombreCiudad: datosDecodificados.name, temperaturaCelcius: datosDecodificados.main.temp, descripcionClima: datosDecodificados.weather[0].description, country: datosDecodificados.sys.country, latitud: datosDecodificados.coord.lat, longitud: datosDecodificados.coord.lon, conditionID: datosDecodificados.weather[0].id, weather_icon: datosDecodificados.weather[0].icon)
            
            return objClimaJSON
    
    } catch {
            //print("Error al parsear el JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    //Creación de la tarea a ejecutar
    /*func handler(datos:Data?, respuesta:URLResponse?, error: Error?)
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
    }*/
}
