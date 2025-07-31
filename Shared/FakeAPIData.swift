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
  "address": "12 Rue de la Paix, 75001 Paris",
  "phone": "01 42 33 44 55",
  "activity_type": "Brasserie",
  "logo_url": "https://api.localcard.com/logos/cafe-des-amis.png",
  "primary_color": "#8B4513",
  "secondary_color": "#D2691E",
  "template_id": "template_cafe",
  "stamps_required": 10,
  "reward_description": "1 café offert",
  "card_name": "Carte Fidélité Café des Amis",
  "status": "active",
  "creation_date": "2024-01-15T10:30:00Z",
  "current_stamps": 0,
  "hours": "Lun-Ven: 7h-19h, Sam: 8h-18h, Dim: 8h-17h",
  "personalized_message": "Bienvenue dans votre café de quartier !"
},
{
  "id": "GHI789JKL012",
  "name": "Boulangerie Martin",
  "address": "45 Avenue des Champs, 69002 Lyon",
  "phone": "04 78 92 15 37",
  "activity_type": "Boulangerie",
  "logo_url": "https://api.localcard.com/logos/boulangerie-martin.png",
  "primary_color": "#FFD700",
  "secondary_color": "#8B4513",
  "template_id": "template_boulangerie",
  "stamps_required": 8,
  "reward_description": "1 pâtisserie offerte",
  "card_name": "Fidélité Boulangerie Martin",
  "status": "active",
  "creation_date": "2024-02-03T14:20:00Z",
  "current_stamps": 0,
  "hours": "Mar-Sam: 6h30-19h30, Dim: 7h-13h",
  "personalized_message": "Votre boulanger artisan depuis 1952"
},
{
  "id": "MNO345PQR678",
  "name": "Salon Élégance",
  "address": "8 Boulevard Voltaire, 13001 Marseille",
  "phone": "04 91 55 28 41",
  "activity_type": "Coiffure",
  "logo_url": "https://api.localcard.com/logos/salon-elegance.png",
  "primary_color": "#FF69B4",
  "secondary_color": "#C71585",
  "template_id": "template_coiffure",
  "stamps_required": 8,
  "reward_description": "1 shampoing-coupe offert",
  "card_name": "Carte VIP Salon Élégance",
  "status": "active",
  "creation_date": "2024-01-28T11:45:00Z",
  "current_stamps": 0,
  "hours": "Mar-Sam: 9h-18h",
  "personalized_message": "Votre beauté, notre passion"
},
{
  "id": "STU901VWX234",
  "name": "Pizzeria Bella Vista",
  "address": "22 Rue du Commerce, 33000 Bordeaux",
  "phone": "05 56 48 72 91",
  "activity_type": "Restaurant",
  "logo_url": "https://api.localcard.com/logos/pizzeria-bella-vista.png",
  "primary_color": "#228B22",
  "secondary_color": "#DC143C",
  "template_id": "template_restaurant",
  "stamps_required": 12,
  "reward_description": "1 pizza margherita offerte",
  "card_name": "Fidélité Bella Vista",
  "status": "active",
  "creation_date": "2024-02-10T16:15:00Z",
  "current_stamps": 0,
  "hours": "Mar-Dim: 11h30-14h et 18h30-22h30",
  "personalized_message": "Benvenuti! La vraie pizza italienne"
},
{
  "id": "YZA567BCD890",
  "name": "Pharmacie Central",
  "address": "15 Place de la République, 59000 Lille",
  "phone": "03 20 74 85 96",
  "activity_type": "Pharmacie",
  "logo_url": "https://api.localcard.com/logos/pharmacie-central.png",
  "primary_color": "#008000",
  "secondary_color": "#808800",
  "template_id": "template_pharmacie",
  "stamps_required": 10,
  "reward_description": "5€ de réduction sur votre prochain achat",
  "card_name": "Carte Santé Central",
  "status": "active",
  "creation_date": "2024-01-22T09:30:00Z",
  "current_stamps": 0,
  "hours": "Lun-Sam: 8h30-19h30",
  "personalized_message": "Votre santé, notre priorité"
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

