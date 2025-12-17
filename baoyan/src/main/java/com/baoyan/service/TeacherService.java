package com.baoyan.service;

import com.baoyan.entity.Teacher;
import com.baoyan.mapper.TeacherMapper;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class TeacherService {

    @Resource
    private  TeacherMapper teacherMapper;

    // 教师登录
    public Teacher login(String id, String password) {
        return teacherMapper.login(id, password);
    }

    // 获取所有教师
    public List<Teacher> getAllTeachers() {
        return teacherMapper.findAll();
    }

    // 根据ID获取教师
    public Teacher getTeacherById(String id) {
        return teacherMapper.findById(id);
    }

    // 添加教师
    public void addTeacher(Teacher teacher) {
        teacherMapper.save(teacher);
    }

    // 更新教师
    public void updateTeacher(Teacher teacher) {
        teacherMapper.update(teacher);
    }

    // 删除教师
    public void deleteTeacher(String id) {
        teacherMapper.deleteById(id);
    }

    // 分页查询
    public List<Teacher> getTeachersByPage(Integer pageNum, Integer pageSize) {
        Integer offset = (pageNum - 1) * pageSize;
        return teacherMapper.findByPage(offset, pageSize);
    }

    // 获取教师总数
    public Integer countTeachers() {
        return teacherMapper.countTeachers();
    }
}
