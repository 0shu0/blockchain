-- 创建product表
CREATE TABLE `product` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT '产品名称',
  `origin` varchar(255) DEFAULT NULL COMMENT '产地',
  `manufacturer` varchar(255) DEFAULT NULL COMMENT '厂家',
  `trace_code` varchar(255) DEFAULT NULL COMMENT '产品码',
  `stock` int(11) DEFAULT NULL COMMENT '库存',
  `is_exist` tinyint(1) DEFAULT NULL COMMENT '是否存在',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 创建warehouse表
CREATE TABLE `warehouse` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `trace_code` varchar(255) DEFAULT NULL COMMENT '产品码',
  `amount` int(11) DEFAULT NULL COMMENT '数量',
  `send_date` datetime DEFAULT NULL COMMENT '发货日期',
  `origin` varchar(255) DEFAULT NULL COMMENT '产地',
  `name` varchar(255) DEFAULT NULL COMMENT '产品名称',
  `product_id` varchar(255) DEFAULT NULL COMMENT '产品ID',
  `recv_date` datetime DEFAULT NULL COMMENT '收货日期',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 插入测试数据
INSERT INTO `product` (`name`, `origin`, `manufacturer`, `trace_code`, `stock`, `is_exist`) VALUES
('玉米', '山东-济南', '山东省', '60810281-43e4-442e-b6ca-094c329d79d1', 100, 1),
('大米', '吉林-长春', '吉林省', '78264144-8f5b-42e6-a73b-570e5925986b', 50, 1),
('小麦', '河南-郑州', '河南省', 'bc768411-4314-4e0e-9ea0-3e89036112d6', 150, 1);

INSERT INTO `warehouse` (`trace_code`, `amount`, `send_date`, `origin`, `name`, `product_id`, `recv_date`) VALUES
('60810281-43e4-442e-b6ca-094c329d79d1', 100, '2026-04-09', '山东-济南', '玉米', '1', '2026-04-09'),
('78264144-8f5b-42e6-a73b-570e5925986b', 50, '2026-04-09', '吉林-长春', '大米', '2', '2026-04-09'),
('bc768411-4314-4e0e-9ea0-3e89036112d6', 150, '2026-04-09', '河南-郑州', '小麦', '3', '2026-04-09');