
//
//  GitManager.swift
//  testeJSON
//
//  Created by Patricia de Abreu on 27/04/15.
//  Copyright (c) 2015 Patricia de Abreu. All rights reserved.
//

import UIKit

class GitManager: NSObject {
   
    
    var session: NSMutableArray = NSMutableArray()
    
//    autenticaçao do git
    func buscarRepos(user:String!) -> String{
        let clientID = "f6def8cc3f3125250e07"
        let clientSecret = "341168ccd0eb6f4f4706f7a2f29be22234de4b9b"
        let complemento = "?client_id=\(clientID)&client_secret=\(clientSecret)"
        return complemento
    }
    
    func buscarRepositorio(usuario: NSString) {
        
        var complemento = buscarRepos(usuario as String)
            
//            var path = "users/mackmobile/repos"
//            var url = NSURL(string: "https://api.github.com/\(path)?client_id=\(clientID)&client_secret=\(clientSecret)")
        
        var url: String
        var jsonData: NSData
        var arrayDeResultados: NSArray
        var result: NSDictionary
        var nomeRep: Array<String> = []
        
        var arrayDeResultadosName: NSDictionary
        var resultName: NSDictionary
        var resultOwner: NSDictionary
        var loginParent: String = ""
        var reposMackMobile: Array<String> = []
        var contador: Int = 0
        
        var urlRep: String
        var jsonRep: NSData
        var arrayDePulls: NSArray = []
        var resultPull: NSDictionary
        var pull: NSDictionary
        var pullLogin:String
        var number: Int
        
        var urlPull: String
        var jsonPull: NSData
        var arrayDoRepositorio: NSDictionary
        var resultLabel: NSDictionary
        var labels: NSArray = []
        var nomeLabel: Array<String> = []

        
//        primeira pagina - git do usuário
        url = "https://api.github.com/users/\(usuario)/repos\(complemento)"
        jsonData = NSData(contentsOfURL: NSURL(string: url)!)!
        arrayDeResultados = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSArray
        
        
//        percorre todo o array e salva no nomeRep as String que tem chave "name"
        for var i = 0; i < arrayDeResultados.count; i++ {
            
            result = arrayDeResultados.objectAtIndex(i) as! NSDictionary
            nomeRep.append(result.objectForKey("name")! as! String)
            println(nomeRep[i])
        }

//        percorre todo o array dos nomes dos repositorios
        for var i = 0; i < nomeRep.count; i++ {
            
//            segunda página - repositório do usuário
            url = "https://api.github.com/repos/\(usuario)/\(nomeRep[i])\(complemento)"
            jsonData = NSData(contentsOfURL: NSURL(string: url)!)!
            arrayDeResultadosName = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            
            if arrayDeResultadosName.objectForKey("parent") != nil {
                
//                armazenar os dados de dentro da chave "parent"
                resultName = arrayDeResultadosName.objectForKey("parent") as! NSDictionary
//                armazenar os dados de dentro da chave "owner"
                resultOwner = resultName.objectForKey("owner") as! NSDictionary
                
                
//                verifica se o loginParent é mackmobile
                if resultOwner.objectForKey("login") as! String == "mackmobile" {
                    
//                  armazena o nome do repositorio pai
                    loginParent = resultOwner.objectForKey("login") as! String
                    
//                    armazena os repositorios que tem chave "parent" como sendo mackmobile
                    reposMackMobile.append(nomeRep[i])
                    
                    println("Nome do repositorio \(reposMackMobile[contador]) login guardado \(loginParent) ")
                    
                    contador++
                }
            }
        }
        
        contador = 0
        
        for var i = 0; i < reposMackMobile.count; i++ {
            
//                    terceira página - todos os pull requests do git MackMobile
            urlRep = "https://api.github.com/repos/\(loginParent)/\(reposMackMobile[i])/pulls\(complemento)"
            jsonRep = NSData(contentsOfURL: NSURL(string: urlRep)!)!
            arrayDePulls = NSJSONSerialization.JSONObjectWithData(jsonRep, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSArray
            
            for var j = 0; j < arrayDePulls.count; j++ {
//            armazenar todas os dados de cada pull request do MackMobile
            resultPull = arrayDePulls.objectAtIndex(j) as! NSDictionary
            
//            armazenar todos os dados de dentro da chave "user"
            pull = resultPull.objectForKey("user") as! NSDictionary
            
//            armazenar todos os login dos usuários de cada pull request
            pullLogin = pull.objectForKey("login") as! String
            
//            verificar se o login do pull request é o mesmo do usuário solicitado
            if pullLogin == usuario {
                
//                pegar o id do pull request
                number = resultPull.objectForKey("number") as! Int
             println(number)
                
               
//                quarta página - dentro do pull request do usuário no repositório MackMobile
                urlPull = "https://api.github.com/repos/\(loginParent)/\(reposMackMobile[i])/issues/\(number)\(complemento)"
                jsonPull = NSData(contentsOfURL: NSURL(string: urlPull)!)!
                arrayDoRepositorio = NSJSONSerialization.JSONObjectWithData(jsonPull, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
                
//                armazenar os dados de dentro da chave "labels"
                labels = arrayDoRepositorio.objectForKey("labels") as! NSArray
                
                for var k = 0; k < labels.count; k++ {
                resultLabel = labels.objectAtIndex(k) as! NSDictionary
//                pegar os nomes da label
                nomeLabel.append(resultLabel.objectForKey("name") as! String)
                
            }
                println(nomeLabel)
            }
            }
            println("deu")
            
        }
        
    }
}
        

        
        
        
        
        
    

