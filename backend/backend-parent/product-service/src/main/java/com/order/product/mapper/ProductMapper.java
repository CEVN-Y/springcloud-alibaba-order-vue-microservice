package com.order.product.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.order.product.entity.Product;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface ProductMapper extends BaseMapper<Product> {
    @Update("update t_product set stock = stock - 1 where id = #{id} and stock > 0")
    int deductStock(@Param("id") Long id);
}