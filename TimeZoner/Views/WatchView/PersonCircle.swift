//
//  PersonCircle.swift
//  TimeZoner
//
//  Created by tarrask on 19/10/2021.
//

import SwiftUI

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
                
            if (person.imagePath != nil) {
                Image(person.imagePath!)
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
                    } else {
                        Text("?")
                    }
                    
                }
            }
        }
        .offset(x: radius * cos(position*multiplier),
                y: radius * sin(position*multiplier))
    }
}
