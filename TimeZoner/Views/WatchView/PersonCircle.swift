//
//  PersonCircle.swift
//  TimeZoner
//
//  Created by tarrask on 19/10/2021.
//

import SwiftUI

struct PersonCircle: View {
    @ObservedObject var imgStore = ImageStore.shared
    
    /// Generates the external circle with the persons avatar, and positions it according to the timezone
    let multiplier = CGFloat.pi/6
    
    let radius: CGFloat = 118
    
    let person: Person
        
    func calculateAngle() -> CGFloat {
        let localHour = CGFloat(person.localHour()) - 3
        let localMinute = CGFloat(person.localMinute())/60
                         
        return (localHour + localMinute) * multiplier
    }
    
    var body: some View {
        return ZStack {
            Circle()
                .fill()
                .foregroundColor(person.color)
                .frame(width: 30, height: 30, alignment: .center)
                .opacity(0.5)
            
            if (person.imagePath != nil) {
                Image(uiImage: imgStore.loadImage(person.imagePath!)!)
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
                    .clipShape(Circle())
            } else {
                ZStack {
                    Circle()
                        .fill()
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25, alignment: .center)
                    
                    if person.name.count > 0 {
                        Text(person.name.prefix(1))
                            .fontWeight(.bold)
                    } else if person.flag != nil {
                        Text(person.flag ?? "")
                    } else {
                        Text("?")
                    }
                }
            }
        }
        .offset(x: radius * cos(calculateAngle()),
                y: radius * sin(calculateAngle()))
    }
}
