//
//  csvparser.swift
//  StopBannon
//
//  Created by Kathleen Lu on 11/19/16.
//  Copyright (c) 2016 Kyle Jablon. All rights reserved.
//

import Foundation

func parseCSV (_ contentsOfURL: URL, encoding: String.Encoding) -> [(lastname:String, firstname:String, party: String, phone:String, state:String, position:String, denounced:String)]? {
    // Load the CSV file and parse it
    let delimiter = ","
    var items:[(lastname:String, firstname:String, party: String, phone:String, state:String, position:String, denounced:String)]?
    
    if let content = String(contentsOf: contentsOfURL, encoding: encoding) {
        items = []
        let lines:[String] = content.componentsSeparatedByCharactersInSet(CharacterSet.newlineCharacterSet()) as [String]
        
        for line in lines {
            var values:[String] = []
            values = line.components(separatedBy: delimiter)
            // Put the values into the tuple and add it to the items array
            let item = (lastname: values[0], firstname: values[1], party: values[2], phone: values[3], state: values[4], position: values[5], denounced: values[6])
            items?.append(item)
        }
    }
    
    return items
}


func preloadData () {
    // Retrieve data from the source file
    if let contentsOfURL = Bundle.main.url(forResource: "politicians", withExtension: "csv") {
        
        if let items = parseCSV(contentsOfURL, String.Encoding.utf8) {
            // Preload the menu items
            if let managedObjectContext = self.managedObjectContext {
                for item in items {
                    let politician = NSEntityDescription.insertNewObjectForEntityForName("Politician", inManagedObjectContext: managedObjectContext) as! Politician
                    politician.lastname = item.lastname
                    politician.firstname = item.firstname
                    politician.party = item.party
                    politician.phone = item.phone
                    politician.state = item.state
                    politician.position = item.position
                    politician.denounced = item.denounced
                    
                }
            }
        }
    }
}
