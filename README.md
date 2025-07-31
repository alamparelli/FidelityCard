# DISCLAIMER
**This Company and Application are completely fictionals.**
These have been created for the purpose of Learning:
- Manage a Project E2E by collecting the requirement to a TestFlight publication.
- Build with Swift/SwiftUI

# LocalCard Solutions - Mobile Loyalty App

LocalCard Solutions is an iOS application built with SwiftUI that digitalizes paper loyalty cards for small businesses. This app allows consumers to create, manage, and use their loyalty cards directly from their smartphone.

## 🎯 Project Vision

**"Replace every paper card with a digital experience"**

The application targets end consumers and is part of a B2B ecosystem where merchants can create and manage their loyalty programs through a dedicated web platform.

## ✨ MVP Features

### Digital Stamp System
- **Add cards** via QR code or business search
- **Custom design** with each merchant's colors and identity
- **In-store validation** with unique QR code generation or 6-digit PIN code
- **Multiple stamps** : 1 to 5 stamps per transaction based on purchase
- **Automatic renewal** of completed cards

### User Interface
- **Browse without login** to discover the application
- **Login required** only for actual card usage
- **Local history** of visits and card progression
- **Automatic archiving** of completed cards with obtained rewards

## 🎨 Design & Brand Guidelines

### Application Interface
- **Primary colors** : Royal Blue (#4169E1) and Emerald Green (#50C878)
- **Style** : Clean and professional, inspired by banking applications
- **Target audience** : 25-65 years old, not necessarily tech-savvy users

### Individual Cards
- **Full customization** with merchant's colors
- **No LocalCard colors** on the cards themselves
- **Merchant logo and identity** prominently featured

## 📱 Screenshots

| Home Screen | Card Details | Add Card |
|:---:|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/9594d835-8b3c-4c08-82e7-594f4e221b3d" width="200" alt="Home screen showing loyalty cards list" /> | <img src="https://github.com/user-attachments/assets/6686a851-ebb8-4906-869b-69b57dd05754" width="200" alt="Card details with stamp progression" /> | <img src="https://github.com/user-attachments/assets/ad83c0d6-2edd-4e92-a9b7-d99b86c24763" width="200" alt="Add new card interface" /> |

| Edit Card | QR Code Validation |
|:---:|:---:|
| <img src="https://github.com/user-attachments/assets/ac73d02a-3a48-4463-a2b5-98f68cba3400" width="200" alt="Edit existing card interface" /> | <img width="200" alt="Validation screen with generated QR code" src="https://github.com/user-attachments/assets/94cd174b-ce52-411c-a387-e27937d6b010" /> |

## 🔧 Technical Architecture

### Technologies
- **Platform** : iOS (SwiftUI)
- **Backend** : LocalCard Solutions REST API (fake)
- **Storage** : Local for history and preferences

### Validation System
- **QR Code** : Complete URL to API with unique transaction_id
- **PIN Code** : 6 digits, 5-minute validity
- **Security** : Merchant-controlled, 5 stamps/transaction limit

### Transaction ID Format
```
{card_id}-{timestamp}-{security_token}
Example: ABC123DEF456-1672531200-X7K9P2M5
```

## 🚀 Installation and Development

### Requirements
- iOS 15.0+
- Xcode 14+
- SwiftUI

### Installation
```bash
git clone https://github.com/alamparelli/FidelityCard.git
cd FidelityCard
```

Open the project in Xcode and run on simulator or iOS device.

### MVP Development
- **Timeline** : 4 weeks (80 hours)
- **Deliverable** : Functional TestFlight version
- **Focus** : Stamp system only (70% of market)

## 📋 Future Features (Backlog)

- **Points system** (currently 25% of merchants)
- **Advanced reminder notifications**
- **Card sharing**
- **Complex and hybrid rewards**

## 🎯 Typical Use Cases

### Target Merchants
- **Coffee shops** : 3 coffees bought = 3 stamps
- **Bakeries** : Family purchase = 2-3 stamps based on amount
- **Hair salons** : Multiple services = 2 stamps per visit
- **Restaurants** : One visit = 1 stamp generally

### Customer Process
1. **Discover** the app without login
2. **Add** cards via QR code or search
3. **Login** to use the cards
4. **Validate** in-store with QR code or PIN
5. **Track** progress towards reward

## 👥 LocalCard Ecosystem

### Merchant Side (Fake)
- Web platform to create/configure programs
- Stamp/points validation interface
- Card design definition

### Consumer Side (This App)
- Mobile application for end customers
- Automatic connection to LocalCard API
- Optimized user experience

## 📄 License

This project is under MIT License. See the [LICENSE](LICENSE) file for more details.

## 👨‍💻 Developer

- [alamparelli](https://github.com/alamparelli)

---

**LocalCard Solutions** - Digitizing the loyalty experience for small businesses
