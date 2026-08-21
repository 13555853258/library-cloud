package com.library.book;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface BookMapper extends BaseMapper<Book> {
    @Select("""
        SELECT
            b.id,
            b.isbn,
            b.title,
            b.category_id AS categoryId,
            c.name AS categoryName,
            b.publisher_id AS publisherId,
            p.name AS publisherName,
            b.author_name AS authorName,
            b.publish_date AS publishDate,
            b.price,
            b.cover_url AS coverUrl,
            b.description,
            b.location,
            b.total_copies AS totalCopies,
            b.available_copies AS availableCopies,
            b.borrow_count AS borrowCount,
            b.status,
            b.created_at AS createdAt,
            b.updated_at AS updatedAt
        FROM book b
        LEFT JOIN book_category c ON b.category_id = c.id
        LEFT JOIN publisher p ON b.publisher_id = p.id
        WHERE b.deleted = 0
          AND (
              #{keyword} = ''
              OR b.title LIKE CONCAT('%', #{keyword}, '%')
              OR b.isbn LIKE CONCAT('%', #{keyword}, '%')
              OR b.author_name LIKE CONCAT('%', #{keyword}, '%')
          )
        ORDER BY b.id DESC
        LIMIT #{offset}, #{size}
        """)
    List<Map<String, Object>> search(
        @Param("keyword") String keyword,
        @Param("offset") long offset,
        @Param("size") long size
    );

    @Select("""
        SELECT COUNT(*)
        FROM book
        WHERE deleted = 0
          AND (
              #{keyword} = ''
              OR title LIKE CONCAT('%', #{keyword}, '%')
              OR isbn LIKE CONCAT('%', #{keyword}, '%')
              OR author_name LIKE CONCAT('%', #{keyword}, '%')
          )
        """)
    long countSearch(@Param("keyword") String keyword);
}
