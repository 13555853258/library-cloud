package com.library.book; import com.baomidou.mybatisplus.annotation.*; import lombok.Data; import java.time.LocalDateTime; @Data @TableName("publisher") public class Publisher{@TableId(type=IdType.AUTO)private Long id;private String name;private String address;private String contactPhone;private Integer status;private LocalDateTime createdAt;@TableLogic private Integer deleted;}

