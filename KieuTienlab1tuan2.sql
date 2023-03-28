use database QLBanHang
go

create table Sanpham (
masp nchar(10),
mahangsx nchar(10),
tensp nvarchar(20),
soluong int,
mausac nvarchar(20),
giaban money,
donvitinh nchar(10),
mota varchar(max)
)

create table Hangsx(
Mahangsx nchar(10),
Tenhang nvarchar(20),
Diachi nvarchar(30),
Sodt nvarchar(20),
Email nvarchar(30)
)

create table Nhanvien(
Manv nchar(10),
Tennv nvarchar(20),
Gioitinh nchar(10),
Diachi nvarchar(30),
Sodt nvarchar(20),
Email nvarchar(30),
Phong nvarchar(30)
)

create table Nhap(
Sohdn nchar(10),
Masp nchar(10),
Manv nchar(10),
Ngaynhap date,
soluongnhap int,
dongianhap money
)

create table Xuat(
Sohdx nchar(10),
Masp nchar(10),
Manv nchar(10),
Ngayxuat date,
soluongxuat int
)


insert into Sanpham(masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
values ('SP01','H02','F1 Plus','100','Xam','7000000','Chiec','Hang can cao cap'),('SP02','H01','Galaxy Note1 1','50','Do','19000000','Chiec','Hang cao cap'),
('SP03','H02','F3 Lite','200','Nau','3000000','Chiec','Hang pho thong'),('SP04','H03','Vjoy3','200','Xam','1500000','Chiec','Hang pho thong'),
('SP05','H01','Galaxy V21','500','Nau','8000000','Chiec','Hang can cao cap')


insert into Hangsx(mahangsx, tenhang, diachi, sodt, email) values ('H01','Samsung','Korea','011-08271717','ss@gmail.com.kr'),('H02','Oppo','China','081-08626262','oppo@gmail.com.cn'),('H03','Vinfone','Viet Nam','084-098262626','vf@gmail.com.vn')

insert into Nhanvien(manv, tennv, gioitinh, diachi, sodt, email, phong) values ('NV01','Nguyễn Thị Thu','Nữ','Hà Nội','0982626521','thu@gmail.com','Kế toán'),('NV02','Lê Văn Nam','Nam','Bắc Ninh','0972525252','nam@gmail.com','Vật tư'),('NV03','Trần Hòa Bình','Nữ','Hà Nội','0328388388','hb@gmail.com','Kế toán')

insert into Nhap(sohdn, masp, manv, ngaynhap, soluongnhap, dongianhap) values ('N01','SP02','NV01','02-05-2019','10','17000000'),('N02','SP01','NV02','04-07-2020','30','6000000'),('N03','SP04','NV02','05-17-2020','20','1200000'),('N04','SP01','NV02','03-22-2020','10','6200000'),('N05','SP05','NV01','07-07-2020','20','7000000')

insert into Xuat(sohdx, masp, manv, ngayxuat, soluongxuat) values ('X01','SP03','NV02','06-14-2020','5'), ('X02','SP01','NV03','03-05-2019','3'), ('X03','SP02','NV01','12-12-2020','1'), ('X04','SP03','NV02','06-02-2020','2'), ('X05','SP05','NV01','05-18-2020','1')


BACKUP DATABASE QLBanHang
TO DISK = 'C:\QLBanHang';