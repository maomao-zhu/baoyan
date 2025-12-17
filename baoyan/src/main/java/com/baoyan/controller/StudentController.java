package com.baoyan.controller;

import com.baoyan.entity.Student;
import com.baoyan.entity.ScoreItem;
import com.baoyan.mapper.StudentMapper;
import com.baoyan.service.ScoreItemService;
import com.baoyan.vo.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/student")
@CrossOrigin(origins = "*") // 添加跨域支持
public class StudentController {

    @Resource
    private StudentMapper studentMapper;  // 修改变量名为小写开头

    @Resource
    private ScoreItemService scoreItemService;  // 新增：加分项目服务

    // 查询所有学生
    @GetMapping
    public List<Student> getStudent() {
        return studentMapper.findAll();
    }

    // 创建学生
    @PostMapping
    public String postStudent(@RequestBody Student student) {
        studentMapper.save(student);
        return "success";
    }

    // 修改学生
    @PutMapping
    public String updateStudent(@RequestBody Student student) {
        studentMapper.updateByid(student);
        return "success";
    }

    // 根据id删除学生
    @DeleteMapping("/{id}")
    public String deleteStudent(@PathVariable("id") String id) {  // 修改方法名更准确
        studentMapper.deleteByid(id);
        return "success";
    }

    // 根据id查询学生
    @GetMapping("/{id}")
    public Student findByid(@PathVariable("id") String id) {
        return studentMapper.findByid(id);
    }

    // 分页查询学生
    @GetMapping("/page")
    public Page<Student> findByPage(@RequestParam(defaultValue = "1") Integer pageNum,
                                    @RequestParam(defaultValue = "10") Integer pageSize) {

        Integer offset = (pageNum - 1) * pageSize;
        List<Student> studentData = studentMapper.findByPage(offset, pageSize);
        Page<Student> page = new Page<>();
        page.setList(studentData);
        page.setPageNum(pageNum);
        Integer total = studentMapper.countStudents(); // 使用countStudents方法更高效
        page.setTotal(total);
        page.setPageSize(pageSize);
        return page;
    }

