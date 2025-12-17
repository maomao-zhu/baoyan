package com.baoyan.entity;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class Student {
    private String id;
    private String name;
    private String password;
    private String profession;
    private String phone;
    private String picture;
    private BigDecimal baseScore;      // 基础分
    private BigDecimal totalScore;     // 总分
    private Integer studentRank;
    private String className;
    private String email;
    private Integer status;
    private LocalDateTime createdTime;
    private LocalDateTime updatedTime;
}