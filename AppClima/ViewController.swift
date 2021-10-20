//
//  ViewController.swift
//  AppClima
//
//  Created by Mac15 on 19/10/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var TF_BuscarCiudad: UITextField!
    @IBOutlet weak var IV_WeatherCondition: UIImageView!
    @IBOutlet weak var LBL_NombreCiudad: UILabel!
    @IBOutlet weak var LBL_Temperatura: UILabel!
    @IBOutlet weak var LBL_Warning: UILabel!
    
    //MARK:- Creación del objeto "climaManager"
    
    let clima_manager = climaManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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

