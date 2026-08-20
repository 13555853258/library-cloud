package com.library.book; import org.springframework.boot.SpringApplication; import org.springframework.boot.autoconfigure.SpringBootApplication; @SpringBootApplication(scanBasePackages={"com.library.book","com.library.common"}) public class BookApplication{public static void main(String[]a){SpringApplication.run(BookApplication.class,a);}}

