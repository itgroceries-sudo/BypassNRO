<img width="1080" height="532" alt="image" src="https://github.com/user-attachments/assets/0999bd8f-7416-427f-a187-7b9acad92feb" />

---

<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/84194e6e-1494-4cf0-aaca-e0a803ba0421" />


# ⚡ ITG FastOOBE & Post-Setup Tweaks
*(Cloud Edition v2.1 - PathFix by IT Groceries Shop)*

สุดยอดสคริปต์ **Hybrid (PowerShell + Native Batch)** สำหรับช่างคอมพิวเตอร์! ออกแบบมาเพื่อรับมือกับระบบความปลอดภัยของ Windows 11 Build ใหม่ล่าสุด (24H2 / 25H2 / 26xxx) ช่วยข้ามขั้นตอนบังคับต่อเน็ตของ Windows 11 (BypassNRO), สร้าง Local User อัตโนมัติ พร้อมอัดฉีด Tweaks และเครื่องมือช่างที่จำเป็นตั้งแต่หน้าจอติดตั้งแรก (OOBE) รันผ่าน Cloud ได้ทันทีโดยไม่ต้องพกแฟลชไดรฟ์!

---

## ✨ Features (คุณสมบัติเด่น)

- ☁️ **Cloud Execution (Loader Architecture):** ทำงานผ่านโครงสร้าง Loader-to-Batch รันผ่านคำสั่ง `iex(irm ...)` ได้อย่างเสถียร หมดปัญหา Buffer Crash หรือการปิดหน้าต่างตัวเองขณะทำงานในหน้า OOBE
- 🚫 **OOBE Bypass & Dynamic Unattend:** ข้ามการบังคับต่ออินเทอร์เน็ตของ Windows 11 (BypassNRO) และส่งคำสั่งรีสตาร์ททะลุเข้า Desktop อย่างแนบเนียน
- 👤 **Auto Local Account (No WMIC):** สร้างบัญชี Local (สิทธิ์ Admin) ให้อัตโนมัติ พร้อมใช้คำสั่ง PowerShell Native เพื่อแก้บั๊ก "รหัสผ่านหมดอายุ" ถาวร (รองรับ 24H2+ ที่ถอด wmic ออกไปแล้ว)
- 🔍 **Real-time Hardware Scanner:** แสดงสเปคเครื่อง (CPU, RAM, Mainboard, VGA) ผ่าน `Get-CimInstance` ทันทีบนหน้าเมนูหลัก
- 🛡️ **Robust Path Resolution:** ทนทานต่อการเปลี่ยน Path ของระบบ (เช่น โฟลเดอร์ `defaultuser0` ล่องหน) ด้วยการเรียกใช้ System Variables (`%SystemRoot%`) และการันตีการโหลดไฟล์ข้ามสถาปัตยกรรม (LF to CRLF Auto-Conversion)
- 🧰 **OOBE System Tools:** เรียกใช้เครื่องมือช่างขั้นสูง (Device Manager, Disk Management ฯลฯ) เพื่อวิเคราะห์เครื่องลูกค้ายามฉุกเฉินได้ทันทีก่อนเข้า Windows
- ⚙️ **Essential Tweaks & Localization:** ปรับแต่งหน้า Desktop, ปิด Copilot, ปิดโฆษณาจุกจิก และตั้งค่าปุ่มสลับภาษาไทย-อังกฤษ (Grave Accent) อัตโนมัติผ่านระบบ Default User Injection

---

## 🚀 How to Use (วิธีใช้งาน)

1. ในหน้าต่างตั้งค่าแรกสุดของ Windows 11 (หน้าต่างเลือกภาษา/ประเทศ OOBE)
2. กดปุ่ม **`Shift + F10`** (หรือ `Fn + Shift + F10` บนโน้ตบุ๊กบางรุ่น) เพื่อเปิดหน้าต่าง Command Prompt
3. พิมพ์คำสั่งด้านล่างนี้เพื่อเข้าสู่โหมด PowerShell แล้วกด Enter:
   > `powershell`
4. พิมพ์คำสั่งรันสคริปต์ Loader ผ่าน Cloud แล้วกด Enter:
   > `iex(irm bit.ly/BypassNRO)`
5. หน้าต่าง GUI ของ **ITG FastOOBE** จะปรากฏขึ้น พร้อมให้คุณเลือกโหมดการทำงานได้ทันที!

---

## 🛠️ Operation Modes (โหมดการทำงานหลัก)

- **[ A ] Local Account Mode (OOBE):** (แนะนำสำหรับช่าง) สคริปต์จะสร้าง User Admin ตามที่คุณระบุ (ค่าเริ่มต้น: User) ปรับแต่ง UI อัดฉีดการข้าม OOBE และรีสตาร์ทเครื่องทะลุเข้าหน้า Desktop ทันที
- **[ O ] Online Account Mode (OOBE):** สำหรับลูกค้าเครื่องแท้หรือองค์กร สคริปต์จะฉีดการตั้งค่าและข้ามเน็ตให้ แต่จะยังคงเว้นจังหวะให้ลูกค้าล็อกอินเข้าสู่ระบบด้วย Microsoft Account ของตัวเอง
- **[ D ] Desktop Tweaks (Current User):** สำหรับใช้รันบน Windows ที่เข้าถึงหน้า Desktop เรียบร้อยแล้ว (หลัง OOBE) เพื่อปรับแต่ง UI ลดภาระระบบ และตั้งค่าภาษาให้ผู้ใช้ปัจจุบัน (Current User) ทันที

---

## 🔧 OOBE System Tools (ชุดเครื่องมือช่างด่วน)

สามารถเรียกใช้งานได้ทันทีจากเมนูหลักในหน้า OOBE เพื่อเช็คความเรียบร้อยก่อนส่งมอบเครื่อง หรือวิเคราะห์ฮาร์ดแวร์เบื้องต้น:
- **`[ M ]` Device Manager:** ตรวจสอบไดรเวอร์ฮาร์ดแวร์พื้นฐาน
- **`[ K ]` Disk Management:** จัดการ, แบ่ง, หรือตรวจสอบพาร์ทิชัน
- **`[ U ]` User Accounts:** ตรวจสอบและจัดการโปรไฟล์ผู้ใช้งานในระบบ (`netplwiz`)
- **`[ R ]` Registry Editor:** เข้าถึง Registry ขั้นสูงของระบบเพื่อแก้ไขปัญหาระดับลึก

---

## 👨‍💻 Developed By

**IT Groceries Shop Co.,ltd.**
- 📘 **Facebook:** [FB.COM/KHOMSO(R)N](https://facebook.com/itgroceries)
- 📄 **Fanpage:** [FB.COM/Adm1n1straTOE(TM)](https://facebook.com/Adm1n1straTOE)
- 📺 **YouTube:** [YT.COM/@ITGRO(C)ERIES](https://youtube.com/@itgroceries)
