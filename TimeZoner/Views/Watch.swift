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
            Person(name: "SambaRock", timezone: TimeZone(identifier: "America/New_York") ?? TimeZone(identifier: "GMT")!, color: .red, image: Image("thumb")),
            Person(name: "Daniel", timezone: TimeZone(identifier: "America/Sao_Paulo") ?? TimeZone(identifier: "GMT")!, color: .blue),
            Person(name: "Mikee", timezone: TimeZone(identifier: "America/Los_Angeles") ?? TimeZone(identifier: "GMT")!, color: .green)
        ]
        
        manager.persons = testPersons
        
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
        
        //Convert Date to angle
        var minuteAngle: Double = 0
        var hourAngle: Double = 0
        var secondAngle: Double = 0
        
        if let hour =  dateComponents.hour, let minute = dateComponents.minute, let second = dateComponents.second {
            
            hourAngle = getHourAngle(hour: hour, minute: minute)
            minuteAngle = getMinuteAngle(minute: minute)
            secondAngle = getSecondAngle(second: second)
        }
        
        return ZStack{
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
            
            // MARK: Extra hands
            Group {
                ForEach(manager.persons) { person in
                    Hand(offSet: 40)
                        .fill()
                        .foregroundColor(person.color)
                        .frame(width: 4, alignment: .center)
                        .rotationEffect(.radians(getHourAngle(hour: person.localHour(),
                                                              minute: person.localMinute())))
                    PersonCircle(radius: 118,
                                 person: person)
                }
            }
            
            // MARK: Regular watch hands
            Group {
                //Hour hand
                Hand(offSet: 40)
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

// External circles generator
struct PersonCircle: View {
    let multiplier = CGFloat.pi/6
    
    let radius: CGFloat
    
    let person: Person
        
    func generatePosition() -> CGFloat {
        switch person.localHour() {
        case 0, 12:
            return 9
        case 1, 13:
            return 10
        case 2, 14:
            return 11
        case 3, 15:
            return 0
        case 4, 16:
            return 1
        case 5, 17:
            return 2
        case 6, 18:
            return 3
        case 7, 19:
            return 4
        case 8, 20:
            return 5
        case 9, 21:
            return 6
        case 10, 22:
            return 7
        case 11, 23:
            return 8
        default:
            return 0
        }
    }
    
    var body: some View {
        let position = generatePosition()
        
        return ZStack {
            Circle()
                .fill()
                .foregroundColor(person.color)
                .frame(width: 30, height: 30, alignment: .center)
                .opacity(0.5)
                
            if (person.image != nil) {
                person.image
                    .frame(width: 25, height: 25, alignment: .center)
                    .clipShape(Circle())
            } else {
                // TO DO: get first letter from name
                Text("D")
            }
        }
        .offset(x: radius * cos(position*multiplier),
                y: radius * sin(position*multiplier))
    }
}

// Watchface drawing views
struct Arc: Shape {
    var startAngle: Angle = .radians(0)
    var endAngle: Angle = .radians(Double.pi * 2)
    var clockWise: Bool = true
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width/2, rect.height/2)
        
        path.addArc(center:  center, radius: radius , startAngle: startAngle, endAngle: endAngle, clockwise: clockWise)
        return path
    }
}

struct Hand: Shape {
    var offSet: CGFloat = 0
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(in: CGRect(origin: CGPoint(x: rect.origin.x, y: rect.origin.y + offSet), size: CGSize(width: rect.width, height: rect.height/2 - offSet)), cornerSize: CGSize(width: rect.width/2, height: rect.width/2))
        return path
    }
}

struct Ticks: View {
    var body: some View {
        ZStack {
            ForEach(0..<60) { position in
                Tick(isLong: position % 5 == 0 )
                    .stroke(lineWidth: 2)
                    .rotationEffect(.radians(Double.pi*2 / 60 * Double(position)))
                
            }
        }
    }
}

struct Tick: Shape {
    var isLong: Bool = false
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x:rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x:rect.midX, y: rect.minY + 5 + (isLong ? 5 : 0) ))
        return path
    }
}

struct Numbers: View {
    var body: some View {
        ZStack{
            ForEach(1..<13) { hour in
                Number(hour: hour)
            }
            
        }
    }
}

struct Number: View {
    var hour: Int
    var body: some View {
        VStack {
            Text("\(hour)").fontWeight(.bold)
                .rotationEffect(.radians(-(Double.pi*2 / 12 * Double(hour))))
            Spacer()
        }
        .padding()
        .rotationEffect(.radians( (Double.pi*2 / 12 * Double(hour))))
    }
}
