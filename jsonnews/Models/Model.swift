//
//  Model.swift
//  jsonnews
//
//  Created by Rinat Luhmanov on 22/01/2019.
//  Copyright © 2019 Rinat Luhmanov. All rights reserved.
//

import Foundation

var articles: [Article] = []

var urlToData: URL {
    let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]+"/data.json"
    let urlPath = URL(fileURLWithPath: path)
    return urlPath
}

func loadNews(completionHendler: (()-> Void)?) {
    let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=2fb9897fb94f453b9ff9408979a816ac")
    let session = URLSession(configuration: .default)
   let downloadTask = session.downloadTask(with: url!) { (urlFile, responce, error)  in
        if urlFile != nil {
            try? FileManager.default.copyItem(at: urlFile!, to: urlToData)
            
            //print(urlToData)
            parseNews()
            completionHendler?()
            //print(articles.count)
        }
    }
    downloadTask.resume()
}

func parseNews() {
    let data = try? Data(contentsOf: urlToData)
    if data == nil {
        return
    }
    let rootDictionaryAny = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
    if rootDictionaryAny == nil {
        return
    }
    let rootDictionary = rootDictionaryAny as? Dictionary<String, Any>
    if rootDictionary == nil {
        return
    }
    
    if let array = rootDictionary!["articles"] as? [Dictionary<String, Any>] {
        var returnArray: [Article] = []
        
        for dict in array {
            let newArticle = Article(dictionary: dict)
            returnArray.append(newArticle)
            
        }
        articles = returnArray
    
    }
}
