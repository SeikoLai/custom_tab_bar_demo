//
//  ContentView.swift
//  CustomTabBarDemo
//
//  Created by Sam Lai on 2022/7/16.
//

import SwiftUI

struct FloatingTabBar: View {
    var tabs = ["house.fill", "arrow.triangle.2.circlepath", "person.fill"]
    
    @State var selectedTab = "arrow.triangle.2.circlepath"
    
    // Location of each curve
    @State var xAxis: CGFloat = 0
    @Namespace var animation
    
    
    // Use to start button animatiion
    @State var isAnimating = false
    
    
    // Button dimension
    let buttonDimension = 22.0
    
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
            TabView(selection: $selectedTab) {
                Color(.black)
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("house.fill")
                Color(.lightGray)
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("arrow.triangle.2.circlepath")
                Color(.gray)
                    .ignoresSafeArea(.all, edges: .all)
                    .tag("person.fill")
            }
            
            // custom tab bar
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { image in
                    let isSelectedTab: Bool = selectedTab == image
                    GeometryReader { reader in
                        Button(action: {
                            if image == "arrow.triangle.2.circlepath" {
                                isAnimating.toggle()
                            }
                        }, label:{
                            if isAnimating {
                                Image(systemName: image == "arrow.triangle.2.circlepath" ? "checkmark" : image)
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: buttonDimension, height:  buttonDimension)
                                    .foregroundColor(isSelectedTab ? .white: .black)
                                    .padding(isSelectedTab ? 15.0 : 0.0)
                                    .background(  Color.green.opacity(isSelectedTab ? 1 : 0).clipShape(Circle()))
                                    .matchedGeometryEffect(id: image, in: animation)
                                    .animation(Animation.linear(duration: 2.0))
                                    .offset(x: isSelectedTab ? -10 : 0, y: isSelectedTab ? -50: 0)
                                
                            }
                            else {
                                Image(systemName: image)
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: buttonDimension, height:  buttonDimension)
                                    .foregroundColor(isSelectedTab ? .white: .black)
                                    .padding(isSelectedTab ? 15.0 : 0.0)
                                    .background( Color.orange.opacity(isSelectedTab ? 1 : 0).clipShape(Circle()))
                                    .matchedGeometryEffect(id: image, in: animation)
                                    .animation(Animation.linear(duration: 2.0))
                                    .offset(x: isSelectedTab ? -10 : 0, y: isSelectedTab ? -50: 0)
                                
                                
                            }
                        })
                        .onAppear(perform: {
                            if image == tabs[1] {
                                xAxis = reader.frame(in: .global).minX
                            }
                        })
                    }
                    .frame(width: 25.0, height: 30.0)
                    if image != tabs.last { Spacer() }
                }
            }
            .padding(.horizontal, 50)
            .padding(.vertical)
            .background(Color.white.clipShape(CustomShape(xAxis: xAxis)).cornerRadius(20.0))
            .padding(.horizontal)
            // button edge
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct FloatingTabBar_Previews: PreviewProvider {
    static var previews: some View {
        FloatingTabBar()
    }
}

struct CustomShape: Shape {
    var xAxis: CGFloat
    
    // Animate path
    var animatableData: CGFloat {
        get { return xAxis }
        set { xAxis = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x:0, y:rect.height))
            
            let center = xAxis
            
            path.move(to: CGPoint(x: center - 50, y: 0))
            
            let to1 = CGPoint(x: center, y: 30)
            let control1 = CGPoint(x: center - 30, y: 0)
            let control2 = CGPoint(x: center - 30, y: 30)
            
            let to2 = CGPoint(x: center + 50, y: 0)
            let control3 = CGPoint(x: center + 30, y: 30)
            let control4 = CGPoint(x: center + 30, y: 0)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
            
        }
    }
}
