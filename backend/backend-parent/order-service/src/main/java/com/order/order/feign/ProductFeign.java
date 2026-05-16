package com.order.order.feign;

import com.order.common.Result;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.Map;

@FeignClient("product-service")
public interface ProductFeign {
    @PostMapping("/product/deduct/{id}")
    Result<String> deductStock(@PathVariable("id") Long id);

    @GetMapping("/product/{id}")
    Result<Map<String, Object>> getProductById(@PathVariable("id") Long id);
}