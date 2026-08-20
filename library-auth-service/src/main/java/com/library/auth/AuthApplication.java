package com.library.auth;
import org.springframework.boot.SpringApplication; import org.springframework.boot.autoconfigure.SpringBootApplication;
@SpringBootApplication(scanBasePackages={"com.library.auth","com.library.common"}) public class AuthApplication{public static void main(String[] a){SpringApplication.run(AuthApplication.class,a);}}

