package com.baoyan;

import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.baoyan.mapper")
public class BaoyanApplication {

    public static void main(String[] args) {
        SpringApplication.run(BaoyanApplication.class, args);
    }

}
