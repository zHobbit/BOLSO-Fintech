# Bolso — Dashboard Fintech 💚

Tela de **Dashboard** de uma fintech fictícia chamada **Bolso**, desenvolvida com **HTML**, **CSS** e **Tailwind CSS**. Projeto acadêmico da FIAP (Fase 3 — desenvolvimento das telas a partir do protótipo da Fase 2).

> Identidade visual **Dark + Neon**: verde esmeralda e lime sobre fundo escuro (OLED).

## ✨ Recursos

- **Cartão estilizado** com o saldo (assinatura visual da marca)
- Cards de **Receitas** e **Despesas** do mês
- **Ações rápidas** (Transferir, Pagar, Depositar, Câmbio, Histórico)
- Tabela de **Transações Recentes** com ícones por categoria
- Gráfico de **Evolução Financeira** (6 meses) com grade, tooltips no hover e animação escalonada
- **Totalmente responsivo** (menu lateral vira gaveta no mobile)
- **Animações** puras de CSS/Tailwind (sem JavaScript)
- Cuidados de **acessibilidade**: contraste, foco visível, `prefers-reduced-motion`, tabela alternativa para leitores de tela

## 🛠️ Tecnologias

- HTML5 semântico
- CSS3 (arquivo `styles.css` separado)
- [Tailwind CSS](https://tailwindcss.com/) (via CDN)
- Fontes: [Space Grotesk](https://fonts.google.com/specimen/Space+Grotesk) + [DM Sans](https://fonts.google.com/specimen/DM+Sans)
- Ícones: [Tabler Icons](https://tabler.io/icons)

## 🚀 Como executar

Basta abrir o arquivo **`index.html`** no navegador (duplo-clique). Não precisa instalar nada — o Tailwind é carregado via CDN.

## 📁 Estrutura

```
.
├── index.html          # Tela do Dashboard
├── styles.css          # Estilos personalizados (separados do HTML)
├── design-system.html  # Guia de identidade visual (paleta, tipografia, componentes)
├── images/             # Imagens locais (avatar do usuário)
└── README.md
```

> As imagens ficam na pasta `images/` (caminhos relativos), garantindo que o projeto
> abra corretamente em qualquer máquina, mesmo sem internet.

## 👨‍💻 Autor

Victor Holanda — RM571263 · FIAP
