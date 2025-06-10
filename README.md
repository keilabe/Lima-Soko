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
