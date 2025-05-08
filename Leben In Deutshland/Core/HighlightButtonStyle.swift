//
//  HighlightButtonStyle.swift
//  Leben In Deutshland
//
//  Created by Hassaan Ahmed on 07.05.25.
//

import SwiftUI

struct HighlightButtonStyle: ButtonStyle {
    var backgroundColor: Color = .blue
    var pressedBackgroundColor: Color = .blue.opacity(0.8)

    var foregroundColor: Color = .white
    var pressedForegroundColor: Color = .white.opacity(0.6)
    
    var defaultPadding: EdgeInsets = EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(defaultPadding)
            .foregroundColor(configuration.isPressed ? pressedForegroundColor : foregroundColor)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(configuration.isPressed ? pressedBackgroundColor : backgroundColor)
                    .shadow(color: Color.black.opacity(0.4), radius: 5, x: 2, y: 4)
            )
            .brightness(configuration.isPressed ? -0.2 : 0.0)
    }
}

