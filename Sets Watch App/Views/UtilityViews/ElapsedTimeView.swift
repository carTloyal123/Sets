//
//  ElapsedTimeView.swift
//  Sets Watch App
//
//  Created by Carson Loyal on 6/4/24.
//

import SwiftUI

struct ElapsedTimeView: View {
    var elapsedTime: TimeInterval = 0
    var showSubseconds: Bool = false
    @State private var timeFormatter = ElapsedTimeFormatter()
    
    var body: some View {
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .onChange(of: showSubseconds, { oldValue, newValue in
                timeFormatter.showSubseconds = newValue
                Log.logger.debug("show sub changed: \(newValue)")

            })
            .onAppear(perform: {
                timeFormatter.showSubseconds = showSubseconds
                Log.logger.debug("show sub: \(showSubseconds)")
            })
    }
}

class ElapsedTimeFormatter: Formatter {
    var showSubseconds = false

    init(showSubseconds: Bool = false) {
        super.init()
        self.showSubseconds = showSubseconds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let componentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()

    override func string(for value: Any?) -> String? {
        guard let time = value as? TimeInterval else {
            return nil
        }

        guard let formattedString = componentsFormatter.string(from: time) else {
            return nil
        }

        if showSubseconds {
            let hundredths = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            return String(format: "%@%@%0.2d", formattedString, decimalSeparator, hundredths)
        }

        return formattedString
    }
}

#Preview {
    ElapsedTimeView(showSubseconds: true)
}
