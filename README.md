Bí Kíp Kanji Mobile App v1.0.0

## Người Việt học Kanji dễ hơn bằng âm Hán Việt và mẹo ghi nhớ

---

# 1. Tổng quan sản phẩm

## 1.1 Ý tưởng

**Bí Kíp Kanji** là ứng dụng mobile hỗ trợ người Việt học tiếng Nhật thông qua việc ghi nhớ:

- Kanji (chữ Hán Nhật)
- Từ vựng tiếng Nhật

Ứng dụng sử dụng phương pháp học:

- Âm Hán Việt
- Nhập câu trả lời chủ động
- Quiz ghi nhớ
- Mẹo liên tưởng
- Ôn tập những nội dung chưa nhớ

---

## 1.2 Điểm khác biệt

Người Việt có lợi thế khi học Kanji nhờ âm Hán Việt.

Ví dụ:

```
母
```

Thay vì học:

```
母 = はは
```

Ứng dụng giúp người học liên kết:

```
母

↓

Mẫu

↓

Mẹ

↓

はは
```

Tạo nhiều liên kết trong trí nhớ:

- Hình dạng Kanji
- Âm Hán Việt
- Nghĩa tiếng Việt
- Cách đọc tiếng Nhật

---

# 2. Mục tiêu sản phẩm

## 2.1 Mục tiêu chính

Giúp người Việt:

- Học Kanji dễ tiếp cận hơn
- Ghi nhớ lâu hơn
- Biết mình đã học đến đâu
- Biết chữ nào còn yếu
- Có lộ trình học rõ ràng

---

## 2.2 Định hướng học

Không phải:

> Xem danh sách Kanji và học thuộc lòng
> 

Mà là:

```
Chọn mục tiêu

↓

Làm thử thách

↓

Tự nhớ

↓

Nhận phản hồi

↓

Lưu tiến độ

↓

Ôn lại
```

---

# 3. Đối tượng sử dụng

Ứng dụng dành cho:

## Người Việt học tiếng Nhật mọi cấp độ

Không giới hạn người mới bắt đầu.

Người dùng có thể chọn:

- JLPT level
- Nội dung học
- Số lượng muốn học mỗi lần

---

Ví dụ:

```
N5

├── Kanji
└── Từ vựng

N4

├── Kanji
└── Từ vựng

N3

├── Kanji
└── Từ vựng
```

---

# 4. Phạm vi Version 1.0.0

## Có

✅ Mobile Application

✅ Học Kanji

✅ Học từ vựng

✅ Quiz nhập đáp án

✅ Kiểm tra đúng/sai

✅ Lưu tiến độ trên thiết bị

✅ Theo dõi chữ đã học/chưa học

✅ Theo dõi chữ yếu

✅ Ôn tập lỗi sai

✅ Export/Import dữ liệu backup

---

## Không có

❌ Đăng nhập

❌ Tài khoản người dùng

❌ Backend

❌ Database online

❌ Cloud Sync

❌ Học trên nhiều thiết bị

---

# 5. Lưu dữ liệu trong Version 1.0.0

## Không cần tài khoản

Ứng dụng tạo một hồ sơ học tập trên thiết bị.

Ví dụ:

```
Thiết bị

↓

Local Database

↓

Tiến độ học
```

---

Dữ liệu lưu:

```
Tên người dùng

Tiến độ Kanji

Tiến độ từ vựng

Lịch sử trả lời

Danh sách cần ôn
```

---

# 6. Bài toán tiến độ học

Ví dụ:

N5:

```
103 Kanji
```

---

Ngày 1:

Người dùng chọn:

```
Học 10 chữ
```

Sau khi hoàn thành:

```
Đã học:

10 / 103
```

---

Ngày 1 buổi tối:

Học tiếp:

```
10 chữ
```

Kết quả:

```
20 / 103
```

---

Ngày hôm sau mở app:

Ứng dụng nhớ:

```
Đã học:
20 chữ

Chưa học:
83 chữ
```

---

# 7. Trạng thái học của mỗi Kanji

Mỗi chữ có trạng thái:

```
NEW

(chưa học)

↓

LEARNING

(đang học)

↓

MASTERED

(đã nhớ)
```

---

Ví dụ:

```
母

Hán Việt:
Đã nhớ

Cách đọc:
Đang học

Nghĩa:
Đã nhớ
```

---

# 8. Hệ thống Progress

Theo dõi theo:

```
Kanji

+

Phương pháp học
```

Không chỉ:

```
母 = đã học
```

---

Ví dụ:

```
{
 "item":"母",

 "methods":{

   "hanviet":{
      "status":"mastered"
   },

   "reading":{
      "status":"learning"
   },

   "meaning":{
      "status":"new"
   }

 }
}
```

---

# 9. Home Screen

## Mục tiêu

Cho người dùng biết:

- Hôm nay học gì
- Tiến độ hiện tại
- Bắt đầu nhanh

---

UI:

