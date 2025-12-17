package com.baoyan.service;

import com.baoyan.entity.Admin;
import com.baoyan.mapper.AdminMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class AdminService {

    @Resource
    private AdminMapper adminMapper;

    // 管理员登录
    public Admin login(String username, String password) {
        Admin admin = adminMapper.login(username, password);
        if (admin != null) {
            // 更新最后登录时间
            adminMapper.updateLastLoginTime(admin.getId());
        }
        return admin;
    }

    // 获取所有管理员
    public List<Admin> getAllAdmins() {
        return adminMapper.findAll();
    }

    // 根据ID获取管理员
    public Admin getAdminById(Integer id) {
        return adminMapper.findById(id);
    }

    // 添加管理员
    public Admin addAdmin(Admin admin) {
        // 设置默认值
        if (admin.getStatus() == null) {
            admin.setStatus(1); // 默认启用
        }
        if (admin.getRole() == null) {
            admin.setRole("admin"); // 默认普通管理员
        }

        adminMapper.save(admin);
        return admin;
    }

    // 更新管理员
    public void updateAdmin(Admin admin) {
        adminMapper.update(admin);
    }

    // 删除管理员
    public void deleteAdmin(Integer id) {
        adminMapper.deleteById(id);
    }

    // 分页查询
    public List<Admin> getAdminsByPage(Integer pageNum, Integer pageSize) {
        Integer offset = (pageNum - 1) * pageSize;
        return adminMapper.findByPage(offset, pageSize);
    }

    // 获取管理员总数
    public Integer countAdmins() {
        return adminMapper.countAdmins();
    }

    // 检查用户名是否存在
    public boolean usernameExists(String username) {
        return adminMapper.findByUsername(username) != null;
    }

    // 启用/禁用管理员
    public void toggleAdminStatus(Integer id, Integer status) {
        Admin admin = adminMapper.findById(id);
        if (admin != null) {
            admin.setStatus(status);
            adminMapper.update(admin);
        }
    }
}
