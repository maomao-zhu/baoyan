package com.baoyan.controller;

import com.baoyan.entity.Admin;
import com.baoyan.service.AdminService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/admin")
@CrossOrigin(origins = "*")
public class AdminController {

    @Resource
    private AdminService adminService;

    // ========== 登录相关 ==========

    /**
     * 管理员登录
     */
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> loginRequest) {
        String username = loginRequest.get("username");
        String password = loginRequest.get("password");

        Map<String, Object> response = new HashMap<>();

        try {
            if (username == null || username.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("用户名不能为空"));
            }
            if (password == null || password.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("密码不能为空"));
            }

            Admin admin = adminService.login(username, password);

            if (admin != null) {
                // 检查账号状态
                if (admin.getStatus() != null && admin.getStatus() == 0) {
                    response.put("success", false);
                    response.put("message", "账号已被禁用");
                    return ResponseEntity.status(403).body(response);
                }

                // 敏感信息不返回给前端
                admin.setPassword(null);

                response.put("success", true);
                response.put("message", "登录成功");
                response.put("data", admin);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "用户名或密码错误");
                return ResponseEntity.status(401).body(response);
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("登录失败: " + e.getMessage()));
        }
    }

    // ========== 管理员管理 ==========

    /**
     * 获取所有管理员
     */
    @GetMapping("/list")
    public ResponseEntity<Map<String, Object>> getAllAdmins() {
        try {
            List<Admin> admins = adminService.getAllAdmins();

            // 移除密码等敏感信息
            admins.forEach(admin -> admin.setPassword(null));

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", admins);
            response.put("count", admins.size());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("获取管理员列表失败: " + e.getMessage()));
        }
    }

    /**
     * 分页查询管理员
     */
    @GetMapping("/page")
    public ResponseEntity<Map<String, Object>> getAdminsByPage(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {

        try {
            List<Admin> admins = adminService.getAdminsByPage(pageNum, pageSize);
            Integer total = adminService.countAdmins();

            // 移除密码
            admins.forEach(admin -> admin.setPassword(null));

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", admins);
            response.put("total", total);
            response.put("pageNum", pageNum);
            response.put("pageSize", pageSize);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("分页查询失败: " + e.getMessage()));
        }
    }

    /**
     * 添加管理员
     */
    @PostMapping
    public ResponseEntity<Map<String, Object>> addAdmin(@RequestBody Admin admin) {
        try {
            // 验证必要字段
            if (admin.getUsername() == null || admin.getUsername().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("用户名不能为空"));
            }
            if (admin.getPassword() == null || admin.getPassword().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("密码不能为空"));
            }
            if (admin.getName() == null || admin.getName().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("姓名不能为空"));
            }

            // 检查用户名是否已存在
            if (adminService.usernameExists(admin.getUsername())) {
                return ResponseEntity.badRequest().body(createErrorResponse("用户名已存在"));
            }

            Admin savedAdmin = adminService.addAdmin(admin);
            savedAdmin.setPassword(null); // 不返回密码

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "管理员添加成功");
            response.put("data", savedAdmin);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("添加管理员失败: " + e.getMessage()));
        }
    }

    /**
     * 更新管理员
     */
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateAdmin(
            @PathVariable Integer id,
            @RequestBody Admin admin) {

        try {
            admin.setId(id);

            // 验证管理员是否存在
            Admin existingAdmin = adminService.getAdminById(id);
            if (existingAdmin == null) {
                return ResponseEntity.status(404).body(createErrorResponse("管理员不存在"));
            }

            adminService.updateAdmin(admin);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "管理员更新成功");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("更新管理员失败: " + e.getMessage()));
        }
    }

    /**
     * 删除管理员
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteAdmin(@PathVariable Integer id) {
        try {
            // 防止删除自己（需要从会话中获取当前登录的管理员ID）
            // 这里可以先简单实现

            adminService.deleteAdmin(id);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "管理员删除成功");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("删除管理员失败: " + e.getMessage()));
        }
    }

    /**
     * 获取管理员详情
     */
    @GetMapping("/{id}")
    public ResponseEntity<Map<String, Object>> getAdminDetail(@PathVariable Integer id) {
        try {
            Admin admin = adminService.getAdminById(id);

            Map<String, Object> response = new HashMap<>();
            if (admin != null) {
                admin.setPassword(null); // 不返回密码
                response.put("success", true);
                response.put("data", admin);
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "管理员不存在");
                return ResponseEntity.status(404).body(response);
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("获取管理员详情失败: " + e.getMessage()));
        }
    }

    /**
     * 启用/禁用管理员
     */
    @PutMapping("/{id}/status/{status}")
    public ResponseEntity<Map<String, Object>> toggleAdminStatus(
            @PathVariable Integer id,
            @PathVariable Integer status) {

        try {
            if (status != 0 && status != 1) {
                return ResponseEntity.badRequest().body(createErrorResponse("状态值无效（0-禁用，1-启用）"));
            }

            adminService.toggleAdminStatus(id, status);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", status == 1 ? "管理员已启用" : "管理员已禁用");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("修改状态失败: " + e.getMessage()));
        }
    }

    // ========== 学生管理（管理员权限） ==========

    // 注：学生管理功能已经在StudentController中实现，这里可以添加管理员特有的学生管理功能
    // 比如：批量导入学生、重置学生密码等

    // ========== 系统统计 ==========

    /**
     * 获取系统统计信息
     */
    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getSystemStats() {
        try {
            // 这里可以从各个Service获取统计数据
            // 暂时返回模拟数据
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalStudents", 150);
            stats.put("totalTeachers", 20);
            stats.put("totalAdmins", 3);
            stats.put("pendingItems", 15);
            stats.put("approvedItems", 320);
            stats.put("rejectedItems", 45);
            stats.put("systemStatus", "正常");

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
}
