<img width="884" height="536" alt="image" src="https://github.com/user-attachments/assets/ddad4225-4377-459e-9ae3-952cc49bcf27" />

# ⚡ ITG FastOOBE & Post-Setup Tweaks
*(Cloud Edition by IT Groceries Shop)*

สุดยอดสคริปต์ **Hybrid (PowerShell + Batch)** สำหรับช่างคอมพิวเตอร์! ช่วยข้ามขั้นตอนบังคับต่อเน็ตของ Windows 11 (BypassNRO), สร้าง Local User อัตโนมัติ พร้อมอัดฉีด Tweaks และเครื่องมือช่างที่จำเป็นตั้งแต่หน้าจอติดตั้งแรก (OOBE) รันผ่าน Cloud ได้ทันทีโดยไม่ต้องพกแฟลชไดรฟ์!

---

## ✨ Features (คุณสมบัติเด่น)

- ☁️ **Cloud Execution:** รันผ่านคำสั่ง `iex(irm ...)` ได้โดยตรงผ่านสถาปัตยกรรม Hybrid Script
- 🚫 **OOBE Bypass:** ข้ามการบังคับต่ออินเทอร์เน็ตของ Windows 11 (BypassNRO) ได้อย่างหมดจด
- 👤 **Auto Local Account:** สร้างบัญชี Local (สิทธิ์ Admin) ให้อัตโนมัติ พร้อมสคริปต์แก้บั๊ก "รหัสผ่านหมดอายุ" ถาวร
- 🔍 **Hardware Scanner:** แสดงสเปคเครื่อง (CPU, RAM, Mainboard, VGA) แบบเรียลไทม์บนหน้าต่าง OOBE
- 🧰 **OOBE System Tools:** เรียกใช้เครื่องมือช่างขั้นสูงได้ทันทีก่อนเข้า Windows (Device Manager, Disk Management ฯลฯ)
- ⚙️ **Essential Tweaks:** ปรับแต่งหน้า Desktop, ปิด Copilot, ปิดโฆษณาจุกจิก และตั้งค่าปุ่มสลับภาษา (Grave Accent) อัตโนมัติ

---
## 🚀 How to Use (วิธีใช้งาน)

1. ในหน้าต่างตั้งค่าแรกสุดของ Windows 11 (หน้าต่างเลือกภาษา/ประเทศ)
2. กดปุ่ม **`Shift + F10`** เพื่อเปิดหน้าต่าง Command Prompt
3. พิมพ์คำสั่งด้านล่างนี้เพื่อเข้าสู่โหมด PowerShell แล้วกด Enter:
   > `powershell`
4. พิมพ์คำสั่งรันสคริปต์ผ่าน Cloud แล้วกด Enter:
   > `iex(irm bit.ly/BypassNRO)`
5. หน้าต่าง GUI ของ **ITG FastOOBE** จะปรากฏขึ้น พร้อมให้คุณเลือกโหมดการทำงานได้ทันที!

---
## 🛠️ Operation Modes (โหมดการทำงาน)

- **[ A ] Local Account Mode (OOBE):** สำหรับช่างคอมพิวเตอร์ สคริปต์จะสร้าง User 'Admin' อัตโนมัติ ข้ามทุกขั้นตอนการตั้งค่า และรีสตาร์ททะลุเข้าหน้า Desktop ทันที
- **[ O ] Online Account Mode (OOBE):** สำหรับลูกค้าเครื่องแท้ สคริปต์จะฉีดการตั้งค่าและข้ามเน็ตให้ แต่จะยังคงเว้นจังหวะให้ลูกค้าล็อกอินด้วย Microsoft Account ของตัวเอง
- **[ D ] Desktop Tweaks (Current User):** สำหรับรันบน Windows ที่เข้าถึงหน้า Desktop แล้ว เพื่อฉีดการตั้งค่าและปรับแต่ง UI เบ็ดเตล็ดให้พร้อมใช้งาน

---

## 🔧 OOBE System Tools (ชุดเครื่องมือช่างด่วน)

สามารถเรียกใช้งานได้ทันทีจากเมนูหลักในหน้า OOBE เพื่อเช็คความเรียบร้อยก่อนส่งมอบเครื่อง:
- `[ M ]` **Device Manager:** ตรวจสอบไดรเวอร์ฮาร์ดแวร์พื้นฐาน
- `[ K ]` **Disk Management:** จัดการ, แบ่ง, หรือตรวจสอบพาร์ทิชัน
- `[ U ]` **User Accounts:** ตรวจสอบและจัดการโปรไฟล์ผู้ใช้งานในระบบ (netplwiz)
- `[ R ]` **Registry Editor:** เข้าถึง Registry ขั้นสูงของระบบ

---

## 👨‍💻 Developed By

**IT Groceries Shop Co.,ltd.**
- 📘 **Facebook:** [FB.COM/KHOMSO(R)N](https://facebook.com/itgroceries)
- 📄 **Fanpage:** [FB.COM/Adm1n1straTOE(TM)](https://facebook.com/Adm1n1straTOE)
- 📺 **YouTube:** [YT.COM/@ITGRO(C)ERIES](https://youtube.com/@itgroceries)
