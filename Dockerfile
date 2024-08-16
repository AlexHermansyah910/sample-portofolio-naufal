# Gunakan node image sebagai base image
FROM node:16-alpine

# Tentukan direktori kerja di dalam container
WORKDIR /app

# Salin file package.json dan package-lock.json ke dalam container
COPY package*.json ./

# Install dependencies
RUN npm install

# Salin semua file dari proyek ke dalam container
COPY . .

# Build aplikasi React (opsional, jika Anda ingin menjalankan build terlebih dahulu)
# RUN npm run build

# Ekspose port yang akan digunakan oleh aplikasi
EXPOSE 3000

# Perintah untuk menjalankan aplikasi
CMD ["npm", "start"]
