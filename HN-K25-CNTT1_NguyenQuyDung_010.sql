drop database if exists cuoi_mon;
create database cuoi_mon;
use cuoi_mon;

create table Customers (
	customer_id varchar(10) primary key,
    full_name varchar(100) not null,
    phone_number varchar(11) not null unique,
    email varchar(100) not null,
    join_date datetime not null default current_timestamp
);

create table Insurance_Packages (
	package_id varchar(10) primary key,
    package_name varchar(255) not null check (package_name in('Sức khỏe','Ô tô','Nhân thọ','Du lịch','Tai nạn')), 
    max_limit decimal(14,2) check (max_limit > 0) not null,
    base_premium decimal(14,2) not null check (base_premium > 0)
);

create table Policies (
	policy_id varchar(10) primary key,
    customer_id varchar(10) not null,
    package_id varchar(10) not null,
    start_date datetime not null,
    end_date datetime not null check( end_date > start_date ),
    status varchar(100) not null check (status in ('Active', 'Expired', 'Cancelled')),
    foreign key (customer_id) references Customers(customer_id) ON UPDATE CASCADE ON DELETE NO ACTION,
    foreign key (package_id) references Insurance_Packages(customer_id) ON UPDATE CASCADE ON DELETE NO ACTION
);


1.1  Thiết kế bảng — DDL  (15 điểm)
Viết câu lệnh DDL tạo CSDL gồm 5 bảng với đầy đủ ràng buộc (PK, FK, CHECK, UNIQUE, DEFAULT).
Bảng 1 — Customers (Khách hàng)
Tên cột
Mô tả
Ràng buộc
customer_id
Mã khách hàng
PRIMARY KEY, kiểu VARCHAR(10)
full_name
Họ và tên đầy đủ
NOT NULL
phone_number
Số điện thoại liên lạc
NOT NULL, UNIQUE
email
Địa chỉ thư điện tử
NOT NULL
join_date
Ngày tham gia hệ thống
NOT NULL, DEFAULT (CURRENT_DATE)

✦ phone_number có UNIQUE để đảm bảo mỗi số điện thoại chỉ đăng ký một lần.
Bảng 2 — Insurance_Packages (Gói bảo hiểm)
Tên cột
Mô tả
Ràng buộc
package_id
Mã gói bảo hiểm
PRIMARY KEY, kiểu VARCHAR(10)
package_name
Tên gói bảo hiểm
NOT NULL, CHECK tên chứa: Sức khỏe / Ô tô / Nhân thọ / Du lịch / Tai nạn
max_limit
Hạn mức chi trả tối đa (VNĐ)
NOT NULL, CHECK max_limit > 0
base_premium
Phí bảo hiểm cơ bản (VNĐ)
NOT NULL, CHECK base_premium > 0

✦ max_limit và base_premium có CHECK > 0 để tránh nhập giá trị âm hoặc bằng 0.
Bảng 3 — Policies (Hợp đồng bảo hiểm)
Tên cột
Mô tả
Ràng buộc
policy_id
Mã hợp đồng
PRIMARY KEY, kiểu VARCHAR(10)
customer_id
Mã khách hàng ký hợp đồng
NOT NULL, FOREIGN KEY → Customers(customer_id)
package_id
Mã gói bảo hiểm được chọn
NOT NULL, FOREIGN KEY → Insurance_Packages(package_id)
start_date
Ngày bắt đầu hiệu lực
NOT NULL
end_date
Ngày kết thúc hiệu lực
NOT NULL, CHECK end_date > start_date
status
Trạng thái hợp đồng
NOT NULL, CHECK IN ('Active', 'Expired', 'Cancelled')

✦ FK: fk_pol_customer (→ Customers), fk_pol_package (→ Insurance_Packages). ON UPDATE CASCADE, ON DELETE NO ACTION.
Bảng 4 — Claims (Yêu cầu bồi thường)
Tên cột
Mô tả
Ràng buộc
claim_id
Mã yêu cầu bồi thường
PRIMARY KEY, kiểu VARCHAR(10)
policy_id
Mã hợp đồng liên quan
NOT NULL, FOREIGN KEY → Policies(policy_id)
claim_date
Ngày gửi yêu cầu bồi thường
NOT NULL, DEFAULT (CURRENT_DATE)
claim_amount
Số tiền yêu cầu bồi thường (VNĐ)
NOT NULL, CHECK claim_amount > 0
status
Trạng thái xét duyệt
NOT NULL, DEFAULT 'Pending', CHECK IN ('Pending','Approved','Rejected')

