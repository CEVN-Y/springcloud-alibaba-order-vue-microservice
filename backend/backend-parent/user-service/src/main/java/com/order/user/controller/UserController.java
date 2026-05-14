package com.order.user.controller;

import com.order.common.Result;
import com.order.common.entity.User;
import com.order.user.mapper.UserMapper;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

@RestController
@RequestMapping("/user")
public class UserController {
    @Resource
    private UserMapper userMapper;

    @GetMapping("/{id}")
    public Result<User> getUserById(@PathVariable Long id) {
        User user = userMapper.selectById(id);
        return Result.success(user);
    }
}