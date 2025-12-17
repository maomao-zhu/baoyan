package com.baoyan.mapper;

import com.baoyan.entity.Student;
import com.baoyan.vo.Page;
import org.apache.ibatis.annotations.*;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Mapper
public interface StudentMapper {

    // 搜索所有学生 - 使用新的表字段名
    @Select("SELECT * FROM student")
    List<Student> findAll();

    // 创建学生 - 修正为新的表结构
    @Insert("INSERT INTO student (id, name, password, profession, phone, picture, " +
            "base_score, total_score, studentRank, class_name, email, status, created_time) " +
            "VALUES (#{id}, #{name}, #{password}, #{profession}, #{phone}, #{picture}, " +
            "#{baseScore}, #{totalScore}, #{studentRank}, #{className}, #{email}, " +
            "COALESCE(#{status}, 1), NOW())")
    @Transactional
    void save(Student student);

    // 通过id修改学生信息 - 修正为新的表结构
    @Update("UPDATE student SET " +
            "name = #{name}, " +
            "password = #{password}, " +
            "profession = #{profession}, " +
            "phone = #{phone}, " +
            "picture = #{picture}, " +
            "base_score = #{baseScore}, " +
            "total_score = #{totalScore}, " +
            "student_Rank = #{studentRank}, " +
            "class_name = #{className}, " +
            "email = #{email}, " +
            "status = #{status}, " +
            "updated_time = NOW() " +
            "WHERE id = #{id}")
    @Transactional
    void updateByid(Student student);

    // 通过id删除学生 - 保持不变
    @Delete("DELETE FROM student WHERE id = #{id}")
    void deleteByid(String id);

    // 通过id查询学生 - 保持不变
    @Select("SELECT * FROM student WHERE id = #{id}")
    Student findByid(String id);

    // 分页查询 - 保持不变
    @Select("SELECT * FROM student LIMIT #{offset}, #{pageSize}")
    List<Student> findByPage(@Param("offset") Integer offset, @Param("pageSize") Integer pageSize);

    // 查询总记录数 - 保持不变
    @Select("SELECT COUNT(id) FROM student")
    Integer countStudents();
}