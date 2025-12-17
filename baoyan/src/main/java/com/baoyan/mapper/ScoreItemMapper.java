package com.baoyan.mapper;

import com.baoyan.entity.ScoreItem;
import org.apache.ibatis.annotations.*;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Mapper
public interface ScoreItemMapper {

    // ========== 基础CRUD操作 ==========

    @Insert("INSERT INTO score_item (" +
            "student_id, student_name, item_name, item_category, item_score, " +
            "item_description, proof_image, proof_files, status, create_time) " +
            "VALUES (" +
            "#{studentId}, #{studentName}, #{itemName}, #{itemCategory}, #{itemScore}, " +
            "#{itemDescription}, #{proofImage}, #{proofFiles}, #{status}, NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    void insert(ScoreItem scoreItem);

    @Select("SELECT * FROM score_item WHERE id = #{id}")
    ScoreItem findById(Long id);

    @Update("UPDATE score_item SET " +
            "item_name = #{itemName}, " +
            "item_category = #{itemCategory}, " +
            "item_score = #{itemScore}, " +
            "item_description = #{itemDescription}, " +
            "proof_image = #{proofImage}, " +
            "proof_files = #{proofFiles}, " +
            "update_time = NOW() " +
            "WHERE id = #{id}")
    void update(ScoreItem scoreItem);

    @Delete("DELETE FROM score_item WHERE id = #{id}")
    void deleteById(Long id);

    // ========== 老师端审核功能 ==========

    @Select("SELECT * FROM score_item WHERE status = 0 ORDER BY create_time DESC")
    List<ScoreItem> findPendingItems();

    @Select("SELECT * FROM score_item WHERE status = 0 ORDER BY create_time DESC LIMIT #{offset}, #{pageSize}")
    List<ScoreItem> findPendingItemsByPage(@Param("offset") Integer offset, @Param("pageSize") Integer pageSize);

    @Select("SELECT COUNT(*) FROM score_item WHERE status = 0")
    Integer countPendingItems();

    @Select("SELECT * FROM score_item WHERE auditor_id = #{teacherId} AND status IN (1, 2) ORDER BY audit_time DESC")
    List<ScoreItem> findProcessedItemsByTeacher(@Param("teacherId") String teacherId);

    @Update("UPDATE score_item SET " +
            "status = 1, " +
            "auditor_id = #{auditorId}, " +
            "auditor_name = #{auditorName}, " +
            "audit_time = NOW(), " +
            "audit_note = #{auditNote}, " +
            "last_audit_time = NOW(), " +
            "update_time = NOW() " +
            "WHERE id = #{id} AND status = 0")
    int approveItem(@Param("id") Long id,
                    @Param("auditorId") String auditorId,
                    @Param("auditorName") String auditorName,
                    @Param("auditNote") String auditNote);

    @Update("UPDATE score_item SET " +
            "status = 2, " +
            "auditor_id = #{auditorId}, " +
            "auditor_name = #{auditorName}, " +
            "audit_time = NOW(), " +
            "reject_reason = #{rejectReason}, " +
            "last_audit_time = NOW(), " +
            "update_time = NOW() " +
            "WHERE id = #{id} AND status = 0")
    int rejectItem(@Param("id") Long id,
                   @Param("auditorId") String auditorId,
                   @Param("auditorName") String auditorName,
                   @Param("rejectReason") String rejectReason);

    // ========== 学生端查询功能 ==========

    @Select("SELECT * FROM score_item WHERE student_id = #{studentId} ORDER BY create_time DESC")
    List<ScoreItem> findByStudentId(@Param("studentId") String studentId);

    @Select("SELECT * FROM score_item WHERE student_id = #{studentId} AND status = #{status} ORDER BY create_time DESC")
    List<ScoreItem> findByStudentIdAndStatus(@Param("studentId") String studentId, @Param("status") Integer status);

    @Update("UPDATE score_item SET " +
            "status = 0, " +
            "resubmit_count = COALESCE(resubmit_count, 0) + 1, " +
            "update_time = NOW() " +
            "WHERE id = #{id} AND status = 2 AND student_id = #{studentId}")
    int resubmitItem(@Param("id") Long id, @Param("studentId") String studentId);

    // ========== 统计功能 ==========

    @Select("SELECT COUNT(*) FROM score_item WHERE auditor_id = #{teacherId} AND status = 1")
    Integer countApprovedByTeacher(@Param("teacherId") String teacherId);

    @Select("SELECT COUNT(*) FROM score_item WHERE auditor_id = #{teacherId} AND status = 2")
    Integer countRejectedByTeacher(@Param("teacherId") String teacherId);

    @Select("SELECT COUNT(*) FROM score_item WHERE status = 0")
    Integer countAllPending();

    @Select("SELECT COUNT(*) FROM score_item WHERE status = 1")
    Integer countAllApproved();

    // ========== 分数计算和排名功能 ==========

    @Select("SELECT COALESCE(SUM(item_score), 0) FROM score_item " +
            "WHERE student_id = #{studentId} AND status = 1")
    BigDecimal sumApprovedScoreByStudent(@Param("studentId") String studentId);

    @Update("UPDATE student SET " +
            "total_score = #{totalScore}, " +
            "student_rank = #{rank}, " +  // 已修改为student_rank
            "updated_time = NOW() " +
            "WHERE id = #{studentId}")
    int updateStudentRank(@Param("studentId") String studentId,
                          @Param("totalScore") BigDecimal totalScore,
                          @Param("rank") Integer rank);

    @Select("SELECT id, total_score, student_rank FROM student " +  // 已修改为student_rank
            "WHERE profession = #{profession} AND status = 1 " +
            "ORDER BY total_score DESC")
    List<Map<String, Object>> getStudentScoresByProfession(@Param("profession") String profession);

    @Select("SELECT id, total_score, student_rank FROM student WHERE status = 1 ORDER BY total_score DESC")  // 已修改为student_rank
    List<Map<String, Object>> getAllStudentScores();

    // 修复这个方法 - 移除错误的AS语法
    @Select("SELECT s.id, s.name, s.profession, " +
            "s.base_score, s.total_score, s.student_rank, s.class_name, " +  // 直接返回student_rank
            "COUNT(DISTINCT si.id) as item_count, " +
            "SUM(CASE WHEN si.status = 1 THEN si.item_score ELSE 0 END) as approved_score, " +
            "SUM(CASE WHEN si.status = 0 THEN si.item_score ELSE 0 END) as pending_score, " +
            "SUM(CASE WHEN si.status = 2 THEN si.item_score ELSE 0 END) as rejected_score " +
            "FROM student s " +
            "LEFT JOIN score_item si ON s.id = si.student_id " +
            "WHERE s.id = #{studentId} " +
            "GROUP BY s.id, s.name, s.profession, s.base_score, s.total_score, s.student_rank, s.class_name")
    Map<String, Object> getStudentWithScores(@Param("studentId") String studentId);

    // ========== 管理员功能 ==========

    @Select("SELECT * FROM score_item ORDER BY create_time DESC")
    List<ScoreItem> findAllItems();

    @Select("SELECT * FROM score_item " +
            "WHERE create_time BETWEEN #{startTime} AND #{endTime} " +
            "ORDER BY create_time DESC")
    List<ScoreItem> findItemsByTimeRange(@Param("startTime") String startTime,
                                         @Param("endTime") String endTime);

    @Select("SELECT item_category, COUNT(*) as count, " +
            "AVG(item_score) as avg_score, " +
            "SUM(CASE WHEN status = 1 THEN item_score ELSE 0 END) as total_approved_score, " +
            "SUM(CASE WHEN status = 0 THEN item_score ELSE 0 END) as total_pending_score " +
            "FROM score_item " +
            "GROUP BY item_category")
    List<Map<String, Object>> getCategoryStats();
}