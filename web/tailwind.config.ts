import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        avine: {
          yellow: "#FFD100",
          green: "#005A24",
          lime: "#4C9E45",
          orange: "#FF8C00",
          charcoal: "#0F2A1B",
          cream: "#FFF9E5",
          mist: "#F4F4EF",
          stone: "#3D4B40",
        },
      },
      boxShadow: {
        brand: "0 12px 30px -12px rgba(0, 90, 36, 0.25)",
      },
      borderRadius: {
        xl: "1.25rem",
      },
      fontFamily: {
        sans: ["var(--font-roboto)", "system-ui", "sans-serif"],
      },
    },
  },
  plugins: [],
};

export default config;
