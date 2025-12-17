package com.baoyan.entity;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Admin {
    private Integer id;
    private String username;
    private String name;
    private String password;
    private String role;
    private String permissions; // JSON字符串
    private Integer status;
    private String phone;
    private String email;
    private LocalDateTime lastLoginTime;
    private LocalDateTime createdTime;
}
