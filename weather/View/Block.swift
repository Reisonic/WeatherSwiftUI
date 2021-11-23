//
//  Block.swift
//  weather
//
//  Created by Владислав Космачев.
//

import SwiftUI

/// Класс элементов блоков на экране
struct Block: ViewModifier {
    
    func body(content: Content) -> some View {
        ZStack{
            Rectangle().fill(Color.white).cornerRadius(25).shadow(radius: 10).opacity(0.75)
            VStack{
                HStack{
                    content
                    Spacer()
                }
                Spacer()
            }.foregroundColor(.gray).font(.headline).padding()
        }.frame(width:UIScreen.main.bounds.width/2.3 ,height: 120)
    }
}

struct BlockLong: ViewModifier {
    
    func body(content: Content) -> some View {
        ZStack{
            Rectangle().fill(Color.white).cornerRadius(25).shadow(radius: 10).opacity(0.75)
            VStack{
                HStack{
                    content
                    Spacer()
                }
                Spacer()
            }.foregroundColor(.gray).font(.headline).padding()
        }.frame(width:UIScreen.main.bounds.width-32)
    }
}

struct BlockCircle: ViewModifier {
    
    func body(content: Content) -> some View {
        HStack{
            ZStack{
                Circle().fill(Color.white).cornerRadius(25).shadow(radius: 10).opacity(0.75)
                VStack{
                    content
                }.foregroundColor(.white).font(.headline).padding()
            }.frame(width: 50, height: 50)
        }
    }
}

extension View{
    
    func block() -> some View{
        self.modifier(Block())
    }
    
    func blockLong() -> some View{
        self.modifier(BlockLong())
    }
    
    func blockCircle() -> some View{
        self.modifier(BlockCircle())
    }
    
}
