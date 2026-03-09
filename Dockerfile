# Dockerfile

# BentoPDF Environment Variables
ARG SIMPLE_MODE=true
# Default UI language (build-time)
# Supported: en, ar, be, fr, de, es, zh, zh-TW, vi, tr, id, it, pt, nl, da
ARG VITE_DEFAULT_LANGUAGE="de"
# Custom branding (build-time)
# Replace the default BentoPDF branding with your own.
# Place your logo file in the public/ folder and set the path relative to it.
ARG VITE_BRAND_NAME="arion2000.xyz PDF"
ARG VITE_BRAND_LOGO="images/logo_white_only-icon.png"
ARG VITE_FOOTER_TEXT="© 2026 arion2000.xyz Services. Alle Rechte vorbehalten."

FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
COPY . .
RUN npm ci
RUN npm run build

FROM nginxinc/nginx-unprivileged:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
