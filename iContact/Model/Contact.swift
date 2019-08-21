//
//  Object.swift
//  iContact
//
//  Created by Grigoriy Sapogov on 14/08/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import Foundation
import RealmSwift

enum Temperament: String, Codable {
    
    case melancholic
    case phlegmatic
    case sanguine
    case choleric
    
}

class Contact: Object, Codable {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var height: Float = 0
    @objc dynamic var biography: String = ""
    @objc dynamic var educationPeriod: EducationPeriod!
    @objc dynamic var searchPhone: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    private dynamic var privateTemperament: String = Temperament.melancholic.rawValue
    var temperament: Temperament {
        get { return Temperament(rawValue: privateTemperament)! }
        set { privateTemperament = newValue.rawValue }
    }
    
    convenience init(id: String,
                name: String,
                phone: String,
                height: Float,
                biography: String,
                temperament: Temperament,
                educationPeriod: EducationPeriod) {
        self.init()
        self.id = id
        self.name = name
        self.phone = phone
        self.searchPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        self.height = height
        self.biography = biography
        self.temperament = temperament
        self.educationPeriod = educationPeriod
    }
    
    enum Keys: String, CodingKey {
        case id
        case name
        case phone
        case height
        case biography
        case temperament
        case educationPeriod
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: Keys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.height = try container.decode(Float.self, forKey: .height)
        self.biography = try container.decode(String.self, forKey: .biography)
        self.temperament = try container.decode(Temperament.self, forKey: .temperament)
        self.educationPeriod = try container.decode(EducationPeriod.self, forKey: .educationPeriod)
        self.searchPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
}

class EducationPeriod: Object, Codable {
    
    @objc dynamic var start: Date!
    @objc dynamic var end: Date!
    
    enum Keys: String, CodingKey {
        case start
        case end
    }
    
    convenience init(start: Date, end: Date) {
        self.init()
        self.start = start
        self.end = end
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: Keys.self)
        
        let start = try container.decode(String.self, forKey: .start)
        let end = try container.decode(String.self, forKey: .end)

        self.start = DateFormatter.fullDate.date(from: start)!
        self.end = DateFormatter.fullDate.date(from: end)!
    }
}