```
--------------------------------

🈶 Bí Kíp Kanji

Xin chào ANH

N5 Kanji

██████░░░░

35 / 103

[ Học tiếp ]

--------------------------------
```

---

Các card:

```
📚 Kanji

📖 Từ vựng

🔄 Ôn tập

📊 Tiến độ
```

---

# 10. Flow học Kanji

## Bước 1

Chọn:

```
Học Kanji
```

---

## Bước 2

Chọn cấp độ:

```
N5
N4
N3
N2
N1
```

---

## Bước 3

Chọn phương pháp:

```
Kanji → Hán Việt

Kanji → Nghĩa

Kanji → Cách đọc
```

---

## Bước 4

Chọn số lượng:

```
10 chữ

20 chữ

50 chữ

Tùy chọn
```

---

# 11. Kanji Quiz Screen

Màn hình quan trọng nhất.

Thiết kế mobile:

```
--------------------

5 / 20

       母

Âm Hán Việt là gì?

[____________]

      Kiểm tra

--------------------
```

---

# 12. Xử lý đáp án

## Hán Việt

Đáp án:

```
Mẫu
```

Chấp nhận:

```
mẫu

Mẫu

mau
```

---

## Reading

Ví dụ:

```
母
```

Đáp án:

```
はは
```

Chấp nhận:

```
はは

haha
```

---

# 13. Kết quả trả lời

## Đúng

```
✓ Chính xác

母

Âm Hán Việt:

Mẫu

Nghĩa:

Mẹ

Cách đọc:

はは

Tiếp tục
```

---

## Sai

```
✕ Chưa đúng

Bạn nhập:

mauu

Đáp án:

Mẫu

Đã thêm vào ôn tập
```

---

# 14. Học từ vựng

Ví dụ:

```
母
```

Câu hỏi:

```
Cách đọc?
```

Nhập:

```
haha
```

hoặc:

```
はは
```

---

Kết quả:

```
母

はは

Mẹ
```

---

# 15. Chọn bài học tiếp theo

Không random hoàn toàn.

Thứ tự ưu tiên:

## 1. Chữ yếu

```
LEARNING
```

---

## 2. Chữ chưa học

```
NEW
```

---

## 3. Chữ đã nhớ

```
MASTERED
```

---

Mục tiêu:

Mỗi lần mở app:

Người dùng học đúng thứ cần học.

---

# 16. Màn hình Ôn tập

Hiển thị:

```
Cần ôn tập

母

Hán Việt

夕

Reading

犬

Meaning

[Bắt đầu ôn]
```

---

Khi ôn:

Chỉ hỏi phần chưa nhớ.

---

# 17. Màn hình Tiến độ

Ví dụ:

```
N5 Kanji

103 chữ

Đã nhớ:

35

Đang học:

15

Chưa học:

53
```

---

# 18. Màn hình Settings

Version 1:

```
Cài đặt

Tên:

ANH

Dữ liệu:

Xuất dữ liệu

Nhập dữ liệu

Xóa dữ liệu
```

---

# 19. Backup dữ liệu

Không đồng bộ online.

Người dùng có thể:

Export:

```
bikip-kanji-backup.json
```

Ví dụ:

```
{
 "username":"ANH",

 "progress":[

 ]
}
```

---

# 20. Kiến trúc Mobile App

## Version 1.0.0

```
Mobile App

↓

Local Database

↓

Learning Progress
```

---

Không có:

```
App

↓

Server
```

---

# 21. Version 2.0.0

Trong tương lai:

Thêm:

- Account
- Backend
- Database
- Cloud Sync
- Đồng bộ Web/App

Kiến trúc:

```
Mobile App

        ↓

API Server

        ↓

Database

        ↓

User Account
```

---

# 22. Công nghệ đề xuất Mobile

## Option 1: Flutter

Ưu điểm:

- Một code chạy Android/iOS
- UI đẹp
- Phù hợp app học tập

Stack:

```
Flutter

Dart

Riverpod

SQLite/Hive
```

---

## Option 2: React Native

Nếu muốn dùng chung hệ sinh thái React:

```
React Native

TypeScript

Expo

SQLite
```

---

# 23. Tầm nhìn sản phẩm

Bí Kíp Kanji không chỉ là app học chữ.

Mục tiêu:

```
Hiểu Kanji

↓

Nhớ bằng âm Hán Việt

↓

Liên tưởng bằng mẹo

↓

Luyện tập mỗi ngày

↓

Biết điểm yếu

↓

Ghi nhớ lâu dài
```

---

# 🈶 Bí Kíp Kanji

## Người Việt học Kanji dễ hơn bằng âm Hán Việt và mẹo ghi nhớ

```

---

Đây là bản **Mobile Product Document v1.0.0**.
Nếu dùng để bắt đầu code mobile sau này, bước tiếp theo nên tách thêm:
1. **Mobile UI Screen Specification (Figma level)**
2. **Mobile Database Schema (SQLite/Hive)**
3. **Mobile Technical Architecture (Flutter/React Native)**.
```
