//
//  EventBus.swift
//  ScoreCounter
//
//  Created by Amine Bouzahar on 26/04/2024.
//

import Foundation
import Combine

// Define the type of event to be published
enum AppEvent {
    case diceAdded
    case shakedPhone
    case diceShuffle(String,DiceRepresentationModel)
}
// Event bus to publish and listen for events
final class EventBus {
    static let shared = EventBus() // Singleton instance
    
    // A PassthroughSubject acts as a publisher for our events
    let eventPublisher = PassthroughSubject<AppEvent, Never>()
    
    // Publish an event
    func publish(event: AppEvent) {
        eventPublisher.send(event)
    }
}
