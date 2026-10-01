-- I. Tạo bảng ticket_bookings--
CREATE TABLE ticket_bookings (
    booking_id SERIAL PRIMARY KEY,
    movie_title VARCHAR(150) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    show_time TIMESTAMP NOT NULL,
    booking_date TIMESTAMP NOT NULL,
    seat_quantity INT NOT NULL,
    status VARCHAR(30) NOT NULL
);

-- II. Thiết kế các stored procedures và function--
-- 1. Function lấy danh sách tất cả các phiếu đặt vé--
CREATE OR REPLACE FUNCTION get_all_bookings()
RETURNS SETOF ticket_bookings AS $$
BEGIN
    RETURN QUERY SELECT * FROM ticket_bookings;
END;
$$ LANGUAGE plpgsql;

-- 2. Procedure thêm mới một phiếu đặt vé--
CREATE OR REPLACE PROCEDURE add_booking(
    p_movie_title VARCHAR, p_customer_name VARCHAR, p_show_time TIMESTAMP,
    p_booking_date TIMESTAMP, p_seat_quantity INT, p_status VARCHAR
) AS $$
BEGIN
    INSERT INTO ticket_bookings(movie_title, customer_name, show_time, booking_date, seat_quantity, status)
    VALUES (p_movie_title, p_customer_name, p_show_time, p_booking_date, p_seat_quantity, p_status);
END;
$$ LANGUAGE plpgsql;

-- 3. Procedure cập nhật thông tin phiếu đặt vé--
CREATE OR REPLACE PROCEDURE update_booking(
    p_booking_id INT, p_movie_title VARCHAR, p_customer_name VARCHAR,
    p_show_time TIMESTAMP, p_booking_date TIMESTAMP, p_seat_quantity INT, p_status VARCHAR
) AS $$
BEGIN
    UPDATE ticket_bookings
    SET movie_title = p_movie_title, customer_name = p_customer_name
        show_time = p_show_time, booking_date = p_booking_date
        seat_quantity = p_seat_quantity, status = p_status
    WHERE booking_id = p_booking_id;
END;
$$ LANGUAGE plpgsql;

-- 4. Procedure xóa phiếu đặt vé--
CREATE OR REPLACE PROCEDURE delete_booking(p_booking_id INT) AS $$
BEGIN
    DELETE FROM ticket_bookings WHERE booking_id = p_booking_id;
END;
$$ LANGUAGE plpgsql;

-- 5. Function tìm kiếm phiếu đặt vé theo tên khách hàng--
CREATE OR REPLACE FUNCTION get_bookings_by_customer(p_name VARCHAR)
RETURNS SETOF ticket_bookings AS $$
BEGIN
    RETURN QUERY SELECT * FROM ticket_bookings WHERE customer_name ILIKE '%' | p_name || '%';
END;
$$ LANGUAGE plpgsql;

-- 6. Function tìm kiếm phiếu đặt vé theo tên phim--
CREATE OR REPLACE FUNCTION search_bookings_by_movie(p_title VARCHAR)
RETURNS SETOF ticket_bookings AS $$
BEGIN
    RETURN QUERY SELECT * FROM ticket_bookings WHERE movie_title ILIKE '%' || p_title || '%';
END;
$$ LANGUAGE plpgsql;