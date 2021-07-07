//
//  ViewController.swift
//  CalendarApp
//
//  Created by ramil on 07.07.2021.
//

import UIKit
import CalendarKit
import EventKit

class ViewController: DayViewController {
    
    private let eventStore = EKEventStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Calendar"
        requestAccessToCakendar()
        subscribeToNotification()
    }

    func requestAccessToCakendar() {
        eventStore.requestAccess(to: .event) { success, error in
            
        }
    }
    
    func subscribeToNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(storeChange(_:)), name: .EKEventStoreChanged, object: nil)
    }
    
    @objc func storeChange(_ notification: Notification) {
        reloadData()
    }
    
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        let startDate = date
        var oneDayComponents = DateComponents()
        oneDayComponents.day = 1
        
        let endDate = calendar.date(byAdding: oneDayComponents, to: startDate)!
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        let eventKitEvents = eventStore.events(matching: predicate)
        
        let calendarKitEvents = eventKitEvents.map { ekEvent -> Event in
            let ckEvent = Event()
            ckEvent.startDate = ekEvent.startDate
            ckEvent.endDate = ekEvent.endDate
            ckEvent.isAllDay = ekEvent.isAllDay
            ckEvent.text = ekEvent.title
            if let eventColor = ekEvent.calendar.cgColor {
                ckEvent.color = UIColor(cgColor: eventColor)
            }
            return ckEvent
        }
        return calendarKitEvents
    }
}

