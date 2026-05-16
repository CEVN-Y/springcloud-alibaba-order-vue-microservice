package com.order.product.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.order.common.Result;
import com.order.product.entity.Product;
import com.order.product.mapper.ProductMapper;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/product")
public class ProductController {
    @Resource
    private ProductMapper productMapper;

    @GetMapping("/{id}")
    public Result<Product> getById(@PathVariable Long id) {
        return Result.success(productMapper.selectById(id));
    }

    @GetMapping("/list")
    public Result<List<Product>> list() {
        return Result.success(productMapper.selectList(new LambdaQueryWrapper<>()));
    }

    @PostMapping("/deduct/{id}")
    public Result<String> deductStock(@PathVariable Long id) {
        int i = productMapper.deductStock(id);
        if (i > 0) return Result.success("扣减成功");
        return Result.error("库存不足");
    }
}