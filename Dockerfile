# 1) Build stage
FROM node:20-alpine AS builder
WORKDIR /app

# Build arguments with default values
ARG NEXT_PUBLIC_API_BASE_URL=http://localhost:8080
ARG NEXT_PUBLIC_API_CAREER_URL=http://localhost:8000

# Set as environment variables for build
ENV NEXT_PUBLIC_API_BASE_URL=$NEXT_PUBLIC_API_BASE_URL
ENV NEXT_PUBLIC_API_CAREER_URL=$NEXT_PUBLIC_API_CAREER_URL

COPY package.json ./
RUN npm install
COPY . .
RUN npm run build

# 2) Run stage
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public
EXPOSE 3000
CMD ["node", "server.js"]