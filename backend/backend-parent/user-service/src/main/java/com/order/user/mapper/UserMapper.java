package com.order.user.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.order.common.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface UserMapper extends BaseMapper<User> {
    @Update("UPDATE t_user SET money = money - #{amount} WHERE id = #{userId} AND money >= #{amount}")
    int deductMoney(@Param("userId") Long userId, @Param("amount") Double amount);

    @Update("UPDATE t_user SET money = money + #{amount} WHERE id = #{userId}")
    int addMoney(@Param("userId") Long userId, @Param("amount") Double amount);
}