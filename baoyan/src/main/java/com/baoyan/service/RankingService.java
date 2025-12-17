package com.baoyan.service;

import com.baoyan.entity.Student;
import com.baoyan.mapper.ScoreItemMapper;
import com.baoyan.mapper.StudentMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Service
public class RankingService {

    @Resource
    private StudentMapper studentMapper;

    @Resource
    private ScoreItemMapper scoreItemMapper;

    /**
     * 更新单个学生的总分（基础分 + 所有通过审核的加分项）
     */
    @Transactional
    public void updateStudentTotalScore(String studentId) {
        // 1. 获取学生基本信息
        Student student = studentMapper.findByid(studentId);
        if (student == null) {
            return;
        }

        // 2. 计算所有通过审核的加分项总分
        BigDecimal approvedScoreSum = scoreItemMapper.sumApprovedScoreByStudent(studentId);
        if (approvedScoreSum == null) {
            approvedScoreSum = BigDecimal.ZERO;
        }

        // 3. 计算最终总分 = 基础分 + 加分项总分
        BigDecimal baseScore = student.getBaseScore() != null ? student.getBaseScore() : BigDecimal.ZERO;
        BigDecimal totalScore = baseScore.add(approvedScoreSum);

        // 4. 更新学生总分
        student.setTotalScore(totalScore);
        studentMapper.updateByid(student);
    }

    /**
     * 更新某个专业所有学生的排名
     */
    @Transactional
    public void updateRankingByProfession(String profession) {
        // 1. 获取该专业所有学生，按总分降序排列
        List<Map<String, Object>> students = scoreItemMapper.getStudentScoresByProfession(profession);

        // 2. 计算排名（考虑并列情况）
        int rank = 1;
        BigDecimal lastScore = null;
        int sameScoreCount = 0;

        for (int i = 0; i < students.size(); i++) {
            Map<String, Object> student = students.get(i);
            BigDecimal currentScore = (BigDecimal) student.get("total_score");

            // 如果总分相同，排名并列
            if (lastScore != null && currentScore.compareTo(lastScore) == 0) {
                sameScoreCount++;
            } else {
                rank = i + 1;
                sameScoreCount = 0;
            }

            // 更新学生排名
            String studentId = (String) student.get("id");
            scoreItemMapper.updateStudentRank(studentId, currentScore, rank);

            lastScore = currentScore;
        }
    }

    /**
     * 更新所有学生的排名（全院排名）
     */
    @Transactional
    public void updateAllRanking() {
        // 1. 获取所有学生，按总分降序排列
        List<Map<String, Object>> students = scoreItemMapper.getAllStudentScores();

        // 2. 计算全院排名
        int rank = 1;
        BigDecimal lastScore = null;
        int sameScoreCount = 0;

        for (int i = 0; i < students.size(); i++) {
            Map<String, Object> student = students.get(i);
            BigDecimal currentScore = (BigDecimal) student.get("total_score");

            // 如果总分相同，排名并列
            if (lastScore != null && currentScore.compareTo(lastScore) == 0) {
                sameScoreCount++;
            } else {
                rank = i + 1;
                sameScoreCount = 0;
            }

            // 更新学生排名
            String studentId = (String) student.get("id");
            scoreItemMapper.updateStudentRank(studentId, currentScore, rank);

            lastScore = currentScore;
        }
    }

    /**
     * 完整更新流程：更新总分 → 更新排名
     */
    @Transactional
    public void fullUpdateForStudent(String studentId) {
        // 1. 更新该学生的总分
        updateStudentTotalScore(studentId);

        // 2. 获取该学生的专业
        Student student = studentMapper.findByid(studentId);
        if (student != null && student.getProfession() != null) {
            // 3. 更新该专业所有学生的排名
            updateRankingByProfession(student.getProfession());
        }
    }

    /**
     * 获取学生排名信息（包括专业排名和全院排名）
     */
    public Map<String, Object> getStudentRankingInfo(String studentId) {
        Map<String, Object> result = scoreItemMapper.getStudentWithScores(studentId);

        // 如果需要将student_rank映射回rank键名，可以在这里处理
        if (result != null && result.containsKey("student_rank")) {
            // 复制一份，避免修改原始Map
            result.put("rank", result.get("student_rank"));
        }

        return result;
    }

    /**
     * 批量更新所有学生的总分（用于初始化或定时任务）
     */
    @Transactional
    public void batchUpdateAllScores() {
        // 1. 获取所有学生
        List<Student> allStudents = studentMapper.findAll();

        for (Student student : allStudents) {
            updateStudentTotalScore(student.getId());
        }

        // 2. 更新所有排名
        updateAllRanking();
    }
}