package com.order.order.feign;

import com.order.common.Result;
import com.order.common.entity.User;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

@FeignClient("user-service")
public interface UserFeign {
    @GetMapping("/user/{id}")
    Result<User> getUserById(@PathVariable("id") Long id);

    @GetMapping("/user/balance/{userId}")
    Result<Double> getBalance(@PathVariable("userId") Long userId);

    @PostMapping("/user/deduct/{userId}/{amount}")
    Result<String> deductMoney(@PathVariable("userId") Long userId, @PathVariable("amount") Double amount);
}