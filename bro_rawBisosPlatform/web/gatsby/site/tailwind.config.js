/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/pages/**/*.{js,jsx,ts,tsx}",
    "./src/components/**/*.{js,jsx,ts,tsx}",
    "./src/templates/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // ByStar brand colors
        bystar: {
          navy: "#001a4d",
          "light-mint": "#E1EBDD",
        },
        // Semantic color aliases
        primary: "#001a4d",
        secondary: "#E1EBDD",
      },
      spacing: {
        // Custom spacing scale matching your design
        xs: "8px",
        sm: "12px",
        md: "16px",
        lg: "20px",
        xl: "30px",
        xxl: "50px",
      },
    },
  },
  plugins: [],
}
