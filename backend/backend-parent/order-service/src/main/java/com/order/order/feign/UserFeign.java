package com.order.order.feign;

import com.order.common.Result;
import com.order.common.entity.User;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient("user-service")
public interface UserFeign {
    @GetMapping("/user/{id}")
    Result<User> getUserById(@PathVariable("id") Long id);
}