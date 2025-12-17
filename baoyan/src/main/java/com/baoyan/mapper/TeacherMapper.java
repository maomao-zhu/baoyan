package com.baoyan.mapper;

import com.baoyan.entity.Teacher;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface TeacherMapper {

    // 查询所有教师
    @Select("SELECT * FROM teacher")
    List<Teacher> findAll();

    // 根据ID查询教师
    @Select("SELECT * FROM teacher WHERE id = #{id}")
    Teacher findById(String id);

    // 教师登录验证
    @Select("SELECT * FROM teacher WHERE id = #{id} AND password = #{password}")
    Teacher login(@Param("id") String id, @Param("password") String password);

    // 创建教师
    @Insert("INSERT INTO teacher (id, name, password, profession, phone, picture, " +
            "title, department, email, status, can_audit) " +
            "VALUES (#{id}, #{name}, #{password}, #{profession}, #{phone}, #{picture}, " +
            "#{title}, #{department}, #{email}, #{status}, #{canAudit})")
    void save(Teacher teacher);

    // 更新教师信息
    @Update("UPDATE teacher SET " +
            "name = #{name}, " +
            "password = #{password}, " +
            "profession = #{profession}, " +
            "phone = #{phone}, " +
            "picture = #{picture}, " +
            "title = #{title}, " +
            "department = #{department}, " +
            "email = #{email}, " +
            "status = #{status}, " +
            "can_audit = #{canAudit}, " +
            "updated_time = NOW() " +
            "WHERE id = #{id}")
    void update(Teacher teacher);

    // 删除教师
    @Delete("DELETE FROM teacher WHERE id = #{id}")
    void deleteById(String id);

    // 分页查询
    @Select("SELECT * FROM teacher LIMIT #{offset}, #{pageSize}")
    List<Teacher> findByPage(@Param("offset") Integer offset, @Param("pageSize") Integer pageSize);

    // 查询教师总数
    @Select("SELECT COUNT(*) FROM teacher")
    Integer countTeachers();

    // 根据专业查询教师
    @Select("SELECT * FROM teacher WHERE profession = #{profession}")
    List<Teacher> findByProfession(String profession);
}
