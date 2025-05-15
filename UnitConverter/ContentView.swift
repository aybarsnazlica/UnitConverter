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
            .font(.largeTitle)
            .bold()
            .foregroundStyle(.gray)
    }
}

extension View {
    func prominent() -> some View {
        modifier(ProminentTitle())
    }
}

struct ContentView: View {
    @State private var input = 1000.0
    @State private var inputUnit: Dimension = UnitLength.meters
    @State private var outputUnit: Dimension = UnitLength.kilometers
    @State private var selectedConversion = "Distance"

    @FocusState private var inputIsFocused: Bool

    let unitTypes: [String: [Dimension]] = [
        "Distance": [
            UnitLength.feet,
            UnitLength.kilometers,
            UnitLength.meters,
            UnitLength.miles,
            UnitLength.yards
        ],
        "Mass": [
            UnitMass.grams,
            UnitMass.kilograms,
            UnitMass.ounces,
            UnitMass.pounds
        ],
        "Temperature": [
            UnitTemperature.celsius,
            UnitTemperature.fahrenheit,
            UnitTemperature.kelvin
        ],
        "Time": [
            UnitDuration.hours,
            UnitDuration.minutes,
            UnitDuration.seconds
        ]
    ]

    let formatter: MeasurementFormatter

    var result: String {
        let inputMeasurement = Measurement(value: input, unit: inputUnit)
        let outputMeasurement = inputMeasurement.converted(to: outputUnit)
        return formatter.string(from: outputMeasurement)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Amount to convert") {
                    TextField("Amount", value: $input, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputIsFocused)
                }

                Picker("Conversion", selection: $selectedConversion) {
                    ForEach([String](unitTypes.keys), id: \.self) {
                        Text($0)
                    }
                }

                if let units = unitTypes[selectedConversion] {
                    Picker("Convert from", selection: $inputUnit) {
                        ForEach(units, id: \.self) {
                            Text(formatter.string(from: $0).capitalized)
                        }
                    }

                    Picker("Convert to", selection: $outputUnit) {
                        ForEach(units, id: \.self) {
                            Text(formatter.string(from: $0).capitalized)
                        }
                    }
                }

                Section("Result") {
                    Text(result)
                        .prominent()
                }
                
            }
            .navigationTitle("Converter")
            .toolbar {
                if inputIsFocused {
                    Button("Done") {
                        inputIsFocused = false
                    }
                }
            }
            .onChange(of: selectedConversion) {
                if let units = unitTypes[selectedConversion] {
                    inputUnit = units[0]
                    outputUnit = units[1]
                }
            }
        }
    }

    init() {
        formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .long
    }
}

#Preview {
    ContentView()
}
