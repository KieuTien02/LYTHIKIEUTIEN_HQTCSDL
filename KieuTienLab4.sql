1. 
CREATE VIEW Sanpham_View AS
select * from Sanpham, Hangsx, Nhanvien, Nhap, Xuat
2.
CREATE VIEW masp_View AS
select masp,tensp,Tenhang,soluong,mausac,giaban,donvitinh,mota from Sanpham, Hangsx order by giaban desc
3.
CREATE view Hangsx_View AS
select * from Hangsx where Tenhang='Samsung'
4.
CREATE VIEW Nhanvien_View AS
select * from Nhanvien where gioitinh='Nữ' and phong='Kế toán'
5.
CREATE VIEW Nhsp_View AS
select Nhap.Sohdn, Sanpham.Masp, Sanpham.Tensp, Hangsx.Tenhang, Nhap.soluongN, Nhap.dongiaN, Nhap.soluongN*Nhap.dongiaN as tiennhap, Sanpham.mausac, Sanpham.donvitinh, Nhap.Ngaynhap, Nhanvien.Tennv, Nhanvien.Phong 
from Nhap
join Sanpham on Nhap.Masp = Sanpham.masp 
join Hangsx on Sanpham.Mahangsx = Hangsx.Mahangsx
join Nhanvien on Nhap.Manv = Nhanvien.Manv 
order by Nhap.Sohdn asc;
6.
CREATE VIEW Xuat_View AS
select Xuat.Sohdx, Sanpham.Masp, Sanpham.Tensp, Hangsx.Tenhang, Xuat.soluongX, Sanpham.giaban, Xuat.soluongX*Sanpham.giaban as tienxuat, Sanpham.mausac, Sanpham.donvitinh, Xuat.Ngayxuat, Nhanvien.Tennv, Nhanvien.Phong 
from Xuat
join Sanpham on Xuat.Masp = Sanpham.masp 
join Hangsx on Sanpham.Mahangsx = Hangsx.Mahangsx
join Nhanvien on Xuat.Manv = Nhanvien.Manv 
where month(Xuat.ngayxuat) = 10 AND Year(Xuat.ngayxuat) = 2018
order by Xuat.Sohdx asc;
7.
CREATE view Nhap_View AS
select Sohdn, Sanpham.masp, Tensp, soluongN, dongiaN, Ngaynhap, Tennv, Phong
from Nhap
join Sanpham on Nhap.Masp = Sanpham.masp 
join Hangsx on Sanpham.Mahangsx = Hangsx.Mahangsx
join Nhanvien on Nhap.Manv = Nhanvien.Manv 
where Hangsx.Tenhang = 'Samsung' AND Year(ngaynhap) = 2017
8.
CREATE VIEW Xuat_view AS
select top 10 Xuat.Sohdx, Sanpham.Tensp, Xuat.soluongX
from Xuat
inner join Sanpham on Xuat.Masp = Sanpham.masp
where year(xuat.ngayxuat) = '2023'
order by Xuat.soluongX desc;
9. 
CREATE VIEW Sanpham_View AS
select top 10 tensp, giaban
from SanPham
order by giaban desc;
10.
CREATE VIEW Hangsx_View AS
select * from Sanpham
join Hangsx on Sanpham.mahangsx = Hangsx.mahangsx
WHERE Hangsx.tenhang = 'Samsung' and Sanpham.giaban >= 100000 and Sanpham.giaban <= 500000

