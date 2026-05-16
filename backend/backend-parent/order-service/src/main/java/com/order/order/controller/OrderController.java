package com.order.order.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.order.common.Result;
import com.order.order.entity.Order;
import com.order.order.feign.ProductFeign;
import com.order.order.feign.UserFeign;
import com.order.order.mapper.OrderMapper;
import io.seata.spring.annotation.GlobalTransactional;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;
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

    @GlobalTransactional
    @RequestMapping(value = "/create/{userId}/{productId}", method = {RequestMethod.GET, RequestMethod.POST})
    public Result<String> createOrder(
            @PathVariable("userId") Long userId,
            @PathVariable("productId") Long productId
    ) {
        // ============ 第一步：检查阶段（不抛出异常，返回友好错误）===========
        
        // 1.校验用户
        Result<?> userRes = userFeign.getUserById(userId);
        if (userRes.getCode() != 200) {
            return Result.error("用户不存在");
        }
        
        // 2.获取商品信息（用于获取价格）
        Result<java.util.Map<String, Object>> productRes = productFeign.getProductById(productId);
        if (productRes.getCode() != 200 || productRes.getData() == null) {
            return Result.error("商品不存在");
        }
        Double price = (Double) productRes.getData().get("price");
        
        // 3.检查余额是否足够（在扣减前检查，返回友好错误）
        Result<Double> balanceRes = userFeign.getBalance(userId);
        if (balanceRes.getCode() != 200) {
            return Result.error("查询余额失败");
        }
        Double balance = balanceRes.getData();
        if (balance < price) {
            return Result.error("余额不足，当前余额：" + balance + "元，商品价格：" + price + "元");
        }
        
        // 4.检查库存是否足够（在扣减前检查，返回友好错误）
        Result<java.util.Map<String, Object>> productInfo = productFeign.getProductById(productId);
        if (productInfo.getCode() != 200) {
            return Result.error("查询商品信息失败");
        }
        Integer stock = (Integer) productInfo.getData().get("stock");
        if (stock == null || stock <= 0) {
            return Result.error("库存不足，无法下单");
        }
        
        // ============ 第二步：执行阶段（抛出异常触发Seata回滚）===========
        
        // 5.扣减库存
        Result<String> deductStock = productFeign.deductStock(productId);
        if (deductStock.getCode() != 200) {
            throw new RuntimeException("库存扣减失败");
        }
        
        // 6.扣减余额
        Result<String> deductMoney = userFeign.deductMoney(userId, price);
        if (deductMoney.getCode() != 200) {
            throw new RuntimeException("余额扣减失败");
        }
        
        // 7.创建订单
        Order order = new Order();
        order.setUserId(userId);
        order.setProductId(productId);
        order.setOrderNo(UUID.randomUUID().toString());
        orderMapper.insert(order);
        return Result.success("下单成功，订单号：" + order.getOrderNo());
    }

    @GlobalTransactional(rollbackFor = Exception.class)
    @GetMapping("/test/{userId}/{productId}")
    public Result<String> testCreateOrder(
            @PathVariable Long userId,
            @PathVariable Long productId
    ){
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

        // 4.手动抛出异常，触发Seata全局事务回滚
        throw new RuntimeException("模拟下单异常，Seata事务触发自动回滚");
    }

    @GetMapping("/list/{userId}")
    public Result<List<Order>> getOrderListByUserId(@PathVariable Long userId) {
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Order::getUserId, userId);
        List<Order> orders = orderMapper.selectList(wrapper);
        return Result.success(orders);
    }
}