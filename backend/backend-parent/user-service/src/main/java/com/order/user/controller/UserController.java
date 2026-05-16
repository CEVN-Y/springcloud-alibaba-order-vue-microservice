package com.order.user.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.order.common.Result;
import com.order.common.entity.User;
import com.order.user.mapper.UserMapper;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.math.BigDecimal;

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

    @GetMapping("/balance/{userId}")
    public Result<Double> getBalance(@PathVariable Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }
        return Result.success(user.getMoney().doubleValue());
    }

    @PostMapping("/login")
    public Result<User> login(@RequestBody User user) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, user.getUsername());
        wrapper.eq(User::getPassword, user.getPassword());

        User dbUser = userMapper.selectOne(wrapper);
        if (dbUser == null) {
            // 换成你项目里实际的失败方法，一般是 error
            return Result.error("用户名或密码错误");
        }
        return Result.success(dbUser);
    }

    @PostMapping("/register")
    public Result<String> register(@RequestBody User user) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, user.getUsername());
        User exist = userMapper.selectOne(wrapper);

        if (exist != null) {
            return Result.error("用户名已存在");
        }

        user.setMoney(new BigDecimal("0.00"));
        userMapper.insert(user);
        return Result.success("注册成功");
    }

    @PostMapping("/deduct/{userId}/{amount}")
    public Result<String> deductMoney(
            @PathVariable Long userId,
            @PathVariable Double amount
    ) {
        int i = userMapper.deductMoney(userId, amount);
        if (i > 0) return Result.success("扣减成功");
        return Result.error("余额不足");
    }

    @PostMapping("/recharge/{userId}/{amount}")
    public Result<String> recharge(
            @PathVariable Long userId,
            @PathVariable Double amount
    ) {
        if (amount <= 0) {
            return Result.error("充值金额必须大于0");
        }
        int i = userMapper.addMoney(userId, amount);
        if (i > 0) return Result.success("充值成功");
        return Result.error("充值失败");
    }
}