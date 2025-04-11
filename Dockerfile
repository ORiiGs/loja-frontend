# CONSTRUÇÃO DA APLICAÇÃO
FROM node:18-alpine AS build

# define o diretório
WORKDIR /app

# copia os arquivos das dependências
COPY package*.json ./
# instala as dependências com compatibilidade evitando conflitos de versão
RUN npm install --legacy-peer-deps

# copia o código fonte para o container
COPY . .
# configuração funcional para versoês mais recentes do node com OpenSSL 3
ENV NODE_OPTIONS=--openssl-legacy-provider
# roda o build da aplicação
RUN npm run build

# CONSTRUÇÃO DO SERVIDOR WEB
FROM nginx:stable-alpine

# copia os arquivos do estágio anterior
COPY --from=build /app/build /usr/share/nginx/html

# expoe a porta do HTTP 
EXPOSE 80
#inicia o servidor Nginx em primeiro plano
CMD ["nginx", "-g", "daemon off;"]

#Otimizado na medida do possível e com multi stage