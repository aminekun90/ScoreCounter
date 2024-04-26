import SwiftUI
import Combine

// Separate class to handle Combine subscriptions
class DiceActionBarModel: ObservableObject {
    // Published state variable to track emojiText
    @Published var emojiText: String = "😃😄"
    private var cancellables = Set<AnyCancellable>() // Combine subscription storage

    init() {
        EventBus.shared.eventPublisher
            .sink { [weak self] event in
                guard let self = self else { return }

                // Handle events without capturing `self` directly
                switch event {
                case .diceShuffle(let message, let dice):
                    let newEmojis = "\(self.randomEmoji())\(self.randomEmoji())"
                    self.emojiText = newEmojis
                    print("Event received:", dice.side, message)
                    print("Updated emojiText:", self.emojiText)

                default:
                    break
                }
            }
            .store(in: &cancellables) // Store the subscription to keep it active
    }

    func randomEmoji() -> String {
        let emojiRanges: [ClosedRange<UInt32>] = [
            0x1F600...0x1F64F,   // Emoticons
            //0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            //0x1F680...0x1F6FF, // Transport and Map
            //0x1F1E6...0x1F1FF, // Regional country flags
            //0x2600...0x26FF,   // Misc symbols 9728 - 9983
            //0x2700...0x27BF,   // Dingbats
            //0xFE00...0xFE0F,   // Variation Selectors
            //0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs 129280 - 129535
            //0x1F018...0x1F270, // Various asian characters           127000...127600
            //65024...65039,     // Variation selector
            //9100...9300,       // Misc items
            //8400...8447        // other
        ]

        let randomRange = emojiRanges.randomElement()!
        let randomCode = UInt32.random(in: randomRange)
        return String(UnicodeScalar(randomCode)!)
    }
}

struct DiceActionBarView: View {
    @ObservedObject var viewModel = DiceActionBarModel() // Observed object

    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    print("Dice type clicked")
                }){
                    Text("1d6").font(.custom("Oswald-Bold", size: 20))
                }
                .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                Spacer()
                Button(action:{
                    print("emoji clicked")
                }){
                    Text(viewModel.emojiText)
                }.padding()
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Spacer()
                Button(action:{
                    print("Settings clicked")
                }){
                    Image(systemName: "gearshape")
                        .imageScale(.large)
                        
                }.padding()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
               
            }
        }.padding(0.0)
        .background(SettingsController.shared.backgroundColor)
        .foregroundColor(SettingsController.shared.textColor)
    }
}

#Preview {
    DiceActionBarView() // Testing SwiftUI preview with new setup
}
