# GEMINI.md - Expense Manager Context

This project is a full-stack expense management application built with Next.js, Prisma, and PostgreSQL. It features a role-based dashboard for both administrators and regular users.

## Project Overview

- **Purpose:** Manage personal or project-based expenses and incomes.
- **Main Technologies:**
    - **Frontend:** Next.js 16 (App Router), React 19, Tailwind CSS 4, Lucide React icons.
    - **Backend:** Next.js API Routes.
    - **Database:** PostgreSQL via Prisma ORM.
    - **Theming:** Dark/Light mode support using `next-themes`.
- **Architecture:**
    - **Role-Based Routing:** 
        - `/admin`: Dashboard for system-wide overview and user management.
        - `/user`: Dashboard for personal expense and income tracking.
        - `/(auth)`: Authentication routes (Login/Register).
    - **Component Structure:** Modular UI components in `components/ui`.
    - **Prisma Configuration:** Custom client generation in `generated/prisma` using a PostgreSQL adapter.

## Building and Running

### Development
```bash
npm install
npm run dev
```

### Database Setup
Ensure `DATABASE_URL` is set in your `.env` file.
```bash
npx prisma generate
npx prisma db push
```
*Note: The Prisma client is configured to be generated in `./generated/prisma`.*

### Production
```bash
npm run build
npm run start
```

## Development Conventions

- **Next.js App Router:** Use the `app` directory for routing.
- **Tailwind CSS:** Follow utility-first styling patterns.
- **UI Components:** Prefer reusing or extending components in `components/ui` (Button, Card, Input).
- **Prisma Client:** Import the singleton Prisma instance from `@/lib/prisma`.
- **Database Schema:** 
    - Tables use lowercase names (e.g., `users`, `expenses`).
    - Relationships are explicitly defined in `prisma/schema.prisma`.
- **Naming Conventions:**
    - Components: PascalCase (e.g., `Navbar.tsx`).
    - API Routes: `route.ts`.
    - Page Files: `page.tsx`.

## Key Files & Directories

- `app/`: Contains the main application routes and layouts.
- `components/`: Reusable React components.
- `lib/prisma.ts`: Prisma client initialization.
- `prisma/schema.prisma`: Database schema definition.
- `REF/`: Contains project documentation and timeline (PDF/Docx).
- `generated/`: Contains the generated Prisma client.
