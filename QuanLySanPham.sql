create database BaiTapUngDung;
use BaiTapUngDung;
-- Tạo bảng Danh Mục Sản Phẩm
create table DanhMucSanPham(
maDM int primary key auto_increment,
tenDM varchar(50) not null unique,
mota text,
trangthai bit default(1)
);
-- Tạo bảng Sản Phẩm
create table SanPham(
maSp varchar(5) primary key,
tenSp varchar(100) not null unique,
ngaytao date default(curdate()),
gia float default(0),
motaSp text,
tieude varchar(200),
maDm int,
foreign key(maDm) references DanhMucSanPham(maDM),
trangthai bit default(1)
);
-- Thêm các dữ  liệu  vào  2 bảng
INSERT INTO DanhMucSanPham(maDM, tenDM, mota, trangthai)
VALUE ('1','DM1','Mo ta DM1',1),
      ('2','DM2','Mo ta DM2',1),
      ('3','DM3','Mo ta DM3',1);
INSERT INTO SanPham (maSp, tenSp, gia, tieuDe, maDM, trangThai)
VALUES ('SP001', 'Sản phẩm 1', 25000, 'Tieu de san pham 1', 1, 1),
       ('SP002', 'Sản phẩm 2', 30000, 'Tieu de san pham 2', 1, 1),
       ('SP003', 'Sản phẩm 3', 40000, 'Tieu de san pham 3', 2, 1);
/* Tạo view gồm các sản phẩm có giá lớn hơn 20000 gồm các thông tin sau: 
    mã danh mục, tên danh mục, trạng thái danh mục, mã sản phẩm, tên sản phẩm, 
    giá sản phẩm, trạng thái sản phẩm
*/
CREATE VIEW SanPhamGiaLonHon20000 AS
SELECT
    d.maDM,d.tenDM,d.trangthai AS trangthaiDM,
    s.maSp,s.tenSp,s.gia AS giaSP,s.trangthai AS trangthaiSP
FROM
    DanhMucSanPham d JOIN SanPham s ON d.maDM = s.maDM
WHERE
    s.gia > 20000;
/*
Tạo các procedure sau:
    - procedure cho phép thêm, sửa, xóa, lấy tất cả dữ liệu, lấy dữ liệu theo mã
    của bảng danh mục và sản phẩm
    - procedure cho phép lấy ra tất cả các phẩm có trạng thái là 1
    bao gồm mã sản phẩm, tên sản phẩm, giá, tên danh mục, trạng thái sản phẩm
    - procedure cho phép thống kê số sản phẩm theo từng mã danh mục
    - procedure cho phép tìm kiếm sản phẩm theo tên sản phầm: mã sản phẩm, tên
    sản phẩm, giá, trạng thái sản phẩm, tên danh mục, trạng thái danh mục
*/
-- procedure cho phép thêm, sửa, xóa, lấy tất cả dữ liệu, lấy dữ liệu theo mã của bảng danh mục và sản phẩm
DELIMITER //
create procedure insert_types(
in type_id int,
in type_name varchar(50),
in type_des text,
in type_status bit
)
begin
insert into DanhMucSanPham
values(type_id,type_name,type_des,type_status);
end //
DELIMITER ;
call insert_types('4','DM4','Mota DM4',1);
-- Sửa
DELIMITER //
CREATE PROCEDURE UpdateDanhMuc(IN ma INT, IN ten VARCHAR(50), IN Mota TEXT, IN Trangthai BIT)
BEGIN
    UPDATE DanhMucSanPham SET tenDM = Ten, mota = Mota, trangthai = Trangthai WHERE maDM = ma;
END //
DELIMITER ;
CALL UpdateDanhMuc(1,'Ten Mới' , 'Mô tả danh mục mới',1);
-- Xóa
DELIMITER //
CREATE PROCEDURE deleteDanhMuc(IN ma int)
BEGIN
delete from DanhMucSanPham where maDM=ma;
END //
DELIMITER ;
call deleteDanhMuc('3');
-- lấy tất cả dữ liệu
DELIMITER //
CREATE PROCEDURE GetAllDanhMuc()
BEGIN
    SELECT * FROM DanhMucSanPham;
END;
//
DELIMITER ;
CALL GetAllDanhMuc;
-- lấy dữ liệu theo mã của bảng danh mục và sản phẩm
DELIMITER //
CREATE PROCEDURE GetDanhMuc(IN ma INT)
BEGIN
    SELECT * FROM DanhMucSanPham WHERE maDM = ma;
END //
DELIMITER ;

call GetDanhMuc(2); 
-- procedure cho phép lấy ra tất cả các phẩm có trạng thái là 1 bao gồm mã sản phẩm, tên sản phẩm, giá, tên danh mục, trạng thái sản phẩm
DELIMITER //
CREATE PROCEDURE GetSanPhamTrangthai1()
BEGIN
    SELECT maSp, tenSp, gia, tenDM, SanPham.TrangThai
    FROM SanPham
             JOIN DanhMucSanPham ON SanPham.maDM = DanhMucSanPham.maDM
    WHERE SanPham.TrangThai = 1;
END //
DELIMITER ;
call GetSanPhamTrangthai1;
-- procedure cho phép thống kê số sản phẩm theo từng mã danh mục
DELIMITER //
CREATE PROCEDURE ThongKeSanPham()
BEGIN
    SELECT maDM, COUNT(maSp)
    FROM SanPham
    GROUP BY maDM;
END //
DELIMITER ;
call ThongKeSanPham;
-- procedure cho phép tìm kiếm sản phẩm theo tên sản phầm: mã sản phẩm, tên sản phẩm, giá, trạng thái sản phẩm, tên danh mục, trạng thái danh mục
DELIMITER //
CREATE PROCEDURE TimKiemSanPham(IN Ten VARCHAR(100))
BEGIN
    SELECT maSp, tenSp, gia, SanPham.TrangThai, tenDM, DanhMucSanPham.TrangThai
    FROM SanPham
             JOIN DanhMucSanPham ON SanPham.maDM = DanhMucSanPham.maDM
    WHERE SanPham.tenSp LIKE CONCAT('%', Ten, '%');
END //
DELIMITER ;
call TimKiemSanPham('San Pham');