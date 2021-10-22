//
//  ViewController.swift
//  AppClima
//
//  Created by Mac15 on 19/10/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController{

    @IBOutlet weak var TF_BuscarCiudad: UITextField!
    @IBOutlet weak var IV_WeatherCondition: UIImageView!
    @IBOutlet weak var LBL_NombreCiudad: UILabel!
    @IBOutlet weak var LBL_Temperatura: UILabel!
    @IBOutlet weak var LBL_Warning: UILabel!
    @IBOutlet weak var LBL_Country: UILabel!
    @IBOutlet weak var LBL_DescripcionClima: UILabel!
    @IBOutlet weak var LBL_Celcius: UILabel!
    @IBOutlet weak var IV_FondoClima: UIImageView!
    
    var latitud:Double?
    var longitud:Double?
    
    //MARK:- Creación del objeto "climaManager"
    
    var clima_manager = climaManager()
    
    //Creaciòn del objeto locationManager para el GPS
    var locationManager:CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager = CLLocationManager()
        
        locationManager?.delegate = self
        
        //Solicitar permiso para el GPS
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        
        clima_manager.delegado = self
        TF_BuscarCiudad.delegate = self
    }
    @IBAction func BTN_A_Buscar_por_GPS(_ sender: UIButton) {
        
        if let lat = latitud
        {
            if let lon = longitud
            {
                let lat_gps = "\(lat)"
                let lon_gps = "\(lon)"
                print("LAT: \(lat), LONG: \(lon)")
                
                clima_manager.buscarClimaGPS(latitud: lat_gps, longitud: lon_gps)
            }
        }
        
    }
    
    @IBAction func BTN_A_BuscarCiudad(_ sender: UIButton) {
        
        if let ciudad = TF_BuscarCiudad.text
        {
            clima_manager.buscarClima(nombreCiudad: ciudad)
            LBL_Warning.text = ""
            TF_BuscarCiudad.text = ""
        } else {
            LBL_Temperatura.text = ""
            LBL_Celcius.text = ""
            LBL_NombreCiudad.text = ""
            LBL_Country.text = ""
            LBL_DescripcionClima.text = ""
            IV_WeatherCondition.image = UIImage(systemName:"questionmark.circle")
            IV_FondoClima.image = UIImage(named: "clima_app2")
            LBL_Warning.text = "Nada que localizar"
        }
    }
    
}

//MARK:- Relizar bùsqueda ClimaManagerDelegate con ubicaciòn

extension ViewController:CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Ubicación obtenida")
        if let ubicacion = locations.last
        {
            //Detener la ubicación
            locationManager?.stopUpdatingLocation()
            latitud = ubicacion.coordinate.latitude
            longitud = ubicacion.coordinate.longitude
            
            //print("LAT: \(latitud) LONG: \(longitud)")
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error al obtener la ubicación")
    }
}

//MARK:-Relizar búsqueda ClimaManagerDelegate

extension ViewController:ClimaManagerDelegate
{
    func actualizarClima(clima: climaModelo) {
        //print("Temperatura desde el VC: \(clima.temperaturaCelcius)")
        
        let temperaturaRounded = Int(clima.temperaturaCelcius.rounded())
        //print(temperaturaRounded)
 
        DispatchQueue.main.async {
            self.LBL_Temperatura.text = "\(temperaturaRounded)"
            self.LBL_Celcius.text = "ºC"
            self.LBL_NombreCiudad.text = clima.nombreCiudad
            self.LBL_Country.text = clima.country
            self.LBL_DescripcionClima.text = clima.descripcionClima.capitalizingFirstLetter()
            self.IV_WeatherCondition.image = UIImage(systemName: "\(clima.obtenerCondicionClima)")
            self.IV_FondoClima.image = UIImage(named: "\(clima.obtenerCondicionClimaFondo)")
            self.LBL_Warning.text = ""
        }
    }
    
