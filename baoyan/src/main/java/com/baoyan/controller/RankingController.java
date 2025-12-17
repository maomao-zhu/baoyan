package com.baoyan.controller;

import com.baoyan.service.RankingService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/ranking")
@CrossOrigin(origins = "*")
public class RankingController {

    @Resource
    private RankingService rankingService;

    /**
     * 手动触发更新单个学生的总分和排名
     */
    @PostMapping("/update/{studentId}")
    public ResponseEntity<Map<String, Object>> updateStudentRanking(@PathVariable String studentId) {
        try {
            rankingService.fullUpdateForStudent(studentId);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "学生排名更新成功");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("更新失败: " + e.getMessage()));
        }
    }

    /**
     * 更新某个专业所有学生的排名
     */
    @PostMapping("/update/profession/{profession}")
    public ResponseEntity<Map<String, Object>> updateProfessionRanking(@PathVariable String profession) {
        try {
            rankingService.updateRankingByProfession(profession);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "专业排名更新成功");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("更新失败: " + e.getMessage()));
        }
    }

    /**
     * 更新全院所有学生的排名
     */
    @PostMapping("/update/all")
    public ResponseEntity<Map<String, Object>> updateAllRanking() {
        try {
            rankingService.updateAllRanking();

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "全院排名更新成功");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("更新失败: " + e.getMessage()));
        }
    }

    /**
     * 获取学生的详细排名信息
     */
    @GetMapping("/student/{studentId}")
    public ResponseEntity<Map<String, Object>> getStudentRankingInfo(@PathVariable String studentId) {
        try {
            Map<String, Object> rankingInfo = rankingService.getStudentRankingInfo(studentId);

            Map<String, Object> response = new HashMap<>();
            if (rankingInfo != null) {
                response.put("success", true);
                response.put("data", rankingInfo);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "学生不存在");
                return ResponseEntity.status(404).body(response);
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("获取排名信息失败: " + e.getMessage()));
        }
    }

    /**
     * 批量更新所有学生的总分（初始化用）
     */
    @PostMapping("/batch-update-scores")
    public ResponseEntity<Map<String, Object>> batchUpdateAllScores() {
        try {
            rankingService.batchUpdateAllScores();

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "批量更新所有学生总分成功");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("批量更新失败: " + e.getMessage()));
        }
    }

    // 辅助方法
    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        response.put("timestamp", System.currentTimeMillis());
        return response;
    }
}