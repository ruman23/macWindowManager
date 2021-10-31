//
//  BarView.swift
//  WindowManager
//
//  Created by Md Ruman Islam on 31/10/21.
//

import SwiftUI

struct BarView: View {
    @State private var presentAlert = false
    
    var body: some View {
        VStack {
            Button(action: {
                guard let frame = NSScreen.main?.frame else {
                    print("couldn't get the screen size.")
                    return
                }
                
                setWindoSize(newPoint: frame.origin, newSize: frame.size)
            }) {
                HStack {
                    Image("maximizeTemplate")
                    Text("Full Screen")
                }
            }
            
            
            Divider()
            
            Button(action: {
                guard let frame = NSScreen.main?.frame else {
                    print("couldn't get the screen size.")
                    return
                }
                
                let newSize = CGSize(width: frame.width, height: frame.height/2)
                setWindoSize(newPoint: frame.origin, newSize: newSize)
            }) {
                HStack {
                    Image("topHalfTemplate")
                    Text("Top half")
                }
            }
            
            HStack {
                Button(action: {
                    guard let frame = NSScreen.main?.frame else {
                        print("couldn't get the screen size.")
                        return
                    }
                    
                    let newSize = CGSize(width: frame.width/2, height: frame.height)
                    setWindoSize(newPoint: frame.origin, newSize: newSize)
                }) {
                    HStack {
                        Image("leftHalfTemplate")
                        Text("Left half")
                    }
                }
                
                Button(action: {
                    guard let frame = NSScreen.main?.frame else {
                        print("couldn't get the screen size.")
                        return
                    }
                    
                    let newPoint = CGPoint(x: frame.midX, y: frame.minY)
                    let newSize = CGSize(width: frame.width/2, height: frame.height)
                    setWindoSize(newPoint: newPoint, newSize: newSize)
                }) {
                    HStack {
                        Image("rightHalfTemplate")
                        Text("Right half")
                    }
                }
            }
            
            Button(action: {
                guard let frame = NSScreen.main?.frame else {
                    print("couldn't get the screen size.")
                    return
                }
                
                let newPoint = CGPoint(x: frame.minX, y: frame.height/2)
                let newSize = CGSize(width: frame.width, height: frame.height/2)
                setWindoSize(newPoint: newPoint, newSize: newSize)
            }) {
                HStack {
                    Image("bottomHalfTemplate")
                    Text("Bottom half")
                }
            }
            
            
            Divider()
            
            HStack {
                Button(action: {
                    guard let frame = NSScreen.main?.frame else {
                        print("couldn't get the screen size.")
                        return
                    }
                    
                    let newSize = CGSize(width: frame.width/2, height: frame.height/2)
                    setWindoSize(newPoint: frame.origin, newSize: newSize)
                }) {
                    HStack {
                        Image("topLeftTemplate")
                        Text("Top Left Corner")
                    }
                }
                
                Button(action: {
                    guard let frame = NSScreen.main?.frame else {
                        print("couldn't get the screen size.")
                        return
                    }
                    
                    let newPoint = CGPoint(x: frame.midX, y: frame.minY)
                    let newSize = CGSize(width: frame.width/2, height: frame.height/2)
                    setWindoSize(newPoint: newPoint, newSize: newSize)
                }) {
                    HStack {
                        Image("topRightTemplate")
                        Text("Top Right Corner")
                    }
                }
            }
            
            HStack {
                Button(action: {
                    guard let frame = NSScreen.main?.frame else {
                        print("couldn't get the screen size.")
                        return
                    }
                    
                    let newPoint = CGPoint(x: frame.minX, y: frame.height/2)
                    let newSize = CGSize(width: frame.width/2, height: frame.height/2)
                    setWindoSize(newPoint: newPoint, newSize: newSize)
                }) {
                    HStack {
                        Image("bottomLeftTemplate")
                        Text("Bottom Left Corner")
                    }
                }
                
                Button(action: {
                    guard let frame = NSScreen.main?.frame else {
                        print("couldn't get the screen size.")
                        return
                    }
                    
                    let newPoint = CGPoint(x: frame.midX, y: frame.height/2)
                    let newSize = CGSize(width: frame.width/2, height: frame.height/2)
                    setWindoSize(newPoint: newPoint, newSize: newSize)
                }) {
                    HStack {
                        Image("bottomRightTemplate")
                        Text("Bottom Right Corner")
                    }
                }
            }
        }
        .frame(width: 400, height: 200)
        .cornerRadius(22)
        .alert(isPresented: $presentAlert) {
            Alert(
                title: Text("Need Accessibility Permissions"),
                message: Text(
                    """
WindowManager need the Accessibility Permissions for resizing the window of another app. Please follow the following instructions for enabling the Accessibility Permissions.\n
 Apple menu → System Preferences → Security & Privacy → Privacy → Accessibility → 🔒 Click the lock to make chages → Tik mark on Magent
"""
                ),
                primaryButton: .default(Text("Open Accessibility")) {
                    NSWorkspace.shared.open(URL(string:"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
                },
                secondaryButton: .cancel()
            )
        }.padding()
    }
    
    private func setWindoSize(
        newPoint: CGPoint,
        newSize: CGSize
    ) {
        print("set window size \(newSize)")
        let options = CGWindowListOption(arrayLiteral: .excludeDesktopElements, .optionOnScreenOnly)
        let windowsListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
        guard let infoList = windowsListInfo as? [[String:Any]] else {
            print("infoList is nil")
            return
        }
        let windowList = infoList.filter{ $0["kCGWindowLayer"] as! Int == 0 }
        
        
        guard let entry = windowList.first else {
            print("entry is nil")
            return
        }
        
        guard let owner = entry[kCGWindowOwnerName as String] as? String else {
            print("owner is nil")
            return
        }
        
        guard let pid = entry[kCGWindowOwnerPID as String] as? Int32 else {
            print("pid is nil")
            return
        }
        
        print("owner: \(owner)")
        
        let appRef = AXUIElementCreateApplication(pid)
        
        var value: AnyObject?
        let result = AXUIElementCopyAttributeValue(appRef, kAXWindowsAttribute as CFString, &value)
        
        print(result.rawValue)
        
        guard let windowList = value as? [AXUIElement] else {
            print("windowList is nil")
            presentAlert = true
            return
        }
        
        print ("windowList #\(windowList)")
        guard let firstWindow = windowList.first else {
            print("first window is missing")
            return
        }
        
        guard let axValuePoint = AXValueType(rawValue: kAXValueCGPointType) else {
            print("axValue is nil")
            return
        }
        
        var newPoint = newPoint
        
        guard let axValuePosition = AXValueCreate(axValuePoint, &newPoint) else {
            print("position is nil")
            return
        }
        
        AXUIElementSetAttributeValue(firstWindow, kAXPositionAttribute as CFString, axValuePosition)
        
        guard let axValueCGSize = AXValueType(rawValue: kAXValueCGSizeType) else {
            print("axValueCGSize is nil")
            return
        }
        
        var newSize = newSize
        
        guard let axValueSize = AXValueCreate(axValueCGSize, &newSize) else {
            print("size is nil")
            return
        }
        
        AXUIElementSetAttributeValue(firstWindow, kAXSizeAttribute as CFString, axValueSize)
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView()
    }
}
