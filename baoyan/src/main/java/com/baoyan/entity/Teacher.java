package com.baoyan.entity;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class Teacher {
    private String id;
    private String name;
    private String password;
    private String profession;
    private String phone;
    private String picture;
    private String title;
    private String department;
    private String email;
    private Integer status;
    private Integer canAudit;
    private LocalDateTime createdTime;
    private LocalDateTime updatedTime;
}

