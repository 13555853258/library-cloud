package com.library.reader;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface ReaderMapper extends BaseMapper<Reader> {
    @Select("""
        SELECT
            r.id,
            r.user_id AS userId,
            r.reader_no AS readerNo,
            u.real_name AS realName,
            u.phone,
            u.email,
            r.reader_type AS readerType,
            r.college,
            r.major,
            r.max_borrow_count AS maxBorrowCount,
            r.credit_score AS creditScore,
            r.status,
            r.expire_date AS expireDate,
            r.created_at AS createdAt,
            r.updated_at AS updatedAt
        FROM reader r
        LEFT JOIN sys_user u ON r.user_id = u.id
        WHERE r.deleted = 0
          AND (
              #{keyword} = ''
              OR r.reader_no LIKE CONCAT('%', #{keyword}, '%')
              OR u.real_name LIKE CONCAT('%', #{keyword}, '%')
          )
        ORDER BY r.id ASC
        LIMIT #{offset}, #{size}
        """)
    List<Map<String, Object>> search(
        @Param("keyword") String keyword,
        @Param("offset") long offset,
        @Param("size") long size
    );

    @Select("""
        SELECT COUNT(*)
        FROM reader r
        LEFT JOIN sys_user u ON r.user_id = u.id
        WHERE r.deleted = 0
          AND (
              #{keyword} = ''
              OR r.reader_no LIKE CONCAT('%', #{keyword}, '%')
              OR u.real_name LIKE CONCAT('%', #{keyword}, '%')
          )
        """)
    long count(@Param("keyword") String keyword);
}
