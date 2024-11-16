//
//  PreviewData.swift
//  iTunesMedia
//
//  Created by Naim Choudhry on 16/11/2024.
//

import Foundation

/*
 let id: Int
 let artistName: String
 let collectionName: String
 let artistViewURL: String?
 let previewURL: String
 let artworkUrl60: String
 let artworkUrl100: String
 let collectionPrice: Double?
 let trackName: String
 let trackCount: Int
 let currency: String
 let primaryGenreName: String
 let description: String?
*/

extension MediaItem {
    init(
        id: Int,
        artistName: String,
        collectionName: String,
        artistViewURL: String?,
        previewURL: String,
        artworkUrl60: String,
        artworkUrl100: String,
        collectionPrice: Double?,
        trackName: String,
        trackCount: Int,
        currency: String,
        primaryGenreName: String,
        description: String?) {
            self.id = id
            self.artistName = artistName
            self.collectionName = collectionName
            self.artistViewURL = artistViewURL
            self.previewURL = previewURL
            self.artworkUrl60 = artworkUrl60
            self.artworkUrl100 = artworkUrl100
            self.collectionPrice = collectionPrice
            self.trackName = trackName
            self.trackCount = trackCount
            self.currency = currency
            self.primaryGenreName = primaryGenreName
            self.description = description
    }
    
    static let preview: Self = .init(
        id : 4033433412180330376,
        artistName : "Naim Choudhry",
        collectionName : "",
        artistViewURL : "https://apps.apple.com/gb/developer/naim-choudhry/id314012386?uo=4",
        previewURL : "",
        artworkUrl60 : "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/89/a2/cd/89a2cdab-a5c1-01cc-50c3-ae543629f114/AppIcon-0-0-1x_U007epad-0-1-85-220.jpeg/60x60bb.jpg",
        artworkUrl100 : "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/89/a2/cd/89a2cdab-a5c1-01cc-50c3-ae543629f114/AppIcon-0-0-1x_U007epad-0-1-85-220.jpeg/100x100bb.jpg",
        collectionPrice : nil,
        trackName : "days",
        trackCount : 0,
        currency : "GBP",
        primaryGenreName : "Productivity",
        description : """
        days, the perfect complement to Calendar - Keep track of the most important dates in your life!\n\n① If you’re tired of fishing through calendar apps to find important dates that you occasionally need, either from the distant past or the far off future, then days is for you!\n\n② If you want to see clearly the events coming up in your calendars without being shown lots of empty white boxes with entries in text so tiny you can’t even read what’s there on a given day, then days is for you!\n\n③ If you want to know how long it’s been since you left school / university, had your last hair cut, saw a doctor, had a vaccination, started your current job, left your previous job, when you bought your car, how old your television is, then days is for you!\n\n④ If you want to be reminded up to 31 days before your passport / drivers license expires, when your mortgage / loans run down, when your next medical appointment is, when you need to perform routine maintenance on your household devices, when you have to renew your subscriptions / contracts, how long to go before your vacation starts or you can retire, then days is for you!\n\n⑤ If you want a single app that keeps track of ALL the most important dates in your life, and lets you manage these in a simple and clear UI, yet provides extensive categorisation, sorting, filtering, searching, and sharing capabilities, showing how old a past event is or a countdown to when a future event will occur, then days is for you!\n\nUnlike most calendar apps which focus on events coming up in the near future, days has been designed to keep track of the most important dates in your life from the distant past to the distant future.  It manages this by seamlessly combining calendar entries with its own database to store events outside of calendar.  Use days to store distant past events such as your entire education, employment, medical history, and events off in the future like legal documents expiring, contracts running down, etc.\n\nUse days own database to store events in three broad stores:\n\n► Days Gone - Great for important dates you need to remember from the past: Medical Dates, Personal Dates, Project Milestones, Employment Dates, Education Dates, Equipment Age, Journal / Log Book\n\n► Annual - Great for annually recurring events, just enter the details once and days will always remember: Birthdays, Anniversaries, Name days, Death dates, Public Holidays, Historic Events, National Celebrations\n\n► Days To Go - Excellent as a to-do reminder store for keeping track of important dates coming up in the future:  Warranties Expiring, Membership / Subscription Renewals, Contractual Dates, Legal Documents Expiring, Bank Cards Expiring, Project Deadlines, Appointments, House Chores, Equipment Maintenance, Vacations and important Life Events\n\nFeatures\n_________\n\n► Universal app (iPad/iPhone/iPod Touch) with iCloud synch and other sharing features to transfer events between all iOS devices.\n► Local notification alerts, you choose which events you want to be alerted to and how many days before, up to 31 days for Days To Go and Annual events.\n► Instant sorting by Days-to-Go / Gone / Alphabetical - How many calendar\'s let you sort events alphabetically?\n► Instant filtering on multiple Categories / Calendars.\n► Copy entries across the lists, and to and from Calendars.\n► Powerful search feature with drill down filtering.\n► Add unlimited notes to each event, which are also checked when searching.\n► Built in date calculator.\n► Preferences to control display behaviour and set alert time.\n► Change UI Theme Colours\n► Choose from SF Symbols or Emojis to set category icons, and choose your own category colour \n► Supports Light & dark Modes with the ability to set in the app your preferred choice, and supports adaptive text for using larger text reading sizes.\n\nAll day’s events can be exported for backup, importing, or sharing.\n\nNote: Calendar events are integrated from 1 day back to 1 year forward.
        """
    )
}
