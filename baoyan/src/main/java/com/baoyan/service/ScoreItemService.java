package com.baoyan.service;

import com.baoyan.entity.ScoreItem;
import com.baoyan.mapper.ScoreItemMapper;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;


@Service
public class ScoreItemService {

    @Resource
    private ScoreItemMapper scoreItemMapper;
    @Resource
    private RankingService rankingService;
    // ========== 学生相关方法 ==========

    /**
     * 学生添加加分项目
     */
    @Transactional
    public ScoreItem addScoreItem(ScoreItem scoreItem) {
        // 设置默认状态为待审核
        scoreItem.setStatus(ScoreItem.Status.PENDING);
        scoreItem.setCreateTime(LocalDateTime.now());
        scoreItem.setUpdateTime(LocalDateTime.now());

        scoreItemMapper.insert(scoreItem);
        return scoreItem;
    }

    /**
     * 学生查看自己的项目列表
     */
    public List<ScoreItem> getStudentItems(String studentId) {
        return scoreItemMapper.findByStudentId(studentId);
    }

    /**
     * 学生查看特定状态的项目
     */
    public List<ScoreItem> getStudentItemsByStatus(String studentId, Integer status) {
        return scoreItemMapper.findByStudentIdAndStatus(studentId, status);
    }

    /**
     * 学生重新提交被驳回的项目
     */
    @Transactional
    public boolean resubmitItem(Long itemId, String studentId) {
        int rows = scoreItemMapper.resubmitItem(itemId, studentId);
        return rows > 0;
    }

    // ========== 老师相关方法 ==========

    /**
     * 老师获取待审核项目列表
     */
    public List<ScoreItem> getPendingItems() {
        return scoreItemMapper.findPendingItems();
    }

    /**
     * 老师获取待审核项目列表（分页）
     */
    public List<ScoreItem> getPendingItemsByPage(Integer pageNum, Integer pageSize) {
        Integer offset = (pageNum - 1) * pageSize;
        return scoreItemMapper.findPendingItemsByPage(offset, pageSize);
    }

    /**
     * 获取待审核项目总数
     */
    public Integer countPendingItems() {
        return scoreItemMapper.countPendingItems();
    }

    /**
     * 老师获取已审核项目列表
     */
    public List<ScoreItem> getProcessedItemsByTeacher(String teacherId) {
        return scoreItemMapper.findProcessedItemsByTeacher(teacherId);
    }

    /**
     * 老师审核通过项目
     */
    @Transactional
    public boolean approveItem(Long itemId, String teacherId, String teacherName, String auditNote) {
        // 验证项目是否存在且为待审核状态
        ScoreItem item = scoreItemMapper.findById(itemId);
        if (item == null || !item.isPending()) {
            return false;
        }

        // 执行审核通过操作
        int rows = scoreItemMapper.approveItem(itemId, teacherId, teacherName, auditNote);
        boolean success = rows > 0;

        // 如果审核通过，更新学生的总分和排名
        if (success) {
            rankingService.fullUpdateForStudent(item.getStudentId());
        }

        return success;
    }

    /**
     * 老师审核驳回项目
     */
    @Transactional
    public boolean rejectItem(Long itemId, String teacherId, String teacherName, String rejectReason) {
        // 验证项目是否存在且为待审核状态
        ScoreItem item = scoreItemMapper.findById(itemId);
        if (item == null || !item.isPending()) {
            return false;
        }

        // 验证驳回原因不能为空
        if (rejectReason == null || rejectReason.trim().isEmpty()) {
            throw new IllegalArgumentException("驳回原因不能为空");
        }

        int rows = scoreItemMapper.rejectItem(itemId, teacherId, teacherName, rejectReason);
        boolean success = rows > 0;

        // 如果驳回，也需要更新排名（因为可能有之前通过的被撤销）
        if (success) {
            rankingService.fullUpdateForStudent(item.getStudentId());
        }

        return success;
    }
    // ========== 通用方法 ==========

    /**
     * 获取项目详情
     */
    public ScoreItem getItemDetail(Long id) {
        return scoreItemMapper.findById(id);
    }

    /**
     * 老师审核统计
     */
    public TeacherAuditStats getTeacherStats(String teacherId) {
        TeacherAuditStats stats = new TeacherAuditStats();
        stats.setPendingCount(scoreItemMapper.countPendingItems());
        stats.setApprovedCount(scoreItemMapper.countApprovedByTeacher(teacherId));
        stats.setRejectedCount(scoreItemMapper.countRejectedByTeacher(teacherId));

        // 计算通过率
        int total = stats.getApprovedCount() + stats.getRejectedCount();
        if (total > 0) {
            stats.setApprovalRate((double) stats.getApprovedCount() / total * 100);
        } else {
            stats.setApprovalRate(0.0);
        }

        return stats;
    }

    // ========== 内部类 ==========

    /**
     * 老师审核统计DTO
     */
    @Setter
    @Getter
    public static class TeacherAuditStats {
        // getter/setter 方法
        private Integer pendingCount;    // 待审核数量
        private Integer approvedCount;   // 通过数量
        private Integer rejectedCount;   // 驳回数量
        private Double approvalRate;     // 通过率

    }
}
