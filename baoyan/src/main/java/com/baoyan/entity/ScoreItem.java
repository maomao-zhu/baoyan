package com.baoyan.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class ScoreItem {
    // 主键ID
    private Long id;

    // 学生信息
    private String studentId;
    private String studentName;

    // 项目基本信息
    private String itemName;
    private String itemCategory;
    private BigDecimal itemScore;
    private String itemDescription;

    // 证明材料
    private String proofImage;
    private String proofFiles; // JSON字符串格式

    // 审核状态
    private Integer status; // 0-待审核, 1-审核通过, 2-审核驳回
    private String rejectReason;

    // 时间信息
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private LocalDateTime auditTime;
    private LocalDateTime lastAuditTime; // 新增：上次审核时间

    // 审核人信息
    private String auditorId;
    private String auditorName;
    private String auditNote; // 新增：审核备注
    private Integer resubmitCount; // 新增：重新提交次数

    // 状态枚举常量
    public static class Status {
        public static final int PENDING = 0;    // 待审核
        public static final int APPROVED = 1;   // 审核通过
        public static final int REJECTED = 2;   // 审核驳回
    }

    // 获取状态文本描述
    public String getStatusText() {
        return switch (this.status) {
            case Status.PENDING -> "待审核";
            case Status.APPROVED -> "审核通过";
            case Status.REJECTED -> "审核驳回";
            default -> "未知状态";
        };
    }

    // 判断是否为待审核状态
    public boolean isPending() {
        return Status.PENDING == this.status;
    }

    // 判断是否为审核通过状态
    public boolean isApproved() {
        return Status.APPROVED == this.status;
    }

    // 判断是否为审核驳回状态
    public boolean isRejected() {
        return Status.REJECTED == this.status;
    }
}