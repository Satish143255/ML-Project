import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./src/app/**/*.{ts,tsx}", "./src/components/**/*.{ts,tsx}"],
  theme: {
    extend: {
      fontFamily: {
        sans: ["var(--font-inter)", "Inter", "sans-serif"],
      },
      colors: {
        primary: "var(--primary)",
        accent: "var(--accent)",
        success: "var(--success)",
        warning: "var(--warning)",
        danger: "var(--danger)",
        bg: "var(--bg)",
        card: "var(--card)",
        border: "var(--border)",
        "text-primary": "var(--text-primary)",
        "text-secondary": "var(--text-secondary)",
        "text-muted": "var(--text-muted)",
        record: {
          lab: "#10B981",
          prescription: "#8B5CF6",
          imaging: "#3B82F6",
          surgery: "#F59E0B",
          vaccination: "#06B6D4",
          other: "#6B7280",
        },
      },
      borderRadius: {
        card: "16px",
        button: "10px",
        modal: "20px",
      },
    },
  },
  plugins: [],
};

export default config;
