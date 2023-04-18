use QLBHANG
go
--1. Tạo trigger kiểm soát việc nhập dữ liệu cho bảng nhập, hãy kiểm tra các ràng buộc toàn vẹn: masp có trong bảng sản phẩm chưa? many có trong bảng nhân viên chưa? kiểm tra các ràng buộc dữ liệu: soluongN và dongiaN>0? Sau khi nhập thì soluong ở bảng Sanpham sẽ được cập nhật theo.
create trigger trg_Nhap
on Nhap
for insert
as
begin
	declare @masp nvarchar(10),@manv nvarchar(10)
	declare @sln int, @dgn float
	select @masp=masp,@manv=manv,@sln=soluongN,@dgn=dongiaN
	from inserted
	if(not exists(select * from sanpham where masp=@masp))
		begin
			raiserror(N'Không tồn tại sản phẩm trong danh mục sản phẩm',16,1)
			rollback transaction
		end
	else 
		if(not exists(select * from nhanvien where manv=@manv))
			begin
				raiserror (N'không tồn tại nhân viên có mã này',16,1)
				rollback transaction
			end
		else
		if(@sln<=0 or @dgn<=0)
			begin
				raiserror (N'Nhập sai số lượng hoặc đơn gia',16,1)
				rollback transaction 
			end
		else
			update Sanpham set soluong =soluong+@sln
			from sanpham where masp=@masp
end
--Lệnh thực thi
select*from Sanpham;
select*from Nhanvien;
select*from Nhap;
--2. Tạo trigger kiểm soát việc nhập dữ liệu cho bảng xuất, hãy kiểm tra các ràng buộc toàn vẹn: masp có trong bảng sản phẩm chưa? many có trong bảng nhân viên chưa? kiểm tra các ràng buộc dữ liệu: soluongX<soluong trong bảng sanpham? Sau khi xuất thì soluong ở bảng Sanpham sẽ được cập nhật theo.
CREATE TRIGGER CheckXuat
ON Xuat
AFTER INSERT
AS
BEGIN
   
    IF NOT EXISTS (SELECT masp FROM Sanpham WHERE masp = (SELECT masp FROM inserted))
    BEGIN
        RAISERROR('Mã sản phẩm không tồn tại trong bảng Sanpham', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF NOT EXISTS (SELECT manv FROM Nhanvien WHERE manv = (SELECT manv FROM inserted))
    BEGIN
        RAISERROR('Mã nhân viên không tồn tại trong bảng Nhanvien', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
   
    DECLARE @soluongX INT
    SELECT @soluongX = soluongX FROM inserted
    
    DECLARE @soluong INT
    SELECT @soluong = soluong FROM Sanpham WHERE masp = (SELECT masp FROM inserted)
    
    IF (@soluongX > @soluong)
    BEGIN
        RAISERROR('Số lượng xuất vượt quá số lượng trong kho', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END
    
    UPDATE Sanpham
    SET soluong = soluong - @soluongX
    WHERE masp = (SELECT masp FROM inserted)
END
--Lệnh thực thi
select*from Sanpham;
select*from Nhanvien;
select*from Xuat;
--3. Tạo trigger kiểm soát việc xóa phiếu xuất, khi phiếu xuất xóa thì số lượng hàng trong bảng sanpham sẽ được cập nhật tăng lên.
CREATE TRIGGER tr_XoaPhieuXuat
ON Xuat
FOR DELETE
AS
BEGIN
    DECLARE @masp nchar(10), @soluongX int
    SELECT @masp = deleted.masp, @soluongX = deleted.soluongX
    FROM deleted

    UPDATE Sanpham
    SET soluong = soluong + @soluongX
    WHERE masp = @masp
END

--4. Tạo trigger cho việc cập nhật lại số lượng xuất trong bảng xuất, hãy kiểm tra xem số lượng xuất thay đổi có nhỏ hơn soluong trong bảng sanpham hay ko? số bản ghi thay đổi >1 bản ghi hay không? nếu thỏa mãn thì cho phép update bảng xuất và update lại soluong trong bảng sanpham.
CREATE TRIGGER tr_UpdateSoluongXuat
ON Xuat
AFTER UPDATE
AS
BEGIN
    DECLARE @masp nchar(10), @soluongX int, @old_soluongX int, @diff int
    
    SELECT @masp = i.masp, @soluongX = i.soluongX, @old_soluongX = d.soluongX
    FROM inserted i
    INNER JOIN deleted d ON i.sohdx = d.sohdx AND i.masp = d.masp

    SET @diff = @soluongX - @old_soluongX

    IF (@diff > 0)
    BEGIN
        DECLARE @soluong int
        SELECT @soluong = soluong FROM Sanpham WHERE masp = @masp
        IF (@soluong < @diff)
        BEGIN
            RAISERROR('Số lượng xuất vượt quá số lượng tồn kho', 16, 1)
            ROLLBACK TRANSACTION
        END
        ELSE
        BEGIN
            UPDATE Sanpham SET soluong = soluong - @diff WHERE masp = @masp
        END
    END
    ELSE
    BEGIN
        UPDATE Sanpham SET soluong = soluong - @diff WHERE masp = @masp
    END
END

--5. Tạo trigger cho việc cập nhật lại số lượng Nhập trong bảng Nhập, Hãy kiểm tra xem số bản ghi thay đổi >1 bản ghi hay không? nếu thỏa mãn thì cho phép update bảng Nhập và update lại soluong trong bảng sanpham.
CREATE TRIGGER tr_Nhap_Update
ON Nhap
AFTER UPDATE
AS
BEGIN
  DECLARE @count INT
  SET @count = (SELECT COUNT(*) FROM inserted)
  
  IF @count > 1
  BEGIN
    RAISERROR('Khong duoc cap nhat qua 1 ban ghi!', 16, 1)
    ROLLBACK TRANSACTION
    RETURN
  END
  
  DECLARE @masp nchar(10)
  DECLARE @soluongN int
  
  SELECT @masp = i.masp, @soluongN = i.soluongN
  FROM inserted i

  DECLARE @soluongS int
  
  SELECT @soluongS = s.soluong
  FROM Sanpham s
  WHERE s.masp = @masp

  IF @soluongN - @soluongS > 0
  BEGIN
    RAISERROR('So luong nhap khong duoc lon hon so luong trong kho!', 16, 1)
    ROLLBACK TRANSACTION
    RETURN
  END

  UPDATE Sanpham
  SET soluong = soluong - (@soluongS - @soluongN)
  WHERE masp = @masp
END

--6. Tạo trigger kiểm soát việc xóa phiếu nhập, khi phiếu nhập xóa thì số lượng hàng trong bảng sanpham sẽ được cập nhật giảm xuống.
CREATE TRIGGER update_soluongsanpham
ON Nhap
AFTER DELETE
AS

BEGIN
    
    UPDATE Sanpham
    SET Soluong = Sanpham.Soluong - deleted.soluongN
    FROM Sanpham
    JOIN deleted ON Sanpham.Masp = deleted.Masp
END

