package com.library.circulation;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface ReservationMapper extends BaseMapper<Reservation> {
    @Select("""
        SELECT
            rv.id,
            rv.reader_id AS readerId,
            r.reader_no AS readerNo,
            u.real_name AS realName,
            rv.book_id AS bookId,
            b.title AS bookTitle,
            b.isbn,
            rv.queue_no AS queueNo,
            rv.reserve_time AS reserveTime,
            rv.expire_time AS expireTime,
            rv.status,
            rv.notified
        FROM reservation rv
        JOIN reader r ON rv.reader_id = r.id
        JOIN sys_user u ON r.user_id = u.id
        JOIN book b ON rv.book_id = b.id
        ORDER BY rv.id DESC
        """)
    List<Map<String, Object>> searchAll();
}
