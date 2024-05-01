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
                case .diceShuffled(_,_):
                    let newEmojis = "\(randomEmoji())\(randomEmoji())"
                    self.emojiText = newEmojis
                    break
                default:
                    break
                }
            }
            .store(in: &cancellables) // Store the subscription to keep it active
    }

   
}

struct DiceActionBarView: View {
    @ObservedObject var viewModel = DiceActionBarModel() // Observed object
    @State var presentSettings: Bool = false
    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    presentSettings.toggle()
                }){
                    Text("1d6").font(.custom("Oswald-Bold", size: 20))
                }
                .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                Spacer()
                Button(action:{
                    EventBus.shared.publish(event: .shuffleDiceAction)
                }){
                    Text(viewModel.emojiText)
                }.padding()
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Spacer()
                Button(action:{
                    presentSettings.toggle()
                }){
                    Image(systemName: "gearshape")
                        .imageScale(.large)
                        
                }.padding()
                    .clipShape(RoundedRectangle(cornerRadius: 5))
               
            }
        }.padding(0.0)
        .background(SettingsController.shared.backgroundColor)
        .foregroundColor(SettingsController.shared.textColor)
        .sheet(isPresented: $presentSettings, content: {
            DiceSettingsView(isPresented: $presentSettings)
        })
    }
}

#Preview {
    DiceActionBarView() // Testing SwiftUI preview with new setup
}
