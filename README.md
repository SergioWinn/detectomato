# 🍅 Detectomato – Aplikasi Deteksi Penyakit Daun Tomat Berbasis CNN

**Detectomato** adalah aplikasi mobile yang dikembangkan menggunakan Flutter dan Dart, yang berfungsi untuk mendeteksi penyakit daun pada tanaman tomat secara otomatis. Aplikasi ini memanfaatkan teknologi **Convolutional Neural Network (CNN)** dengan arsitektur **ResNet50**, dan telah dioptimasi menggunakan **TensorFlow Lite** agar dapat berjalan langsung di perangkat Android secara offline.

---

## 🔍 Fitur Utama

- 📸 Mengambil gambar atau mengunggah foto daun tomat
- 🧠 Prediksi otomatis terhadap 12 jenis penyakit daun
- 📊 Menampilkan riwayat hasil deteksi
- 👤 Autentikasi pengguna (sign up, sign in, sign out)
- 📝 Formulir dukungan dan masukan (support & feedback)
- 💾 Penyimpanan backend menggunakan **Supabase**

---

## 💡 Teknologi yang Digunakan

| Teknologi       | Deskripsi                                          |
|-----------------|----------------------------------------------------|
| Flutter         | Framework pengembangan aplikasi mobile             |
| Dart            | Bahasa pemrograman utama                           |
| TensorFlow Lite | Model klasifikasi citra berjalan di perangkat      |
| Supabase        | Layanan backend open-source (PostgreSQL, API)      |
| ResNet50        | CNN arsitektur untuk klasifikasi penyakit daun     |
| Kaggle Dataset  | Dataset pelatihan model AI                         |

---

## 🧠 Tentang Model AI

Model CNN dikembangkan dan dilatih menggunakan dataset dari Kaggle:  
🔗 [Tomato Disease Dataset – Multiple Sources](https://www.kaggle.com/datasets/cookiefinder/tomato-disease-multiple-sources)

**Kelas penyakit yang dikenali**:
- Late Blight  
- Early Blight  
- Septoria Leaf Spot  
- Bacterial Spot  
- Leaf Mold  
- Target Spot  
- Tomato Mosaic Virus  
- Tomato Yellow Leaf Curl Virus  
- Spider Mites  
- Powdery Mildew  
- Healthy

---

## 📌 Status Proyek
✅ Deteksi penyakit offline berbasis AI (ResNet50 + TFLite)
✅ Fitur login, daftar, histori, dan hasil klasifikasi
🟡 Pengayaan deskripsi penyakit & rekomendasi perawatan (next)
🟡 Integrasi geolokasi dan notifikasi (pengembangan lanjutan)

---

## 👥 Tim Pengembang
👨‍💻 Sergio Winnero – AI/Model CNN, Flutter, TensorFlowLite, Backend
🧪 Samuel Setiawan – Pengujian, Finalisasi
🎨 Karina Vanya Wardoyo – Pengembang UI/UX