✦ FK: fk_claim_policy (→ Policies). status mặc định 'Pending' khi mới tạo.
Bảng 5 — Claim_Processing_Log (Nhật ký xử lý)
Tên cột
Mô tả
Ràng buộc
log_id
Mã nhật ký xử lý
PRIMARY KEY, kiểu VARCHAR(10)
claim_id
Mã yêu cầu bồi thường được xử lý
NOT NULL, FOREIGN KEY → Claims(claim_id)
action_detail
Nội dung chi tiết bước xử lý
NOT NULL, kiểu TEXT
recorded_at
Thời điểm ghi nhận nhật ký
NOT NULL, DEFAULT CURRENT_TIMESTAMP
processor
Tên / mã người xử lý
NOT NULL

✦ FK: fk_log_claim (→ Claims). Mỗi yêu cầu có thể có nhiều bản ghi nhật ký.

1.2  Chèn dữ liệu mẫu — DML  (8 điểm)
Viết câu lệnh INSERT tối thiểu 5 bản ghi mẫu cho mỗi bảng theo dữ liệu sau:
Bảng Customers
Customer_ID
Full_Name
Phone_Number
Email
Join_Date
C001
Nguyen Hoang Long
0901112223
long.nh@gmail.com
2024-01-15
C002
Tran Thi Kim Anh
0988877766
anh.tk@yahoo.com
2024-03-10
C003
Le Hoang Nam
0903334445
nam.lh@outlook.com
2025-05-20
C004
Pham Minh Duc
0355556667
duc.pm@gmail.com
2025-08-12
C005
Hoang Thu Thao
0779998881
thao.ht@gmail.com
2026-01-01


Bảng Insurance_Packages
Package_ID
Package_Name
Max_Limit (VNĐ)
Base_Premium (VNĐ)
PKG01
Bảo hiểm Sức khỏe Gold
500,000,000
5,000,000
PKG02
Bảo hiểm Ô tô Liberty
1,000,000,000
15,000,000
PKG03
Bảo hiểm Nhân thọ An Bình
2,000,000,000
25,000,000
PKG04
Bảo hiểm Du lịch Quốc tế
100,000,000
1,000,000
PKG05
Bảo hiểm Tai nạn 24/7
200,000,000
2,500,000


Bảng Policies
Policy_ID
Customer_ID
Package_ID
Start_Date
End_Date
Status
POL101
C001
PKG01
2024-01-15
2025-01-15
Expired
POL102
C002
PKG02
2024-03-10
2026-03-10
Active
POL103
C003
PKG03
2025-05-20
2035-05-20
Active
POL104
C004
PKG04
2025-08-12
2025-09-12
Expired
POL105
C005
PKG01
2026-01-01
2027-01-01
Active


Bảng Claims
Claim_ID
Policy_ID
Claim_Date
Claim_Amount (VNĐ)
Status
CLM901
POL102
2024-06-15
12,000,000
Approved
CLM902
POL103
2025-10-20
50,000,000
Pending
CLM903
POL101
2024-11-05
5,500,000
Approved
CLM904
POL105
2026-01-15
2,000,000
Rejected
CLM905
POL102
2025-02-10
120,000,000
Approved


Bảng Claim_Processing_Log
Log_ID
Claim_ID
Action_Detail
Recorded_At
Processor
L001
CLM901
Đã nhận hồ sơ hiện trường
2024-06-15 09:00
Admin_01
L002
CLM901
Chấp nhận bồi thường xe tai nạn
2024-06-20 14:30
Admin_01
L003
CLM902
Đang thẩm định hồ sơ bệnh án
2025-10-21 10:00
Admin_02
L004
CLM904
Từ chối do lỗi cố ý của khách hàng
2026-01-16 16:00
Admin_03
L005
CLM905
Đã thanh toán qua chuyển khoản
2025-02-15 08:30
Accountant_01


