USE QLBH
GO
---cau 1
drop proc sp_InsertHangSX
CREATE PROCEDURE sp_InsertHangSX
    @mahangsx VARCHAR(50),
    @tenhang VARCHAR(50),
    @diachi VARCHAR(100),
    @sodt VARCHAR(20),
    @email VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT * FROM HangSX WHERE tenhang = @tenhang)
    BEGIN
        PRINT N'Tên hãng đã tồn tại, không thể thêm mới!'
        RETURN
    END

    INSERT INTO HangSX(mahangsx, tenhang, diachi, sodt, email)
    VALUES(@mahangsx, @tenhang, @diachi, @sodt, @email)

    PRINT N'Thêm mới thành công!'
END

EXEC sp_InsertHangSX 'HSX01', 'Iphone', 'Hà Nội', '0123456709', 'iphone@gmail.com'

---cau2
Drop proc sp_NhapSanPham
CREATE PROCEDURE sp_NhapSanPham
    @masp varchar(10),
    @tenhangsx varchar(50),
    @tensp varchar(50),
    @soluong int,
    @mausac varchar(20),
    @giaban decimal(18,2),
    @donvitinh varchar(10),
    @mota varchar(200)
AS
BEGIN
    IF EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        UPDATE Sanpham
        SET mahangsx = (SELECT mahangsx FROM Hangsx WHERE tenhang = @tenhangsx),
            tensp = @tensp,
            soluong = @soluong,
            mausac = @mausac,
            giaban = @giaban,
            donvitinh = @donvitinh,
            mota = @mota
        WHERE masp = @masp
    END
    ELSE
    BEGIN
        INSERT INTO Sanpham(masp, mahangsx, tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES (@masp, (SELECT mahangsx FROM Hangsx WHERE tenhang = @tenhangsx), @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)
    END
END

EXEC sp_NhapSanPham @masp = 'SP001', @tenhangsx = 'Samsung', @tensp = 'Galaxy S21', @soluong = 100, @mausac = 'Xanh', @giaban = 20000000, @donvitinh = 'Cái', @mota = N'Điện thoại thông minh Samsung Galaxy S21'

---cau3
CREATE PROCEDURE DeleteHangsx
    @tenhang nvarchar(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Kiểm tra hãng sản xuất có tồn tại hay không
    IF NOT EXISTS (SELECT * FROM Hangsx WHERE tenhang = @tenhang)
    BEGIN
        PRINT N'Hãng sản xuất không tồn tại!'
    END
    ELSE
    BEGIN
        -- Xóa các sản phẩm liên quan đến hãng sản xuất
        DELETE FROM Sanpham WHERE mahangsx = (SELECT mahangsx FROM Hangsx WHERE tenhang = @tenhang)
        
        -- Xóa hãng sản xuất
        DELETE FROM Hangsx WHERE tenhang = @tenhang
        
        PRINT N'Đã xóa hãng sản xuất ' + @tenhang + N' và các sản phẩm liên quan!'
    END
END

EXEC DeleteHangsx 'tenhang'
---câu4
CREATE PROCEDURE sp_NhapNhanVien
	@manv INT,
	@tennv NVARCHAR(50),
	@gioitinh NVARCHAR(10),
	@diachi NVARCHAR(100),
	@sodt NVARCHAR(15),
	@email NVARCHAR(50),
	@phong NVARCHAR(50),
	@flag INT
AS
BEGIN
	IF (@flag = 0)
	BEGIN
		UPDATE Nhanvien
		SET tennv = @tennv,
			gioitinh = @gioitinh,
			diachi = @diachi,
			sodt = @sodt,
			email = @email,
			phong = @phong
		WHERE manv = @manv
	END
	ELSE
	BEGIN
		INSERT INTO Nhanvien(manv, tennv, gioitinh, diachi, sodt, email, phong)
		VALUES (@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong)
	END
END

EXEC sp_NhapNhanVien @manv = 1, @tennv = N'Nguyen Van A', @gioitinh = N'Nam', @diachi = N'Ha Noi', @sodt = N'0987654521', @email = N'abc@gmail.com', 
	@phong = N'Kinh doanh', @flag = 1
