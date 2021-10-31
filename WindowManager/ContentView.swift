//
//  ContentView.swift
//  WindowManager
//
//  Created by Md Ruman Islam on 31/10/21.
//

import SwiftUI

struct ContentView: View {
    @State private var maxWidth: CGFloat = .zero
    
    var body: some View {
        VStack {
            Text(
                        """
                WindowManager need the Accessibility Permissions for resizing the window of another app. Please follow the following instructions for enabling the Accessibility Permissions.\n
                 Apple menu → System Preferences → Security & Privacy → Privacy → Accessibility → 🔒 Click the lock to make chages → Tik mark on Magent
                """
            )
                .padding()
            HStack {
                Button(action: {
                    closeWindow()
                }) {
                    Text("Close")
                        .background(rectReader($maxWidth))
                        .frame(minWidth: maxWidth)
                }
                .background(Color.gray)
                .cornerRadius(10)
                
                Button(action: {
                    guard let url = URL(string:"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") else {
                        print("url is nil")
                        return
                    }
                    
                    NSWorkspace.shared.open(url)
                    closeWindow()
                }) {
                    Text("Open Accessibility")
                        .background(rectReader($maxWidth))
                        .frame(minWidth: maxWidth)
                }
                .background(Color.white)
                .foregroundColor(.blue)
                .cornerRadius(10)
            }
            .id(maxWidth)
        }
        .frame(width: 500, height: 200)
    }
    
    private func rectReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { gp -> Color in
            DispatchQueue.main.async {
                binding.wrappedValue = max(binding.wrappedValue, gp.frame(in: .local).width)
            }
            return Color.clear
        }
    }
    
    private func closeWindow() {
        NSApplication.shared.keyWindow?.close()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

