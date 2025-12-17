package com.baoyan.controller;

import com.baoyan.entity.ScoreItem;
import com.baoyan.service.ScoreItemService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/teacher")
@CrossOrigin(origins = "*") // 允许跨域
public class TeacherController {

    @Resource
    private ScoreItemService scoreItemService;

    // ========== 待审核项目管理 ==========

    /**
     * 获取待审核项目列表
     */
    @GetMapping("/pending-items")
    public ResponseEntity<Map<String, Object>> getPendingItems(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        try {
            List<ScoreItem> items = scoreItemService.getPendingItemsByPage(pageNum, pageSize);
            Integer total = scoreItemService.countPendingItems();

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", items);
            response.put("total", total);
            response.put("pageNum", pageNum);
            response.put("pageSize", pageSize);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("获取待审核列表失败: " + e.getMessage()));
        }
    }

    /**
     * 获取所有待审核项目（不分页）
     */
    @GetMapping("/pending-items/all")
    public ResponseEntity<Map<String, Object>> getAllPendingItems() {
        try {
            List<ScoreItem> items = scoreItemService.getPendingItems();

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", items);
            response.put("count", items.size());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("获取待审核列表失败: " + e.getMessage()));
        }
    }

    // ========== 已审核项目管理 ==========

    /**
     * 获取老师已审核的项目列表
     */
    @GetMapping("/processed-items")
    public ResponseEntity<Map<String, Object>> getProcessedItems(
            @RequestParam String teacherId) {

        try {
            List<ScoreItem> items = scoreItemService.getProcessedItemsByTeacher(teacherId);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", items);
            response.put("count", items.size());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("获取已审核列表失败: " + e.getMessage()));
        }
    }

    // ========== 审核操作 ==========

    /**
     * 审核通过项目
     */
    @PostMapping("/approve/{id}")
    public ResponseEntity<Map<String, Object>> approveItem(
            @PathVariable Long id,
            @RequestBody Map<String, String> request) {

        try {
            String teacherId = request.get("teacherId");
            String teacherName = request.get("teacherName");
            String auditNote = request.get("auditNote");

            // 参数验证
            if (teacherId == null || teacherId.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("教师ID不能为空"));
            }
            if (teacherName == null || teacherName.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("教师姓名不能为空"));
            }

            boolean success = scoreItemService.approveItem(id, teacherId, teacherName, auditNote);

            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "审核通过成功");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "审核失败：项目不存在或状态不正确");
                return ResponseEntity.badRequest().body(response);
            }
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("审核操作失败: " + e.getMessage()));
        }
    }

    /**
     * 审核驳回项目
     */
    @PostMapping("/reject/{id}")
    public ResponseEntity<Map<String, Object>> rejectItem(
            @PathVariable Long id,
            @RequestBody Map<String, String> request) {

        try {
            String teacherId = request.get("teacherId");
            String teacherName = request.get("teacherName");
            String rejectReason = request.get("rejectReason");

            // 参数验证
            if (teacherId == null || teacherId.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("教师ID不能为空"));
            }
            if (teacherName == null || teacherName.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("教师姓名不能为空"));
            }
            if (rejectReason == null || rejectReason.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("驳回原因不能为空"));
            }

            boolean success = scoreItemService.rejectItem(id, teacherId, teacherName, rejectReason);

            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "审核驳回成功");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "审核失败：项目不存在或状态不正确");
                return ResponseEntity.badRequest().body(response);
            }
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("审核操作失败: " + e.getMessage()));
        }
    }

    // ========== 项目详情 ==========

    /**
     * 获取项目详情
     */
    @GetMapping("/item/{id}")
    public ResponseEntity<Map<String, Object>> getItemDetail(@PathVariable Long id) {
        try {
            ScoreItem item = scoreItemService.getItemDetail(id);

            Map<String, Object> response = new HashMap<>();
            if (item != null) {
                response.put("success", true);
                response.put("data", item);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "项目不存在");
                return ResponseEntity.status(404).body(response);
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("获取项目详情失败: " + e.getMessage()));
        }
    }

    // ========== 统计信息 ==========

    /**
     * 获取老师审核统计
     */
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getTeacherStats(@RequestParam String teacherId) {
        try {
            ScoreItemService.TeacherAuditStats stats = scoreItemService.getTeacherStats(teacherId);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", stats);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("获取统计信息失败: " + e.getMessage()));
        }
    }

    // ========== 辅助方法 ==========

    /**
     * 创建错误响应
     */
    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        response.put("timestamp", System.currentTimeMillis());
        return response;
    }

    /**
     * 教师登录接口
     */
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> loginRequest) {
        String id = loginRequest.get("userId");
        String password = loginRequest.get("password");

        Map<String, Object> response = new HashMap<>();

        try {
            // 这里需要先创建TeacherService并注入
            // Teacher teacher = teacherService.login(id, password);

            // 临时模拟登录
            if ("T2023001".equals(id) && "123456".equals(password)) {
                response.put("success", true);
                response.put("message", "登录成功");

                // 模拟返回教师数据
                Map<String, Object> teacherData = new HashMap<>();
                teacherData.put("id", "T2023001");
                teacherData.put("name", "张教授");
                teacherData.put("profession", "计算机科学");
                teacherData.put("title", "教授");
                teacherData.put("department", "计算机学院");

                response.put("data", teacherData);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "账号或密码错误");
                return ResponseEntity.status(401).body(response);
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "服务器错误: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    /**
     * 获取所有教师列表
     */
    @GetMapping("/list")
    public ResponseEntity<Map<String, Object>> getAllTeachers() {
        try {
            // 这里需要先创建TeacherService并注入
            // List<Teacher> teachers = teacherService.getAllTeachers();

            // 临时返回空列表
            List<Map<String, Object>> teachers = new ArrayList<>();

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", teachers);
            response.put("count", teachers.size());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("获取教师列表失败: " + e.getMessage()));
        }
    }
}
