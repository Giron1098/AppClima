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

    @IBAction func BTN_A_BuscarCiudad(_ sender: UIButton) {
        
        if(TF_BuscarCiudad.text != "")
        {
            //LBL_NombreCiudad.text = TF_BuscarCiudad.text
            TF_BuscarCiudad.text = ""
            LBL_Warning.text = ""
        } else {
            LBL_Warning.text = "Ingrese el nombre de una ciudad y un país"
            
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
            let latitud = ubicacion.coordinate.latitude
            let longitud = ubicacion.coordinate.longitude
            
            print("LAT: \(latitud) LONG: \(longitud)")
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
        }
    }
    
    func huboError(error: Error) {
        
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
            LBL_Warning.text = "Ingrese el nombre de una ciudad y un país"
            
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
            LBL_Warning.text = "Ingrese el nombre de una ciudad y un país"
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(TF_BuscarCiudad.text != "")
        {
            LBL_Warning.text = ""
            return true
        } else {
            LBL_Warning.text = "Ingrese el nombre de una ciudad y un país"
            
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
