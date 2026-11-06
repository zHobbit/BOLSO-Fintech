# 💚 Bolso: Fintech Dashboard

The **dashboard** screen of **Bolso**, a fictional fintech, built with **HTML**, **CSS** and **Tailwind CSS**. An academic project at FIAP (Phase 3: building the screens from the Phase 2 prototype).

> Visual identity: **Dark + Neon**, emerald green and lime on a dark (OLED) background.

## ✨ Technologies

- Semantic `HTML5`
- `CSS3` (separate `styles.css`)
- [`Tailwind CSS`](https://tailwindcss.com/) (via CDN)
- Fonts: [Space Grotesk](https://fonts.google.com/specimen/Space+Grotesk) + [DM Sans](https://fonts.google.com/specimen/DM+Sans)
- Icons: [Tabler Icons](https://tabler.io/icons)

## 🚀 Features

- **Styled card** - Shows the balance, the brand's visual signature
- **Income & expenses** - Monthly summary cards
- **Quick actions** - Transfer, Pay, Deposit, Exchange, History
- **Recent transactions** - Table with an icon per category
- **Financial evolution chart** - 6 months, with a grid, hover tooltips and staggered animation
- **Fully responsive** - The sidebar turns into a drawer on mobile
- **CSS-only animations** - Pure CSS/Tailwind, no JavaScript
- **Accessibility** - Contrast, visible focus, `prefers-reduced-motion` and an alternative table for screen readers

## 📍 The Process

The goal of this phase was turning a static prototype into a real, responsive screen. I documented the visual identity first, in `design-system.html` (palette, typography and components), so every element on the dashboard pulls from the same tokens. I kept all the animations in CSS on purpose, and the chart got an accessible table alternative so screen readers get the same data the visual shows.

## 🎯 Structure

```
.
├── index.html          # Dashboard screen
├── styles.css          # Custom styles (separate from the HTML)
├── design-system.html  # Visual identity guide (palette, typography, components)
├── images/             # Local images (user avatar)
└── README.md
```

> Images live in `images/` with relative paths, so the project opens correctly on any machine, even offline.

## 🚦 Running the Project

Open **`index.html`** in your browser (double-click). Nothing to install: Tailwind loads from a CDN.

## 🎞️ Preview

<!-- TODO: add a screenshot of the dashboard -->

## 👤 Author

Victor Holanda · FIAP
