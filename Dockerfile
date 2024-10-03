# Etapa 1: Build do aplicativo
FROM node:20 AS builder

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia os arquivos de dependência e instala
COPY package*.json ./
RUN npm install

# Copia o código fonte da aplicação
COPY . .

# Executa o build da aplicação Next.js
RUN npm run build

# Etapa 2: Servir a aplicação
FROM node:20

# Define o diretório de trabalho no contêiner
WORKDIR /app

# Copia os arquivos necessários para produção
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

# Instala dependências de produção
RUN npm install --production

# Expõe a porta onde a aplicação vai rodar
EXPOSE 3000

# Inicia a aplicação
CMD ["npm", "run", "start"]
