package com.library.book;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper; import com.library.common.*; import lombok.RequiredArgsConstructor; import org.springframework.web.bind.annotation.*; import java.util.*;
@RestController @RequiredArgsConstructor public class BookController{private final BookMapper books;private final CategoryMapper categories;private final PublisherMapper publishers;
 @GetMapping({"/api/books","/api/books/public"})public Result<PageResult<Map<String,Object>>>page(@RequestParam(defaultValue="1")long page,@RequestParam(defaultValue="10")long size,@RequestParam(defaultValue="")String keyword){return Result.ok(new PageResult<>(books.countSearch(keyword),books.search(keyword,(page-1)*size,size)));}
 @GetMapping("/api/books/{id}")public Result<Book>detail(@PathVariable Long id){return Result.ok(books.selectById(id));}
 @PostMapping("/api/books")public Result<Void>add(@RequestBody Book b){b.setStatus(1);b.setDeleted(0);if(b.getAvailableCopies()==null)b.setAvailableCopies(b.getTotalCopies());books.insert(b);return Result.ok();}
 @PutMapping("/api/books/{id}")public Result<Void>update(@PathVariable Long id,@RequestBody Book b){b.setId(id);books.updateById(b);return Result.ok();}
 @DeleteMapping("/api/books/{id}")public Result<Void>delete(@PathVariable Long id){books.deleteById(id);return Result.ok();}
 @GetMapping("/api/categories")public Result<List<Category>>categories(){return Result.ok(categories.selectList(new LambdaQueryWrapper<Category>().orderByAsc(Category::getSortNo)));}
 @PostMapping("/api/categories")public Result<Void>addCategory(@RequestBody Category c){c.setDeleted(0);categories.insert(c);return Result.ok();}
 @PutMapping("/api/categories/{id}")public Result<Void>updateCategory(@PathVariable Long id,@RequestBody Category c){c.setId(id);categories.updateById(c);return Result.ok();}
 @DeleteMapping("/api/categories/{id}")public Result<Void>deleteCategory(@PathVariable Long id){categories.deleteById(id);return Result.ok();}
 @GetMapping("/api/publishers")public Result<List<Publisher>>publishers(){return Result.ok(publishers.selectList(null));}
}

