//
//  ConfirmCancelView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 5/13/24.
//

import SwiftUI

struct ConfirmCancelView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var save_action: (() -> Void)
    var discard_action: (() -> Void)
    
    var body: some View {
        ScrollView
        {
            VStack(alignment: .center)
            {
                Text("Warning: Unsaved Changes")
                    .multilineTextAlignment(.center)

                Text("Are you sure you want to cancel?")
                    .multilineTextAlignment(.center)
                    .opacity(0.8)
                
                Button {
                    dismiss()
                    save_action()
                } label: {
                    Text("Save and Continue")
                }
                
                Button(role: .destructive) {
                    dismiss()
                    discard_action()
                } label: {
                    Text("Discard Changes")
                }
                
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                }
                .scaleEffect(CGSize(width: 0.8, height: 0.8))
            }
        }
    }
}

#Preview {
    
    let myClosure: () -> Void = {
        print("Hello, Lambda!")
    }
    
    let myClosure2: () -> Void = {
        print("Hello, Cancel!")
    }
    
    return ConfirmCancelView(save_action: myClosure, discard_action: myClosure2)
}
