//
//  DiceSettingsView.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 28/04/2024.
//

import SwiftUI
struct SimpleValueId{
    let id = UUID()
    let value: String
}
struct DiceButtonsView: View {
    @Binding var dicesSidesLabel:[SimpleValueId]
    @Binding var numberOfDices:Int
    @Binding var numberOfDicesSides:Int
    var closeDiceSettings: () -> Void

    var body: some View {
        HStack {
            ForEach(dicesSidesLabel, id: \.id) { label in
                Button(action: {
                    print("Button \(label.value) pressed")
                    
                    if label.value.range(of: "x",options:.caseInsensitive) != nil {
                        // to do display an input to use it
                    }else{
                        numberOfDices = Int(label.value) ?? 1
                        numberOfDicesSides = Int(label.value) ?? 6
                        EventBus.shared.publish(event: .updateDices( numberOfDicesSides, numberOfDices))
                    }
                    closeDiceSettings()
                    
                    
                }) {
                    Text(label.value)
                        .font(.custom("Oswald-Bold", size: 20))
                        .padding()
                        .frame(width: 70, height: 50)
                        .background(.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }.buttonStyle(BorderlessButtonStyle())
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct DiceSettingsView: View {
    @Binding var isPresented: Bool
    @State var numberOfDices:Int = 1
    @State var numberOfDicesSides:Int = 6
    @State var enableShakeToRoll: Bool = true
    @State var enableSound: Bool = true
    @State var dicesNumberLabel = [
        SimpleValueId(value: "1"),
        SimpleValueId(value:"2"),
        SimpleValueId(value:"4"),
        SimpleValueId(value:"5"),
        SimpleValueId(value:"X")
    ]
    @State var dicesSidesLabel = [
        SimpleValueId(value:"D6"),
        SimpleValueId(value:"D8"),
        SimpleValueId(value:"D12"),
        SimpleValueId(value:"D20"),
        SimpleValueId(value:"DX")
    ]
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Settings")) {
                    DiceButtonsView(dicesSidesLabel: $dicesNumberLabel,numberOfDices: $numberOfDices,numberOfDicesSides: $numberOfDicesSides, closeDiceSettings:{
                        isPresented.toggle()
                    })
                    HStack(alignment:.center){
                        Text("X")
                            .font(.custom("Oswald-Bold", size: 20))
                            .foregroundStyle(.orange)
                        
                    }.frame(maxWidth: .infinity)
                    DiceButtonsView(dicesSidesLabel: $dicesSidesLabel, numberOfDices: $numberOfDices,numberOfDicesSides: $numberOfDicesSides,closeDiceSettings:{
                        isPresented.toggle()
                    })
                    Toggle("Shake to roll", isOn: $enableShakeToRoll)
                    Toggle("Play sound", isOn: $enableSound)
                }
            }
            .navigationTitle("Edit Dice")
            .navigationBarItems(
                leading: Button("Cancel") {
                    isPresented = false
                },
                
                trailing: Button("Save") {
                    //Todo: add database save
                    isPresented = false
                    
                }
            )
        }
    }
}


struct DiceSettingsView_Previews: PreviewProvider {
    @State static var presented = true
    static var previews: some View {
        DiceSettingsView(isPresented: $presented)
    }
}
