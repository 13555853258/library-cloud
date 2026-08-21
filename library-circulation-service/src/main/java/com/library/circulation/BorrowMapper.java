package com.library.circulation;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface BorrowMapper extends BaseMapper<BorrowRecord> {
    @Select("""
        SELECT
            br.id,
            br.reader_id AS readerId,
            r.reader_no AS readerNo,
            u.real_name AS realName,
            br.book_id AS bookId,
            b.title,
            b.isbn,
            b.author_name AS authorName,
            br.copy_id AS copyId,
            bc.barcode,
            br.borrow_time AS borrowTime,
            br.due_time AS dueTime,
            br.return_time AS returnTime,
            br.renew_count AS renewCount,
            br.status,
            br.operator_id AS operatorId,
            br.remark
        FROM borrow_record br
        JOIN book b ON br.book_id = b.id
        JOIN reader r ON br.reader_id = r.id
        JOIN sys_user u ON r.user_id = u.id
        JOIN book_copy bc ON br.copy_id = bc.id
        WHERE (
            #{keyword} = ''
            OR b.title LIKE CONCAT('%', #{keyword}, '%')
            OR r.reader_no LIKE CONCAT('%', #{keyword}, '%')
            OR u.real_name LIKE CONCAT('%', #{keyword}, '%')
        )
        ORDER BY br.id DESC
        LIMIT #{offset}, #{size}
        """)
    List<Map<String, Object>> search(
        @Param("keyword") String keyword,
        @Param("offset") long offset,
        @Param("size") long size
    );

    @Select("""
        SELECT COUNT(*)
        FROM borrow_record br
        JOIN book b ON br.book_id = b.id
        JOIN reader r ON br.reader_id = r.id
        JOIN sys_user u ON r.user_id = u.id
        WHERE (
            #{keyword} = ''
            OR b.title LIKE CONCAT('%', #{keyword}, '%')
            OR r.reader_no LIKE CONCAT('%', #{keyword}, '%')
            OR u.real_name LIKE CONCAT('%', #{keyword}, '%')
        )
        """)
    long count(@Param("keyword") String keyword);
}
