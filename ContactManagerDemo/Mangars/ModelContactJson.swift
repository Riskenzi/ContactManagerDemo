//
//  ModelContactJson.swift
//  ContactManagerDemo
//
//  Created by Valerii Melnykov on 30.10.2020.
//

import Foundation

// MARK: - Model
struct Model : Decodable {
    let results: [Contact]?
}

// MARK: - Result
struct Contact : Decodable{
    let name: Name?
    let email: String?
    let picture: Picture?
}

// MARK: - Name
struct Name : Decodable{
    let title, first, last: String?
}

// MARK: - Picture
struct Picture : Decodable {
    let large, medium, thumbnail: String?
}
