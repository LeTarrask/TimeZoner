//
//  Watch.swift
//  TimeZoner
//
//  Created by tarrask on 19/08/2021.
//

import SwiftUI


struct Watch_Preview: PreviewProvider {
    static var previews: Watch {
        let manager = TimeManager()
        let testPersons: [Person] = [
            Person(name: "SambaRock", timezone: TimeZone(identifier: "America/New_York") ?? TimeZone(identifier: "GMT")!, color: .red, imagePath: "samba"),
            Person(name: "Daniel", timezone: TimeZone(identifier: "America/Sao_Paulo") ?? TimeZone(identifier: "GMT")!, color: .blue),
            Person(name: "Alex", timezone: TimeZone(identifier: "Europe/Lisbon") ?? TimeZone(identifier: "GMT")!, color: .green, imagePath: "thumb"),
            Person(name: "SambaRock", timezone: TimeZone(identifier: "America/Argentina/Catamarca") ?? TimeZone(identifier: "GMT")!, color: .red, imagePath: "samba"),
            Person(name: "Daniel", timezone: TimeZone(identifier: "Asia/Amman") ?? TimeZone(identifier: "GMT")!, color: .blue),
            Person(name: "Alex", timezone: TimeZone(identifier: "Asia/Phnom_Penh") ?? TimeZone(identifier: "GMT")!, color: .green, imagePath: "thumb"),
            Person(name: "SambaRock", timezone: TimeZone(identifier: "Antarctica/Palmer") ?? TimeZone(identifier: "GMT")!, color: .red, imagePath: "samba"),
            Person(name: "Daniel", timezone: TimeZone(identifier: "Europe/Budapest") ?? TimeZone(identifier: "GMT")!, color: .blue),
            Person(name: "Alex", timezone: TimeZone(identifier: "Indian/Antananarivo") ?? TimeZone(identifier: "GMT")!, color: .green, imagePath: "thumb"),
            Person(name: "SambaRock", timezone: TimeZone(identifier: "Indian/Maldives") ?? TimeZone(identifier: "GMT")!, color: .red, imagePath: "samba"),
            Person(name: "Daniel", timezone: TimeZone(identifier: "Pacific/Wallis") ?? TimeZone(identifier: "GMT")!, color: .blue),
        ]
        
        manager.persons = testPersons
        manager.sortPersons()
        
        return Watch(manager: manager)
    }
}

struct Watch: View {
    @State var date: Date = Date()
    
    @ObservedObject var manager: TimeManager
    
    let radianInOneHour = 2 * Double.pi / 12
    let radianInOneMinute = 2 * Double.pi / 60
    
    let timeZone: Int = 1
    
    var body: some View {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: date)
        
        /// Convert Date to angle
        var minuteAngle: Double = 0
        var hourAngle: Double = 0
        var secondAngle: Double = 0
        
        if let hour =  dateComponents.hour, let minute = dateComponents.minute, let second = dateComponents.second {
            
            hourAngle = getHourAngle(hour: hour, minute: minute)
            minuteAngle = getMinuteAngle(minute: minute)
            secondAngle = getSecondAngle(second: second)
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
                // TO DO: fix the 59 to 0 second animation bug
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
                        .foregroundColor(person.color)
                        .frame(width: 4, alignment: .center)
                        .rotationEffect(.radians(getHourAngle(hour: person.localHour(),
                                                              minute: person.localMinute())))
                    PersonCircle(radius: 118,
                                 person: person)
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
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in    withAnimation(.spring()) {
            self.date = Date()
            }
        }
    }
    
    func getSecondAngle(second: Int) -> Double {
        return Double(second) * radianInOneMinute
    }
    
    func getMinuteAngle(minute: Int) -> Double {
        return Double(minute) * radianInOneMinute
    }
    
    func getHourAngle(hour: Int, minute: Int) -> Double {
        let actualHour = Double(hour) + (Double(minute)/60)
        
        return actualHour * radianInOneHour
    }
}




