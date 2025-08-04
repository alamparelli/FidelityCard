//
//  FakeAPI.swift
//  fidelityApp
//
//  Created by Alessandro LAMPARELLI on 24/07/2025.
//

import Foundation

let fakeAPIResponse = """
[
{
  "id": "ABC123DEF456",
  "name": "Café des Amis",
  "address": "12 Peace Street, 75001 Paris",
  "phone": "01 42 33 44 55",
  "activity_type": "Brasserie",
  "logo_url": "https://api.localcard.com/logos/cafe-des-amis.png",
  "primary_color": "#8B4513",
  "secondary_color": "#D2691E",
  "template_id": "template_cafe",
  "stamps_required": 10,
  "reward_description": "1 free coffee",
  "card_name": "Café des Amis Loyalty Card",
  "status": "active",
  "creation_date": "2024-01-15T10:30:00Z",
  "current_stamps": 0,
  "hours": "Mon-Fri: 7am-7pm, Sat: 8am-6pm, Sun: 8am-5pm",
  "personalized_message": "Welcome to your neighborhood café!"
},
{
  "id": "GHI789JKL012",
  "name": "Martin Bakery",
  "address": "45 Champs Avenue, 69002 Lyon",
  "phone": "04 78 92 15 37",
  "activity_type": "Bakery",
  "logo_url": "https://api.localcard.com/logos/boulangerie-martin.png",
  "primary_color": "#FFD700",
  "secondary_color": "#8B4513",
  "template_id": "template_bakery",
  "stamps_required": 8,
  "reward_description": "1 free pastry",
  "card_name": "Martin Bakery Loyalty",
  "status": "active",
  "creation_date": "2024-02-03T14:20:00Z",
  "current_stamps": 0,
  "hours": "Tue-Sat: 6:30am-7:30pm, Sun: 7am-1pm",
  "personalized_message": "Your artisan baker since 1952"
},
{
  "id": "MNO345PQR678",
  "name": "Elegance Salon",
  "address": "8 Voltaire Boulevard, 13001 Marseille",
  "phone": "04 91 55 28 41",
  "activity_type": "Hair Salon",
  "logo_url": "https://api.localcard.com/logos/salon-elegance.png",
  "primary_color": "#FF69B4",
  "secondary_color": "#C71585",
  "template_id": "template_hairdresser",
  "stamps_required": 8,
  "reward_description": "1 free shampoo & cut",
  "card_name": "Elegance Salon VIP Card",
  "status": "active",
  "creation_date": "2024-01-28T11:45:00Z",
  "current_stamps": 0,
  "hours": "Tue-Sat: 9am-6pm",
  "personalized_message": "Your beauty, our passion"
},
{
  "id": "STU901VWX234",
  "name": "Pizzeria Bella Vista",
  "address": "22 Commerce Street, 33000 Bordeaux",
  "phone": "05 56 48 72 91",
  "activity_type": "Restaurant",
  "logo_url": "https://api.localcard.com/logos/pizzeria-bella-vista.png",
  "primary_color": "#228B22",
  "secondary_color": "#DC143C",
  "template_id": "template_restaurant",
  "stamps_required": 12,
  "reward_description": "1 free margherita pizza",
  "card_name": "Bella Vista Loyalty",
  "status": "active",
  "creation_date": "2024-02-10T16:15:00Z",
  "current_stamps": 0,
  "hours": "Tue-Sun: 11:30am-2pm & 6:30pm-10:30pm",
  "personalized_message": "Benvenuti! Authentic Italian pizza"
},
{
  "id": "YZA567BCD890",
  "name": "Central Pharmacy",
  "address": "15 Republic Square, 59000 Lille",
  "phone": "03 20 74 85 96",
  "activity_type": "Pharmacy",
  "logo_url": "https://api.localcard.com/logos/pharmacie-central.png",
  "primary_color": "#008000",
  "secondary_color": "#808800",
  "template_id": "template_pharmacy",
  "stamps_required": 10,
  "reward_description": "€5 discount on your next purchase",
  "card_name": "Central Health Card",
  "status": "active",
  "creation_date": "2024-01-22T09:30:00Z",
  "current_stamps": 0,
  "hours": "Mon-Sat: 8:30am-7:30pm",
  "personalized_message": "Your health, our priority"
}
]
"""

struct StoreCards: Decodable {

    let id: String
    let activity_type : String
    let status: String
    let template_id: String
    let name: String
    let primary_color: String
    let secondary_color: String
    let address: String
    let phone: String
    let logo_url: String
    let stamps_required: Int
    let reward_description: String
    let card_name: String
    let hours: String
    let personalized_message: String
}


let apiDatas = fakeAPIResponse.data(using: .utf8)!
let availableStoreFidelityCards: [StoreCards] = try! JSONDecoder().decode([StoreCards].self, from: apiDatas)

