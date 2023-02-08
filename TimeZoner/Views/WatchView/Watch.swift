//
//  Watch.swift
//  TimeZoner
//
//  Created by tarrask on 19/08/2021.
//

import SwiftUI

struct Watch: View {
    @State var date: Date = Date()
    
    @ObservedObject var manager = TimeManager.shared
        
    var body: some View {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: date)
        
        /// Convert Date to angle
        var minuteAngle: Double = 0
        var hourAngle: Double = 0
        var secondAngle: Double = 0
        
        if let hour =  dateComponents.hour,
            let minute = dateComponents.minute,
            let second = dateComponents.second {
            
            let radianInOneHour = 2 * Double.pi / 12
            let radianInOneMinute = 2 * Double.pi / 60
            
            minuteAngle = Double(minute) * radianInOneMinute
            
            let actualHour = Double(hour) + (Double(minute)/60)
            hourAngle = actualHour * radianInOneHour
            
            secondAngle = Double(second) * radianInOneMinute
        }
        
        return ZStack {
            Circle().fill(Color.green.opacity(0.2))
            
            // MARK: Watchface drawing
            Group {
                Arc()
                    .stroke(lineWidth: 3)
                
                Ticks()
                Numbers()
                Circle()
                    .fill()
                    .frame(width: 15, height: 15, alignment: .center)
            }
            
            // MARK: Regular watch hands
            Group {
                //Hour hand
                Hand(offSet: 35)
                    .fill()
                    .frame(width: 4, alignment: .center)
                    .rotationEffect(.radians(hourAngle))
                
                //Minute hand
                Hand(offSet: 10)
                    .fill()
                    .frame(width: 3, alignment: .center)
                    .rotationEffect(.radians(minuteAngle))
                
                //Second hand
                Hand(offSet: 5)
                    .fill()
                    .foregroundColor(.red)
                    .frame(width: 2, alignment: .center)
                    .rotationEffect(.radians(secondAngle))
            }
            
            // MARK: Extra hands
            Group {
                ForEach(manager.persons) { person in
                    Hand(offSet: 50)
                        .fill()
                        .foregroundColor(person.color).opacity(0.3)
                        .frame(width: 4, alignment: .center)
                        .rotationEffect(.radians(getHourAngle(hour: person.localHour(),
                                                              minute: person.localMinute())))
                    
                    PersonCircle(person: person)
                }
            }
                      
            Circle()
                .fill()
                .foregroundColor(.red)
                .frame(width: 7, height: 7, alignment: .center)
        }
        .frame(width: 200, height: 200, alignment: .center)
        .onAppear(perform: start)
    }
    
    func start() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.date = Date()
        }
    }
    
    func getHourAngle(hour: Int, minute: Int) -> Double {
        let actualHour = Double(hour) + (Double(minute)/60)
        let radianInOneHour = 2 * Double.pi / 12
        
        return actualHour * radianInOneHour
    }
}

struct Watch_Preview: PreviewProvider {
    static var previews: Watch {
        let testPersons: [Person] = [
            Person(name: "SambaRock", timezone: TimeZone(identifier: "America/New_York") ?? TimeZone(identifier: "GMT")!, color: .red, imagePath: "samba", flag: "🇵🇹"),
            Person(name: "Daniel", timezone: TimeZone(identifier: "America/Sao_Paulo") ?? TimeZone(identifier: "GMT")!, color: .blue),
            Person(name: "Alex", timezone: TimeZone(identifier: "Europe/Lisbon") ?? TimeZone(identifier: "GMT")!, color: .green, imagePath: "thumb", flag: "🇨🇺"),
            Person(name: "SambaRock", timezone: TimeZone(identifier: "America/Argentina/Catamarca") ?? TimeZone(identifier: "GMT")!, color: .red, imagePath: "samba", flag: "🇨🇺"),
            Person(name: "Daniel", timezone: TimeZone(identifier: "Asia/Amman") ?? TimeZone(identifier: "GMT")!, color: .blue, flag: "🇵🇹"),
            Person(name: "Alex", timezone: TimeZone(identifier: "Asia/Phnom_Penh") ?? TimeZone(identifier: "GMT")!, color: .green, imagePath: "thumb"),
            Person(name: "SambaRock", timezone: TimeZone(identifier: "Antarctica/Palmer") ?? TimeZone(identifier: "GMT")!, color: .red, imagePath: "samba", flag: "🇨🇺"),
            Person(name: "Daniel", timezone: TimeZone(identifier: "Europe/Budapest") ?? TimeZone(identifier: "GMT")!, color: .blue, flag: "🇵🇹"),
            Person(name: "Alex", timezone: TimeZone(identifier: "Indian/Antananarivo") ?? TimeZone(identifier: "GMT")!, color: .green, imagePath: "thumb"),
            Person(name: "SambaRock", timezone: TimeZone(identifier: "Indian/Maldives") ?? TimeZone(identifier: "GMT")!, color: .red, imagePath: "samba", flag: "🇵🇹"),
            Person(name: "Daniel", timezone: TimeZone(identifier: "Pacific/Wallis") ?? TimeZone(identifier: "GMT")!, color: .blue, flag: "🇨🇺")
        ]
        
        let watch = Watch()
        
        watch.manager.persons = testPersons
        watch.manager.sortPersons()
        
        return watch
    }
}
