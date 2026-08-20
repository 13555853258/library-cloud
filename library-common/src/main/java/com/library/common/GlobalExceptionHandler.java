package com.library.common;
import org.springframework.web.bind.MethodArgumentNotValidException; import org.springframework.web.bind.annotation.ExceptionHandler; import org.springframework.web.bind.annotation.RestControllerAdvice;
@RestControllerAdvice
public class GlobalExceptionHandler {
 @ExceptionHandler(BusinessException.class) public Result<Void> business(BusinessException e){ return Result.fail(e.getMessage()); }
 @ExceptionHandler(MethodArgumentNotValidException.class) public Result<Void> valid(MethodArgumentNotValidException e){ return Result.fail(e.getBindingResult().getAllErrors().get(0).getDefaultMessage()); }
 @ExceptionHandler(Exception.class) public Result<Void> other(Exception e){ return Result.fail("系统繁忙：" + e.getMessage()); }
}

