# Lima Soko

A Flutter application for agricultural marketplace.

## Environment Setup

To run this project, you need to set up your environment variables. Create a `.env` file in the root directory of the project with the following variables:

```env
# Supabase Configuration
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# M-Pesa Configuration
MPESA_BASE_URL=https://sandbox.safaricom.co.ke/
MPESA_CONSUMER_KEY=your_mpesa_consumer_key
MPESA_CONSUMER_SECRET=your_mpesa_consumer_secret
MPESA_SHORTCODE=174379
MPESA_PASSKEY=your_mpesa_passkey
MPESA_CALLBACK_URL=your_callback_url
```

### How to Generate Your Own Values:

1. **Supabase Configuration**:
   - Create your own project on [Supabase](https://supabase.com)
   - Go to Project Settings > API
   - Copy your `Project URL` and `anon public` key
   - Replace `your_supabase_project_url` and `your_supabase_anon_key` with your actual values

2. **M-Pesa Configuration**:
   - Register for your own Safaricom Developer account at [Safaricom Developer Portal](https://developer.safaricom.co.ke/)
   - Create your own app to get your Consumer Key and Consumer Secret
   - Replace `your_mpesa_consumer_key` and `your_mpesa_consumer_secret` with your actual values
   - The Shortcode (174379) is for sandbox testing. For production, you'll need your own Shortcode from Safaricom
   - Generate your own Passkey from your Safaricom Developer account
   - Set up your own callback URL for your application
   - Replace `your_mpesa_passkey` and `your_callback_url` with your actual values

### Important Notes:
- Never commit your `.env` file to version control
- Keep your API keys and secrets secure
- The M-Pesa configuration uses sandbox URLs by default. For production, you'll need to update the `MPESA_BASE_URL` to the production URL
- Each developer needs to generate their own unique values - do not share or reuse these credentials

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Application Flow Diagram

Below is a Mermaid diagram describing the application flow, including authentication, user roles, buyer/farmer flows, and integration with Supabase, M-Pesa API, and Edge Functions:

```mermaid
graph TD
    A[Start Application] --> B{Authentication}
    B --> C(Login)
    B --> D(Sign Up)

    C --> E{Session Validated}
    D --> E

    E --> F{Check User Role}
    F --> F1(Buyer Role)
    F --> F2(Farmer Role)

    F1 --> G[Buyer Homepage / Home Page]
    G --> G1[Browse Marketplace]
    G --> G2[Manage Cart]
    G --> G3[Checkout]

    G1 --> H[Product Details]
    H --> G2
    G2 --> G3
    G3 --> I{Initiate M-Pesa Payment}
    I --> J[M-Pesa STK Push on User Phone]
    J --> K{M-Pesa Callback Edge Function}
    K --> L[Update Payment Status in Database]
    L --> M[Order Confirmation / Receipt]
    M --> N[Clear Cart & Navigate]

    F2 --> O[Farmer Homepage / Farmer Dashboard]
    O --> O1[Manage Products]
    O1 --> P[Add/Update/Delete Products]

    subgraph Core Features
        DB[(Supabase Database)]
        ENV[.env Configuration]
        API[M-Pesa API]
        EF[Supabase Edge Functions]
    end

    G1 --> DB
    G2 --> DB
    G3 --> DB
    O1 --> DB
    P --> DB

    I --> API
    API --> J
    J --> K
    K --> DB
    K --> API

    DB --> F
    ENV --> API
    ENV --> EF

    style A fill:#f9f,stroke:#333,stroke-width:2px
    style B fill:#bbf,stroke:#333,stroke-width:2px
    style C fill:#add8e6,stroke:#333,stroke-width:1px
    style D fill:#add8e6,stroke:#333,stroke-width:1px
    style E fill:#bbf,stroke:#333,stroke-width:2px
    style F fill:#bbf,stroke:#333,stroke-width:2px
    style F1 fill:#90ee90,stroke:#333,stroke-width:1px
    style F2 fill:#ffb6c1,stroke:#333,stroke-width:1px
    style G fill:#90ee90,stroke:#333,stroke-width:2px
    style G1 fill:#c8e6c9,stroke:#333,stroke-width:1px
    style G2 fill:#c8e6c9,stroke:#333,stroke-width:1px
    style G3 fill:#c8e6c9,stroke:#333,stroke-width:1px
    style H fill:#e6e6fa,stroke:#333,stroke-width:1px
    style I fill:#ffd700,stroke:#333,stroke-width:2px
    style J fill:#f5deb3,stroke:#333,stroke-width:1px
    style K fill:#d8bfd8,stroke:#333,stroke-width:2px
    style L fill:#d8bfd8,stroke:#333,stroke-width:1px
    style M fill:#e0ffff,stroke:#333,stroke-width:1px
    style N fill:#e0ffff,stroke:#333,stroke-width:1px
    style O fill:#ffb6c1,stroke:#333,stroke-width:2px
    style O1 fill:#f5deb3,stroke:#333,stroke-width:1px
    style P fill:#f5deb3,stroke:#333,stroke-width:1px
    style DB fill:#c0c0c0,stroke:#333,stroke-width:1px
    style ENV fill:#c0c0c0,stroke:#333,stroke-width:1px
    style API fill:#c0c0c0,stroke:#333,stroke-width:1px
    style EF fill:#c0c0c0,stroke:#333,stroke-width:1px