    func huboError(error: climaModeloError) {
        let cod_error = "\(error.codigoError)"
        
        DispatchQueue.main.async {
            if (cod_error.elementsEqual("404") == true)
            {
                self.LBL_Temperatura.text = ""
                self.LBL_Celcius.text = ""
                self.LBL_NombreCiudad.text = ""
                self.LBL_Country.text = ""
                self.LBL_DescripcionClima.text = ""
                self.IV_WeatherCondition.image = UIImage(systemName:"questionmark.circle")
                self.IV_FondoClima.image = UIImage(named: "clima_app2")
                self.LBL_Warning.text = "Ciudad no encontrada"
            } else if (cod_error.elementsEqual("401") == true)
            {
                self.LBL_Temperatura.text = ""
                self.LBL_Celcius.text = ""
                self.LBL_NombreCiudad.text = ""
                self.LBL_Country.text = ""
                self.LBL_DescripcionClima.text = ""
                self.IV_WeatherCondition.image = UIImage(systemName:"questionmark.circle")
                self.IV_FondoClima.image = UIImage(named: "clima_app2")
                self.LBL_Warning.text = "API Key inváida"
            } else if (cod_error.elementsEqual("400") == true)
            {
                self.LBL_Temperatura.text = ""
                self.LBL_Celcius.text = ""
                self.LBL_NombreCiudad.text = ""
                self.LBL_Country.text = ""
                self.LBL_DescripcionClima.text = ""
                self.IV_WeatherCondition.image = UIImage(systemName:"questionmark.circle")
                self.IV_FondoClima.image = UIImage(named: "clima_app2")
                self.LBL_Warning.text = "Nada que localizar"
                
            }
        }
    }
    
    
}


//MARK:- Métodos para el TextField

extension ViewController:UITextFieldDelegate
{
    //MARK:- Asignar acción al botón "Buscar" del teclado virtual
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        TF_BuscarCiudad.endEditing(true)
        
        if(TF_BuscarCiudad.text != "")
        {
            //LBL_NombreCiudad.text = TF_BuscarCiudad.text
            TF_BuscarCiudad.text = ""
            LBL_Warning.text = ""
        } else {
            LBL_Temperatura.text = ""
            LBL_Celcius.text = ""
            LBL_NombreCiudad.text = ""
            LBL_Country.text = ""
            LBL_DescripcionClima.text = ""
            IV_WeatherCondition.image = UIImage(systemName:"questionmark.circle")
            IV_FondoClima.image = UIImage(named: "clima_app2")
            LBL_Warning.text = "Nada que localizar"
            
        }
        
        return true
    }
    
    //MARK:- Indicar al VC cuando el usuario ha dejado de escribir
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //MARK:- REALIZAR BUSQUEDA EN LA API
        
        if let ciudad = TF_BuscarCiudad.text
        {
            clima_manager.buscarClima(nombreCiudad: ciudad)
            LBL_Warning.text = ""
        } else {
            LBL_Temperatura.text = ""
            LBL_Celcius.text = ""
            LBL_NombreCiudad.text = ""
            LBL_Country.text = ""
            LBL_DescripcionClima.text = ""
            IV_WeatherCondition.image = UIImage(systemName:"questionmark.circle")
            IV_FondoClima.image = UIImage(named: "clima_app2")
            LBL_Warning.text = "Nada que localizar"
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(TF_BuscarCiudad.text != "")
        {
            LBL_Warning.text = ""
            return true
        } else {
            LBL_Temperatura.text = ""
            LBL_Celcius.text = ""
            LBL_NombreCiudad.text = ""
            LBL_Country.text = ""
            LBL_DescripcionClima.text = ""
            IV_WeatherCondition.image = UIImage(systemName:"questionmark.circle")
            IV_FondoClima.image = UIImage(named: "clima_app2")
            LBL_Warning.text = "Nada que localizar"
            
            return false
        }
        
    }
    
}

extension String
{
    func capitalizingFirstLetter() -> String
    {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter()
    {
        self = self.capitalizingFirstLetter()
    }
}
