package com.baoyan.mapper;

import com.baoyan.entity.Admin;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface AdminMapper {

    // 管理员登录
    @Select("SELECT * FROM admin WHERE username = #{username} AND password = #{password}")
    Admin login(@Param("username") String username, @Param("password") String password);

    // 根据ID查询
    @Select("SELECT * FROM admin WHERE id = #{id}")
    Admin findById(Integer id);

    // 根据用户名查询
    @Select("SELECT * FROM admin WHERE username = #{username}")
    Admin findByUsername(String username);

    // 查询所有管理员
    @Select("SELECT * FROM admin")
    List<Admin> findAll();

    // 添加管理员
    @Insert("INSERT INTO admin (username, name, password, role, permissions, status, " +
            "phone, email, created_time) " +
            "VALUES (#{username}, #{name}, #{password}, #{role}, #{permissions}, #{status}, " +
            "#{phone}, #{email}, NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    void save(Admin admin);

    // 更新管理员信息
    @Update("UPDATE admin SET " +
            "name = #{name}, " +
            "password = #{password}, " +
            "role = #{role}, " +
            "permissions = #{permissions}, " +
            "status = #{status}, " +
            "phone = #{phone}, " +
            "email = #{email}, " +
            "last_login_time = #{lastLoginTime} " +
            "WHERE id = #{id}")
    void update(Admin admin);

    // 删除管理员
    @Delete("DELETE FROM admin WHERE id = #{id}")
    void deleteById(Integer id);

    // 分页查询
    @Select("SELECT * FROM admin LIMIT #{offset}, #{pageSize}")
    List<Admin> findByPage(@Param("offset") Integer offset, @Param("pageSize") Integer pageSize);

    // 查询管理员总数
    @Select("SELECT COUNT(*) FROM admin")
    Integer countAdmins();

    // 更新最后登录时间
    @Update("UPDATE admin SET last_login_time = NOW() WHERE id = #{id}")
    void updateLastLoginTime(Integer id);
}