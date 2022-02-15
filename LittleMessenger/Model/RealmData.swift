//
//  RealmData.swift
//  LittleMessenger
//
//  Created by Kuziboev Siddikjon on 2/13/22.
//

import UIKit
import RealmSwift

protocol DateDelegate {
    static func getCurrentTime()-> String
}

class RealmData {

    static var shared = RealmData()
    var realm : Realm!

    init() {
        realm = try! Realm()
        print(realm.configuration.fileURL,"fileurl")
    }

    func saveIteams(data: MessageRealmData){
        try! realm.write({
            realm.add(data, update: .modified)
        })
    }

    func fetchData()-> [MessageRealmData] {
        realm.objects(MessageRealmData.self).compactMap{$0}
    }
    
    func findComicsByTitle()-> [String: [MessageRealmData]]  {
        var dic: [String: [MessageRealmData]] = [:]
        

        for i in realm.objects(MessageRealmData.self) {

                    
                    let formatter1 = DateFormatter()
                    formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
                    formatter1.locale = Locale(identifier: "en_US_POSIX")
                    var week = ""
                    var day = ""
            if let date2 = formatter1.date(from: i.created_at) {
                        let weekday = Calendar.current.component(.weekday, from: date2 )
                        switch weekday {
                        case 1: week = "Sun"
                        case 2: week = "Mon"
                        case 3: week = "Tue"
                        case 4: week = "Wed"
                        case 5: week = "Thu"
                        case 6: week = "Fri"
                        default:
                            week = "Sat"
                        }
                    }
                    
            if let date3 = formatter1.date(from: i.created_at) {
                        let month = Calendar.current.component(.month, from: date3 )
                        switch month {
                        case 1: day = "Jan"
                        case 2: day = "Feb"
                        case 3: day = "Mar"
                        case 4: day = "Apr"
                        case 5: day = "May"
                        case 6: day = "Jun"
                        case 7: day = "Jul"
                        case 8: day = "Aug"
                        case 9: day = "Sep"
                        case 10: day = "Oct"
                        case 11: day = "Nov"
                        default:
                        day = "Dec"
                        }

                    }
                    
            let key =  week + ", \(day) " + i.created_at.dateToString(format: "ddyyyy")
                    if let _ = dic[key] {
                        let d = MessageRealmData()
                        d.created_at = i.created_at
                        d.user = i.user
                        d.img = i.img
                        d.id = i.id
                        d.text = i.text
                        d.type = i.type
                        d.user_img = i.user_img
                        d.name = i.name
                        
                        dic[key]!.append(d)
                    } else {
                        
                        let d = MessageRealmData()
                        d.created_at = i.created_at
                        d.user = i.user
                        d.img = i.img
                        d.id = i.id
                        d.text = i.text
                        d.type = i.type
                        d.user_img = i.user_img
                        d.name = i.name
                        dic[key] = [d]
                        
                    }
                
        }
        return dic

    }



    func deleteAll() {
        try! realm.write({
            realm.deleteAll()
        })
    }
    
    func deleteIteam(data: MessageRealmData) {
        
        let deleteIteam = realm.object(ofType: MessageRealmData.self, forPrimaryKey: data.id)
        guard let d = deleteIteam else {return}
        try! realm.write({
            realm.delete(d)
        })
    }


}



class MessageRealmData: Object, Codable {
    
    static func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        return formatter.string(from: Date())
    }

    
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var type: String
    @objc dynamic var user : String
    @objc dynamic var name : String?
    @objc dynamic var user_img : Data?


    @objc dynamic var img: Data?
    @objc dynamic var text: String?
    @objc dynamic var created_at: String = ""
    
    override class func primaryKey() -> String? {
        "id"
    }


    
    enum MessageType: String, Codable {
        case text = "text"
        case photo = "photo"
    }
    
    enum UserType: String, Codable {
        case first = "first"
        case second = "second"
        case third = "third"
    }
}


