package com.order.order.controller;

import com.order.common.Result;
import com.order.order.entity.Order;
import com.order.order.feign.ProductFeign;
import com.order.order.feign.UserFeign;
import com.order.order.mapper.OrderMapper;
import io.seata.spring.annotation.GlobalTransactional;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.UUID;

@RestController
@RequestMapping("/order")
public class OrderController {
    @Resource
    private OrderMapper orderMapper;
    @Resource
    private UserFeign userFeign;
    @Resource
    private ProductFeign productFeign;

    // ✅ 同时支持 GET(测试) + POST(前端正式)，不影响任何业务！
    @GlobalTransactional
    @RequestMapping(value = "/create/{userId}/{productId}", method = {RequestMethod.GET, RequestMethod.POST})
    public Result<String> createOrder(
            @PathVariable("userId") Long userId,
            @PathVariable("productId") Long productId
    ) {
        // 1.校验用户
        userFeign.getUserById(userId);
        // 2.扣减库存
        Result<String> deduct = productFeign.deductStock(productId);
        if (deduct.getCode() != 200) {
            throw new RuntimeException("库存不足，下单失败");
        }
        // 3.创建订单
        Order order = new Order();
        order.setUserId(userId);
        order.setProductId(productId);
        order.setOrderNo(UUID.randomUUID().toString());
        orderMapper.insert(order);
        return Result.success("下单成功，订单号：" + order.getOrderNo());
    }
}