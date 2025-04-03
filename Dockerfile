# syntax=docker/dockerfile:1

# Etap 1: Klonowanie repozytorium przez SSH
FROM alpine/git AS repo

RUN mkdir -p /root/.ssh && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN --mount=type=ssh git clone git@github.com:JuliaGrze/pawcho6.git /repo

# Etap 2: Budowanie aplikacji Node.js (kod z repozytorium)
FROM node:18-alpine AS builder

WORKDIR /app
COPY --from=repo /repo/index.js .
COPY --from=repo /repo/package.json .

# Etap 3: Uruchamianie aplikacji Node.js
FROM node:18-alpine

# Ustawienie zmiennej środowiskowej dla wersji aplikacji
ARG VERSION
ENV VERSION=${VERSION}

# Kopiowanie aplikacji z etapu builder
COPY --from=builder /app /app

# Instalacja zależności, jeśli istnieją
WORKDIR /app
RUN npm install

EXPOSE 80

# Dodanie HEALTHCHECK - sprawdzanie dostępności strony głównej
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

# Uruchomienie aplikacji
CMD ["node", "index.js"]