    // 学生登录接口
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> loginRequest) {
        String id = loginRequest.get("userId");
        String password = loginRequest.get("password");

        Map<String, Object> response = new HashMap<>();

        try {
            Student student = studentMapper.findByid(id);

            if (student != null) {
                if (student.getPassword().equals(password)) {
                    // 登录成功
                    response.put("success", true);
                    response.put("message", "登录成功");
                    response.put("data", student);
                    return ResponseEntity.ok(response);
                } else {
                    // 密码错误
                    response.put("success", false);
                    response.put("message", "密码错误");
                    return ResponseEntity.status(401).body(response);
                }
            } else {
                // 用户不存在
                response.put("success", false);
                response.put("message", "用户不存在");
                return ResponseEntity.status(404).body(response);
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "服务器错误: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }

    // ========== 加分项目管理功能 ==========

    /**
     * 学生添加加分项目
     */
    @PostMapping("/score-item")
    public ResponseEntity<Map<String, Object>> addScoreItem(@RequestBody ScoreItem scoreItem) {
        try {
            // 验证必要字段
            if (scoreItem.getStudentId() == null || scoreItem.getStudentId().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("学生ID不能为空"));
            }
            if (scoreItem.getStudentName() == null || scoreItem.getStudentName().trim().isEmpty()) {
                // 如果前端没有传递学生姓名，从数据库查询
                Student student = studentMapper.findByid(scoreItem.getStudentId());
                if (student != null) {
                    scoreItem.setStudentName(student.getName());
                } else {
                    return ResponseEntity.badRequest().body(createErrorResponse("学生不存在"));
                }
            }
            if (scoreItem.getItemName() == null || scoreItem.getItemName().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("项目名称不能为空"));
            }
            if (scoreItem.getItemCategory() == null || scoreItem.getItemCategory().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(createErrorResponse("项目类别不能为空"));
            }
            if (scoreItem.getItemScore() == null) {
                return ResponseEntity.badRequest().body(createErrorResponse("项目分数不能为空"));
            }
            if (scoreItem.getItemScore().doubleValue() <= 0) {
                return ResponseEntity.badRequest().body(createErrorResponse("项目分数必须大于0"));
            }

            // 设置默认状态为待审核
            scoreItem.setStatus(ScoreItem.Status.PENDING);

            ScoreItem savedItem = scoreItemService.addScoreItem(scoreItem);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "项目提交成功，等待审核");
            response.put("data", savedItem);

            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(createErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("提交失败: " + e.getMessage()));
        }
    }

    /**
     * 学生获取自己的所有加分项目
     */
    @GetMapping("/{studentId}/score-items")
    public ResponseEntity<Map<String, Object>> getStudentScoreItems(@PathVariable String studentId) {
        try {
            List<ScoreItem> items = scoreItemService.getStudentItems(studentId);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", items);
            response.put("count", items.size());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("获取项目列表失败: " + e.getMessage()));
        }
    }

    /**
     * 学生按状态获取加分项目
     */
    @GetMapping("/{studentId}/score-items/status/{status}")
    public ResponseEntity<Map<String, Object>> getStudentScoreItemsByStatus(
            @PathVariable String studentId,
            @PathVariable Integer status) {
        try {
            // 验证状态值
            if (status < 0 || status > 2) {
                return ResponseEntity.badRequest().body(createErrorResponse("无效的状态值"));
            }

            List<ScoreItem> items = scoreItemService.getStudentItemsByStatus(studentId, status);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", items);
            response.put("count", items.size());

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("获取项目列表失败: " + e.getMessage()));
        }
    }

    /**
     * 学生重新提交被驳回的项目
     */
    @PostMapping("/{studentId}/resubmit/{itemId}")
    public ResponseEntity<Map<String, Object>> resubmitItem(
            @PathVariable String studentId,
            @PathVariable Long itemId) {

        try {
            boolean success = scoreItemService.resubmitItem(itemId, studentId);

            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "重新提交成功，等待审核");
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "重新提交失败：项目不存在或状态不正确");
                return ResponseEntity.badRequest().body(response);
            }
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("重新提交失败: " + e.getMessage()));
        }
    }

    /**
     * 学生查看单个项目详情
     */
    @GetMapping("/score-item/{id}")
    public ResponseEntity<Map<String, Object>> getScoreItemDetail(@PathVariable Long id) {
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

    /**
     * 学生统计信息
     */
    @GetMapping("/{studentId}/stats")
    public ResponseEntity<Map<String, Object>> getStudentStats(@PathVariable String studentId) {
        try {
            List<ScoreItem> allItems = scoreItemService.getStudentItems(studentId);

            long pendingCount = allItems.stream().filter(item -> item.isPending()).count();
            long approvedCount = allItems.stream().filter(item -> item.isApproved()).count();
            long rejectedCount = allItems.stream().filter(item -> item.isRejected()).count();

            // 计算总分（只计算已通过的项目）
            double totalScore = allItems.stream()
                    .filter(item -> item.isApproved())
                    .mapToDouble(item -> item.getItemScore().doubleValue())
                    .sum();

            Map<String, Object> stats = new HashMap<>();
            stats.put("totalItems", allItems.size());
            stats.put("pendingCount", pendingCount);
            stats.put("approvedCount", approvedCount);
            stats.put("rejectedCount", rejectedCount);
            stats.put("totalScore", totalScore);
            stats.put("approvalRate", allItems.size() > 0 ? (double) approvedCount / allItems.size() * 100 : 0);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", stats);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(500).body(createErrorResponse("获取统计信息失败: " + e.getMessage()));
        }
    }

    // 辅助方法：创建错误响应
    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        response.put("timestamp", System.currentTimeMillis());
        return response;
    }
}