1.3  Cập nhật & Xóa dữ liệu  (2 điểm)
Câu 1: Viết câu lệnh tăng phí bảo hiểm cơ bản (base_premium) thêm 15% cho các gói bảo hiểm có hạn mức chi trả (max_limit) trên 500.000.000 VNĐ.
Câu 2: Viết câu lệnh xóa các nhật ký xử lý bồi thường (Claim_Processing_Log) được ghi nhận trước ngày '2025-06-20'.

PHẦN 2: TRUY VẤN DỮ LIỆU CƠ BẢN  —  15 ĐIỂM
Câu 1: Liệt kê thông tin các hợp đồng có trạng thái 'Active' và có ngày kết thúc (end_date) trong năm 2026.
Câu 2: Lấy thông tin khách hàng (họ tên, email) có tên chứa chữ 'Hoang' và tham gia bảo hiểm từ năm 2025 trở lại đây.
Câu 3: Sắp xếp claim_amount giảm dần, bỏ qua bản ghi đầu tiên, lấy 3 bản ghi tiếp theo.

PHẦN 3: TRUY VẤN DỮ LIỆU NÂNG CAO  —  20 ĐIỂM
Câu 1: (7đ)  Sử dụng LEFT JOIN để hiển thị cả hợp đồng chưa có yêu cầu bồi thường. Kết quả gồm: Tên khách hàng, Tên gói bảo hiểm, Ngày bắt đầu hợp đồng, Số tiền bồi thường (NULL nếu chưa có).
Câu 2: (7đ)  Thống kê tổng số tiền bồi thường đã chi trả (status = 'Approved') cho từng khách hàng. Chỉ hiển thị những người có tổng chi trả > 50.000.000 VNĐ.
Câu 3: (6đ)  Tìm gói bảo hiểm có số lượng khách hàng đăng ký nhiều nhất.

PHẦN 4: INDEX & VIEW  —  10 ĐIỂM
Câu 1: (4đ)  Tạo Composite Index tên idx_policy_status_date trên bảng Policies cho hai cột: status và start_date.
Câu 2: (6đ)  Tạo View tên vw_customer_summary hiển thị: Tên khách hàng, Số lượng hợp đồng đang sở hữu, Tổng phí bảo hiểm định kỳ phải trả.

PHẦN 5: TRIGGER  —  10 ĐIỂM
Câu 1: (5đ)  Viết Trigger tên trg_after_claim_approved.
Yêu cầu: Khi một yêu cầu bồi thường chuyển trạng thái sang 'Approved', tự động thêm một dòng vào Claim_Processing_Log với nội dung:
'Payment processed to customer'
Câu 2: (5đ)  Viết Trigger ngăn chặn việc xóa hợp đồng nếu trạng thái của hợp đồng đó đang là 'Active'.

PHẦN 6: STORED PROCEDURE & TRANSACTION  —  20 ĐIỂM
Câu 1: (8đ)  Viết Stored Procedure sp_check_claim_limit
Đầu vào: claim_id (IN)
Đầu ra: message (OUT VARCHAR) với giá trị:
• 'Exceeded'  — nếu claim_amount > max_limit của gói bảo hiểm tương ứng
• 'Valid'       — nếu claim_amount ≤ max_limit

Câu 2: (12đ)  Viết Stored Procedure sp_cancel_policy để hủy một hợp đồng bảo hiểm
Đầu vào: policy_id (IN), claim_id (IN)
Đầu ra: message (OUT VARCHAR) với các giá trị có thể:
• 'Cancelled successfully'    — hủy thành công
• 'Invalid claim for policy' — claim_id không thuộc policy_id này
• 'Policy not found'            — policy_id không tồn tại
• 'Failed'                           — lỗi không xác định

Logic xử lý:
• Bắt đầu Transaction.
• Kiểm tra policy_id có tồn tại không → nếu không, trả 'Policy not found' và ROLLBACK.
• Kiểm tra claim_id có thuộc policy_id không → nếu không, trả 'Invalid claim for policy' và ROLLBACK.
• Cập nhật trạng thái hợp đồng thành 'Cancelled'.
• Ghi log vào Claim_Processing_Log với nội dung 'Customer requested cancellation'.
• COMMIT nếu thành công → trả 'Cancelled successfully'.
• ROLLBACK nếu có lỗi phát sinh → trả 'Failed'.

