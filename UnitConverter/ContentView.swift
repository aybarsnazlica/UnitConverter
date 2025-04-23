//
//  ContentView.swift
//  UnitConverter
//
//  Created by Aybars Nazlica on 2025/03/04.
//

import SwiftUI

struct ProminentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .bold()
            .foregroundStyle(.blue)
    }
}

extension View {
    func prominent() -> some View {
        modifier(ProminentTitle())
    }
}

struct ContentView: View {
    @State private var input: Double = 0
    @State private var inputUnit = ""
    @State private var outputUnit = ""
    
    @FocusState private var isFocused: Bool
    
    let conversionUnits = ["second", "minute", "hour", "day"]
    
    var inputMultiplier: Double {
        switch inputUnit {
        case "second":
            return 1
        case "minute":
            return 60
        case "hour":
            return 3600
        case "day":
            return 86400
        default:
            return 1
        }
    }
    
    var outputMultiplier: Double {
        switch outputUnit {
        case "second":
            return 1
        case "minute":
            return 60
        case "hour":
            return 3600
        case "day":
            return 86400
        default:
            return 1
        }
    }
    
    var outputValue: Double {
        let baseValue = input * inputMultiplier
        return baseValue / outputMultiplier
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Value to convert") {
                    TextField("Input", value: $input, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                }
                Section {
                    Picker("Input Unit", selection: $inputUnit) {
                        ForEach(conversionUnits, id: \.self) { unit in
                            Text(unit)
                        }
                    }
                    
                    Picker("Output Unit", selection: $outputUnit) {
                        ForEach(conversionUnits, id: \.self) { unit in
                            Text(unit)
                        }
                    }
                }
                Section("Output") {
                    Text(outputValue.formatted())
                        .prominent()
                }
            }
            .navigationTitle("UnitConverter")
            .toolbar {
                if isFocused {
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        }
    }
}
    
    
    
#Preview {
    ContentView()
}
