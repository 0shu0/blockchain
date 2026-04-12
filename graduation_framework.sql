/*
 Navicat Premium Data Transfer

 Source Server         : 本地
 Source Server Type    : MySQL
 Source Server Version : 50735 (5.7.35-log)
 Source Host           : LOCALHOST:3306
 Source Schema         : bcos_trace

 Target Server Type    : MySQL
 Target Server Version : 50735 (5.7.35-log)
 File Encoding         : 65001

 Date: 08/12/2024 16:12:41
*/

-- ===============================================================
-- 数据库初始化脚本
-- 文件名: graduation_framework.sql
-- 描述: 区块链农产品溯源系统的数据库表结构和初始数据
-- 包含表: notice, product, shop, sys_dict, sys_file, sys_log
-- 系统功能: 基于区块链技术的农产品溯源管理系统
-- ===============================================================

-- 设置字符集为 utf8mb4，支持中文等多语言
SET NAMES utf8mb4;
-- 暂时禁用外键约束检查，加快导入速度
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for notice
-- ----------------------------
-- 公告表
-- 用途: 存储系统公告信息，如活动通知、重要事项等
-- 字段说明:
--   id: 自增主键，唯一标识
--   title: 公告标题，不能为空
--   content: 公告内容，不能为空，最大长度1000字符
--   user: 创建者，可为空
--   create_time: 创建时间，默认当前时间戳
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告标题',
  `content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '公告内容',
  `user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建者',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------
-- 区块链农产品溯源系统相关公告
INSERT INTO `notice` VALUES (1, '区块链农产品溯源系统上线通知', '我司基于区块链技术的农产品溯源系统正式上线，该系统可实现农产品从种植、加工、运输到销售的全流程追溯，确保食品安全。', 'admin', '2023-09-10 11:39:40');
INSERT INTO `notice` VALUES (2, '农产品区块链溯源技术培训', '将于本周五举办区块链农产品溯源技术培训，主要内容包括区块链原理、溯源流程操作、数据上链等，欢迎相关人员参加。', 'admin', '2023-09-12 06:57:44');
INSERT INTO `notice` VALUES (3, '区块链溯源系统功能更新', '系统已更新，新增农产品生长环境监测数据上链功能，可实时查看农产品的种植环境数据，如温度、湿度、光照等。', 'admin', '2023-09-12 12:42:54');
INSERT INTO `notice` VALUES (4, '农产品溯源码使用说明', '所有农产品包装上已添加区块链溯源码，消费者可通过扫描二维码查看产品的详细信息，包括产地、种植过程、检测报告等。', 'admin', '2023-09-12 12:43:07');
INSERT INTO `notice` VALUES (5, '区块链技术在农业中的应用研讨会', '下周将举办区块链技术在农业中的应用研讨会，探讨如何利用区块链技术提升农业生产效率和农产品安全性。', 'admin', '2023-09-12 12:43:16');
INSERT INTO `notice` VALUES (6, '系统维护通知', '本周末系统将进行维护升级，期间可能会短暂影响系统使用，请提前做好相关准备。', 'admin', '2023-09-12 12:43:20');
INSERT INTO `notice` VALUES (7, '农产品溯源数据标准更新', '根据最新行业标准，系统已更新农产品溯源数据标准，确保数据的准确性和一致性。', 'admin', '2023-09-12 12:43:22');

-- ----------------------------
-- Table structure for product
-- ----------------------------
-- 产品表
-- 用途: 存储产品基本信息，用于产品溯源系统
-- 字段说明:
--   id: 产品ID，字符串类型，不能为空，作为主键
--   name: 产品名称，不能为空
--   origin: 产地，不能为空
--   manufacturer: 厂家，不能为空
--   traceCode: 溯源码，不能为空，用于产品追溯
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '产品名称',
  `origin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '产地',
  `manufacturer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '厂家',
  `traceCode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '溯源码',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product
-- ----------------------------
-- 区块链农产品溯源系统产品数据
INSERT INTO `product` VALUES ('P001', '有机大米', '黑龙江五常', '五常有机农业合作社', 'BLOCKCHAIN_20230901_001');
INSERT INTO `product` VALUES ('P002', '绿色蔬菜', '山东寿光', '寿光绿色蔬菜基地', 'BLOCKCHAIN_20230902_002');
INSERT INTO `product` VALUES ('P003', '生态水果', '陕西洛川', '洛川苹果种植园', 'BLOCKCHAIN_20230903_003');
INSERT INTO `product` VALUES ('P004', '有机猪肉', '河南漯河', '漯河生态养殖基地', 'BLOCKCHAIN_20230904_004');
INSERT INTO `product` VALUES ('P005', '有机鸡蛋', '河北唐山', '唐山有机养殖场', 'BLOCKCHAIN_20230905_005');



-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
-- 系统字典表
-- 用途: 存储系统中的字典数据，如图标、类型等配置信息
-- 字段说明:
--   id: 自增主键，唯一标识
--   name: 字典名称，不能为空
--   value: 字典值，不能为空
--   type: 字典类型，不能为空
-- 示例: 存储图标类型数据，如 el-icon-user 等
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '名称',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '值',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 281 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES (1, 'user', 'el-icon-user', 'icon');
INSERT INTO `sys_dict` VALUES (2, 'house', 'el-icon-house', 'icon');
INSERT INTO `sys_dict` VALUES (3, 'menu', 'el-icon-menu', 'icon');
INSERT INTO `sys_dict` VALUES (4, 's-custom', 'el-icon-s-custom', 'icon');
INSERT INTO `sys_dict` VALUES (5, 's-grid', 'el-icon-s-grid', 'icon');
INSERT INTO `sys_dict` VALUES (6, 'document', 'el-icon-document', 'icon');
INSERT INTO `sys_dict` VALUES (7, 'coffee', 'el-icon-coffee\r\n', 'icon');
INSERT INTO `sys_dict` VALUES (8, 's-marketing', 'el-icon-s-marketing', 'icon');
INSERT INTO `sys_dict` VALUES (9, 'phone-outline', 'el-icon-phone-outline', 'icon');
INSERT INTO `sys_dict` VALUES (10, 'platform-eleme', 'el-icon-platform-eleme', 'icon');
INSERT INTO `sys_dict` VALUES (11, 'eleme', 'el-icon-eleme', 'icon');
INSERT INTO `sys_dict` VALUES (12, 'delete-solid', 'el-icon-delete-solid', 'icon');
INSERT INTO `sys_dict` VALUES (13, 'delete', 'el-icon-delete', 'icon');
INSERT INTO `sys_dict` VALUES (14, 's-tools', 'el-icon-s-tools', 'icon');
INSERT INTO `sys_dict` VALUES (15, 'setting', 'el-icon-setting', 'icon');
INSERT INTO `sys_dict` VALUES (16, 'user-solid', 'el-icon-user-solid', 'icon');
INSERT INTO `sys_dict` VALUES (17, 'phone', 'el-icon-phone', 'icon');
INSERT INTO `sys_dict` VALUES (18, 'more', 'el-icon-more', 'icon');
INSERT INTO `sys_dict` VALUES (19, 'more-outline', 'el-icon-more-outline', 'icon');
INSERT INTO `sys_dict` VALUES (20, 'star-on', 'el-icon-star-on', 'icon');
INSERT INTO `sys_dict` VALUES (21, 'star-off', 'el-icon-star-off', 'icon');
INSERT INTO `sys_dict` VALUES (22, 's-goods', 'el-icon-s-goods', 'icon');
INSERT INTO `sys_dict` VALUES (23, 'goods', 'el-icon-goods', 'icon');
INSERT INTO `sys_dict` VALUES (24, 'warning', 'el-icon-warning', 'icon');
INSERT INTO `sys_dict` VALUES (25, 'warning-outline', 'el-icon-warning-outline', 'icon');
INSERT INTO `sys_dict` VALUES (26, 'question', 'el-icon-question', 'icon');
INSERT INTO `sys_dict` VALUES (27, 'info', 'el-icon-info', 'icon');
INSERT INTO `sys_dict` VALUES (28, 'remove', 'el-icon-remove', 'icon');
INSERT INTO `sys_dict` VALUES (29, 'circle-plus', 'el-icon-circle-plus', 'icon');
INSERT INTO `sys_dict` VALUES (30, 'success', 'el-icon-success', 'icon');
INSERT INTO `sys_dict` VALUES (31, 'error', 'el-icon-error', 'icon');
INSERT INTO `sys_dict` VALUES (32, 'zoom-in', 'el-icon-zoom-in', 'icon');
INSERT INTO `sys_dict` VALUES (33, 'zoom-out', 'el-icon-zoom-out', 'icon');
INSERT INTO `sys_dict` VALUES (34, 'remove-outline', 'el-icon-remove-outline', 'icon');
INSERT INTO `sys_dict` VALUES (35, 'circle-plus-outline', 'el-icon-circle-plus-outline', 'icon');
INSERT INTO `sys_dict` VALUES (36, 'circle-check', 'el-icon-circle-check', 'icon');
INSERT INTO `sys_dict` VALUES (37, 'circle-close', 'el-icon-circle-close', 'icon');
INSERT INTO `sys_dict` VALUES (38, 's-help', 'el-icon-s-help', 'icon');
INSERT INTO `sys_dict` VALUES (39, 'help', 'el-icon-help', 'icon');
INSERT INTO `sys_dict` VALUES (40, 'minus', 'el-icon-minus', 'icon');
INSERT INTO `sys_dict` VALUES (41, 'plus', 'el-icon-plus', 'icon');
INSERT INTO `sys_dict` VALUES (42, 'check', 'el-icon-check', 'icon');
INSERT INTO `sys_dict` VALUES (43, 'close', 'el-icon-close', 'icon');
INSERT INTO `sys_dict` VALUES (44, 'picture', 'el-icon-picture', 'icon');
INSERT INTO `sys_dict` VALUES (45, 'picture-outline', 'el-icon-picture-outline', 'icon');
INSERT INTO `sys_dict` VALUES (46, 'picture-outline-round', 'el-icon-picture-outline-round', 'icon');
INSERT INTO `sys_dict` VALUES (47, 'upload', 'el-icon-upload', 'icon');
INSERT INTO `sys_dict` VALUES (48, 'upload2', 'el-icon-upload2', 'icon');
INSERT INTO `sys_dict` VALUES (49, 'download', 'el-icon-download', 'icon');
INSERT INTO `sys_dict` VALUES (50, 'camera-solid', 'el-icon-camera-solid', 'icon');
INSERT INTO `sys_dict` VALUES (51, 'camera', 'el-icon-camera', 'icon');
INSERT INTO `sys_dict` VALUES (52, 'video-camera-solid', 'el-icon-video-camera-solid', 'icon');
INSERT INTO `sys_dict` VALUES (53, 'video-camera', 'el-icon-video-camera', 'icon');
INSERT INTO `sys_dict` VALUES (54, 'message-solid', 'el-icon-message-solid', 'icon');
INSERT INTO `sys_dict` VALUES (55, 'bell', 'el-icon-bell', 'icon');
INSERT INTO `sys_dict` VALUES (56, 's-cooperation', 'el-icon-s-cooperation', 'icon');
INSERT INTO `sys_dict` VALUES (57, 's-order', 'el-icon-s-order', 'icon');
INSERT INTO `sys_dict` VALUES (58, 's-platform', 'el-icon-s-platform', 'icon');
INSERT INTO `sys_dict` VALUES (59, 's-fold', 'el-icon-s-fold', 'icon');
INSERT INTO `sys_dict` VALUES (60, 's-unfold', 'el-icon-s-unfold', 'icon');
INSERT INTO `sys_dict` VALUES (61, 's-operation', 'el-icon-s-operation', 'icon');
INSERT INTO `sys_dict` VALUES (62, 's-promotion', 'el-icon-s-promotion', 'icon');
INSERT INTO `sys_dict` VALUES (63, 's-home', 'el-icon-s-home', 'icon');
INSERT INTO `sys_dict` VALUES (64, 's-release', 'el-icon-s-release', 'icon');
INSERT INTO `sys_dict` VALUES (65, 's-ticket', 'el-icon-s-ticket', 'icon');
INSERT INTO `sys_dict` VALUES (66, 's-management', 'el-icon-s-management', 'icon');
INSERT INTO `sys_dict` VALUES (67, 's-open', 'el-icon-s-open', 'icon');
INSERT INTO `sys_dict` VALUES (68, 's-shop', 'el-icon-s-shop', 'icon');
INSERT INTO `sys_dict` VALUES (69, 's-flag', 'el-icon-s-flag', 'icon');
INSERT INTO `sys_dict` VALUES (70, 's-comment', 'el-icon-s-comment', 'icon');
INSERT INTO `sys_dict` VALUES (71, 's-finance', 'el-icon-s-finance', 'icon');
INSERT INTO `sys_dict` VALUES (72, 's-claim', 'el-icon-s-claim', 'icon');
INSERT INTO `sys_dict` VALUES (73, 's-opportunity', 'el-icon-s-opportunity', 'icon');
INSERT INTO `sys_dict` VALUES (74, 's-data', 'el-icon-s-data', 'icon');
INSERT INTO `sys_dict` VALUES (75, 's-check', 'el-icon-s-check', 'icon');
INSERT INTO `sys_dict` VALUES (76, 'share', 'el-icon-share', 'icon');
INSERT INTO `sys_dict` VALUES (77, 'd-caret', 'el-icon-d-caret', 'icon');
INSERT INTO `sys_dict` VALUES (78, 'caret-left', 'el-icon-caret-left', 'icon');
INSERT INTO `sys_dict` VALUES (79, 'caret-right', 'el-icon-caret-right', 'icon');
INSERT INTO `sys_dict` VALUES (80, 'caret-bottom', 'el-icon-caret-bottom', 'icon');
INSERT INTO `sys_dict` VALUES (81, 'caret-top', 'el-icon-caret-top', 'icon');
INSERT INTO `sys_dict` VALUES (82, 'bottom-left', 'el-icon-bottom-left', 'icon');
INSERT INTO `sys_dict` VALUES (83, 'bottom-right', 'el-icon-bottom-right', 'icon');
INSERT INTO `sys_dict` VALUES (84, 'back', 'el-icon-back', 'icon');
INSERT INTO `sys_dict` VALUES (85, 'right', 'el-icon-right', 'icon');
INSERT INTO `sys_dict` VALUES (86, 'bottom', 'el-icon-bottom', 'icon');
INSERT INTO `sys_dict` VALUES (87, 'top', 'el-icon-top', 'icon');
INSERT INTO `sys_dict` VALUES (88, 'top-left', 'el-icon-top-left', 'icon');
INSERT INTO `sys_dict` VALUES (89, 'top-right', 'el-icon-top-right', 'icon');
INSERT INTO `sys_dict` VALUES (90, 'arrow-left', 'el-icon-arrow-left', 'icon');
INSERT INTO `sys_dict` VALUES (91, 'arrow-right', 'el-icon-arrow-right', 'icon');
INSERT INTO `sys_dict` VALUES (92, 'arrow-down', 'el-icon-arrow-down', 'icon');
INSERT INTO `sys_dict` VALUES (93, 'arrow-up', 'el-icon-arrow-up', 'icon');
INSERT INTO `sys_dict` VALUES (94, 'd-arrow-left', 'el-icon-d-arrow-left', 'icon');
INSERT INTO `sys_dict` VALUES (95, 'd-arrow-right', 'el-icon-d-arrow-right', 'icon');
INSERT INTO `sys_dict` VALUES (96, 'video-pause', 'el-icon-video-pause', 'icon');
INSERT INTO `sys_dict` VALUES (97, 'video-play', 'el-icon-video-play', 'icon');
INSERT INTO `sys_dict` VALUES (98, 'refresh', 'el-icon-refresh', 'icon');
INSERT INTO `sys_dict` VALUES (99, 'refresh-right', 'el-icon-refresh-right', 'icon');
INSERT INTO `sys_dict` VALUES (100, 'refresh-left', 'el-icon-refresh-left', 'icon');
INSERT INTO `sys_dict` VALUES (101, 'finished', 'el-icon-finished', 'icon');
INSERT INTO `sys_dict` VALUES (102, 'sort', 'el-icon-sort', 'icon');
INSERT INTO `sys_dict` VALUES (103, 'sort-up', 'el-icon-sort-up', 'icon');
INSERT INTO `sys_dict` VALUES (104, 'sort-down', 'el-icon-sort-down', 'icon');
INSERT INTO `sys_dict` VALUES (105, 'rank', 'el-icon-rank', 'icon');
INSERT INTO `sys_dict` VALUES (106, 'loading', 'el-icon-loading', 'icon');
INSERT INTO `sys_dict` VALUES (107, 'view', 'el-icon-view', 'icon');
INSERT INTO `sys_dict` VALUES (108, 'c-scale-to-original', 'el-icon-c-scale-to-original', 'icon');
INSERT INTO `sys_dict` VALUES (109, 'date', 'el-icon-date', 'icon');
INSERT INTO `sys_dict` VALUES (110, 'edit', 'el-icon-edit', 'icon');
INSERT INTO `sys_dict` VALUES (111, 'edit-outline', 'el-icon-edit-outline', 'icon');
INSERT INTO `sys_dict` VALUES (112, 'folder', 'el-icon-folder', 'icon');
INSERT INTO `sys_dict` VALUES (113, 'folder-opened', 'el-icon-folder-opened', 'icon');
INSERT INTO `sys_dict` VALUES (114, 'folder-add', 'el-icon-folder-add', 'icon');
INSERT INTO `sys_dict` VALUES (115, 'folder-remove', 'el-icon-folder-remove', 'icon');
INSERT INTO `sys_dict` VALUES (116, 'folder-delete', 'el-icon-folder-delete', 'icon');
INSERT INTO `sys_dict` VALUES (117, 'folder-checked', 'el-icon-folder-checked', 'icon');
INSERT INTO `sys_dict` VALUES (118, 'tickets', 'el-icon-tickets', 'icon');
INSERT INTO `sys_dict` VALUES (119, 'document-remove', 'el-icon-document-remove', 'icon');
INSERT INTO `sys_dict` VALUES (120, 'document-delete', 'el-icon-document-delete', 'icon');
INSERT INTO `sys_dict` VALUES (121, 'document-copy', 'el-icon-document-copy', 'icon');
INSERT INTO `sys_dict` VALUES (122, 'document-checked', 'el-icon-document-checked', 'icon');
INSERT INTO `sys_dict` VALUES (123, 'document-add', 'el-icon-document-add', 'icon');
INSERT INTO `sys_dict` VALUES (124, 'printer', 'el-icon-printer', 'icon');
INSERT INTO `sys_dict` VALUES (125, 'paperclip', 'el-icon-paperclip', 'icon');
INSERT INTO `sys_dict` VALUES (126, 'takeaway-box', 'el-icon-takeaway-box', 'icon');
INSERT INTO `sys_dict` VALUES (127, 'search', 'el-icon-search', 'icon');
INSERT INTO `sys_dict` VALUES (128, 'monitor', 'el-icon-monitor', 'icon');
INSERT INTO `sys_dict` VALUES (129, 'attract', 'el-icon-attract', 'icon');
INSERT INTO `sys_dict` VALUES (130, 'mobile', 'el-icon-mobile', 'icon');
INSERT INTO `sys_dict` VALUES (131, 'scissors', 'el-icon-scissors', 'icon');
INSERT INTO `sys_dict` VALUES (132, 'umbrella', 'el-icon-umbrella', 'icon');
INSERT INTO `sys_dict` VALUES (133, 'headset', 'el-icon-headset', 'icon');
INSERT INTO `sys_dict` VALUES (134, 'brush', 'el-icon-brush', 'icon');
INSERT INTO `sys_dict` VALUES (135, 'mouse', 'el-icon-mouse', 'icon');
INSERT INTO `sys_dict` VALUES (136, 'coordinate', 'el-icon-coordinate', 'icon');
INSERT INTO `sys_dict` VALUES (137, 'magic-stick', 'el-icon-magic-stick', 'icon');
INSERT INTO `sys_dict` VALUES (138, 'reading', 'el-icon-reading', 'icon');
INSERT INTO `sys_dict` VALUES (139, 'data-line', 'el-icon-data-line', 'icon');
INSERT INTO `sys_dict` VALUES (140, 'data-board', 'el-icon-data-board', 'icon');
INSERT INTO `sys_dict` VALUES (141, 'pie-chart', 'el-icon-pie-chart', 'icon');
INSERT INTO `sys_dict` VALUES (142, 'data-analysis', 'el-icon-data-analysis', 'icon');
INSERT INTO `sys_dict` VALUES (143, 'collection-tag', 'el-icon-collection-tag', 'icon');
INSERT INTO `sys_dict` VALUES (144, 'film', 'el-icon-film', 'icon');
INSERT INTO `sys_dict` VALUES (145, 'suitcase', 'el-icon-suitcase', 'icon');
INSERT INTO `sys_dict` VALUES (146, 'suitcase-1', 'el-icon-suitcase-1', 'icon');
INSERT INTO `sys_dict` VALUES (147, 'receiving', 'el-icon-receiving', 'icon');
INSERT INTO `sys_dict` VALUES (148, 'collection', 'el-icon-collection', 'icon');
INSERT INTO `sys_dict` VALUES (149, 'files', 'el-icon-files', 'icon');
INSERT INTO `sys_dict` VALUES (150, 'notebook-1', 'el-icon-notebook-1', 'icon');
INSERT INTO `sys_dict` VALUES (151, 'notebook-2', 'el-icon-notebook-2', 'icon');
INSERT INTO `sys_dict` VALUES (152, 'toilet-paper', 'el-icon-toilet-paper', 'icon');
INSERT INTO `sys_dict` VALUES (153, 'office-building', 'el-icon-office-building', 'icon');
INSERT INTO `sys_dict` VALUES (154, 'school', 'el-icon-school', 'icon');
INSERT INTO `sys_dict` VALUES (155, 'table-lamp', 'el-icon-table-lamp', 'icon');
INSERT INTO `sys_dict` VALUES (156, 'no-smoking', 'el-icon-no-smoking', 'icon');
INSERT INTO `sys_dict` VALUES (157, 'smoking', 'el-icon-smoking', 'icon');
INSERT INTO `sys_dict` VALUES (158, 'shopping-cart-full', 'el-icon-shopping-cart-full', 'icon');
INSERT INTO `sys_dict` VALUES (159, 'shopping-cart-1', 'el-icon-shopping-cart-1', 'icon');
INSERT INTO `sys_dict` VALUES (160, 'shopping-cart-2', 'el-icon-shopping-cart-2', 'icon');
INSERT INTO `sys_dict` VALUES (161, 'shopping-bag-1', 'el-icon-shopping-bag-1', 'icon');
INSERT INTO `sys_dict` VALUES (162, 'shopping-bag-2', 'el-icon-shopping-bag-2', 'icon');
INSERT INTO `sys_dict` VALUES (163, 'sold-out', 'el-icon-sold-out', 'icon');
INSERT INTO `sys_dict` VALUES (164, 'sell', 'el-icon-sell', 'icon');
INSERT INTO `sys_dict` VALUES (165, 'present', 'el-icon-present', 'icon');
INSERT INTO `sys_dict` VALUES (166, 'box', 'el-icon-box', 'icon');
INSERT INTO `sys_dict` VALUES (167, 'bank-card', 'el-icon-bank-card', 'icon');
INSERT INTO `sys_dict` VALUES (168, 'money', 'el-icon-money', 'icon');
INSERT INTO `sys_dict` VALUES (169, 'coin', 'el-icon-coin', 'icon');
INSERT INTO `sys_dict` VALUES (170, 'wallet', 'el-icon-wallet', 'icon');
INSERT INTO `sys_dict` VALUES (171, 'discount', 'el-icon-discount', 'icon');
INSERT INTO `sys_dict` VALUES (172, 'price-tag', 'el-icon-price-tag', 'icon');
INSERT INTO `sys_dict` VALUES (173, 'news', 'el-icon-news', 'icon');
INSERT INTO `sys_dict` VALUES (174, 'guide', 'el-icon-guide', 'icon');
INSERT INTO `sys_dict` VALUES (175, 'male', 'el-icon-male', 'icon');
INSERT INTO `sys_dict` VALUES (176, 'female', 'el-icon-female', 'icon');
INSERT INTO `sys_dict` VALUES (177, 'thumb', 'el-icon-thumb', 'icon');
INSERT INTO `sys_dict` VALUES (178, 'cpu', 'el-icon-cpu', 'icon');
INSERT INTO `sys_dict` VALUES (179, 'link', 'el-icon-link', 'icon');
INSERT INTO `sys_dict` VALUES (180, 'connection', 'el-icon-connection', 'icon');
INSERT INTO `sys_dict` VALUES (181, 'open', 'el-icon-open', 'icon');
INSERT INTO `sys_dict` VALUES (182, 'turn-off', 'el-icon-turn-off', 'icon');
INSERT INTO `sys_dict` VALUES (183, 'set-up', 'el-icon-set-up', 'icon');
INSERT INTO `sys_dict` VALUES (184, 'chat-round', 'el-icon-chat-round', 'icon');
INSERT INTO `sys_dict` VALUES (185, 'chat-line-round', 'el-icon-chat-line-round', 'icon');
INSERT INTO `sys_dict` VALUES (186, 'chat-square', 'el-icon-chat-square', 'icon');
INSERT INTO `sys_dict` VALUES (187, 'chat-dot-round', 'el-icon-chat-dot-round', 'icon');
INSERT INTO `sys_dict` VALUES (188, 'chat-dot-square', 'el-icon-chat-dot-square', 'icon');
INSERT INTO `sys_dict` VALUES (189, 'chat-line-square', 'el-icon-chat-line-square', 'icon');
INSERT INTO `sys_dict` VALUES (190, 'message', 'el-icon-message', 'icon');
INSERT INTO `sys_dict` VALUES (191, 'postcard', 'el-icon-postcard', 'icon');
INSERT INTO `sys_dict` VALUES (192, 'position', 'el-icon-position', 'icon');
INSERT INTO `sys_dict` VALUES (193, 'turn-off-microphone', 'el-icon-turn-off-microphone', 'icon');
INSERT INTO `sys_dict` VALUES (194, 'microphone', 'el-icon-microphone', 'icon');
INSERT INTO `sys_dict` VALUES (195, 'close-notification', 'el-icon-close-notification', 'icon');
INSERT INTO `sys_dict` VALUES (196, 'bangzhu', 'el-icon-bangzhu', 'icon');
INSERT INTO `sys_dict` VALUES (197, 'time', 'el-icon-time', 'icon');
INSERT INTO `sys_dict` VALUES (198, 'odometer', 'el-icon-odometer', 'icon');
INSERT INTO `sys_dict` VALUES (199, 'crop', 'el-icon-crop', 'icon');
INSERT INTO `sys_dict` VALUES (200, 'aim', 'el-icon-aim', 'icon');
INSERT INTO `sys_dict` VALUES (201, 'switch-button', 'el-icon-switch-button', 'icon');
INSERT INTO `sys_dict` VALUES (202, 'full-screen', 'el-icon-full-screen', 'icon');
INSERT INTO `sys_dict` VALUES (203, 'copy-document', 'el-icon-copy-document', 'icon');
INSERT INTO `sys_dict` VALUES (204, 'mic', 'el-icon-mic', 'icon');
INSERT INTO `sys_dict` VALUES (205, 'stopwatch', 'el-icon-stopwatch', 'icon');
INSERT INTO `sys_dict` VALUES (206, 'medal-1', 'el-icon-medal-1', 'icon');
INSERT INTO `sys_dict` VALUES (207, 'medal', 'el-icon-medal', 'icon');
INSERT INTO `sys_dict` VALUES (208, 'trophy', 'el-icon-trophy', 'icon');
INSERT INTO `sys_dict` VALUES (209, 'trophy-1', 'el-icon-trophy-1', 'icon');
INSERT INTO `sys_dict` VALUES (210, 'first-aid-kit', 'el-icon-first-aid-kit', 'icon');
INSERT INTO `sys_dict` VALUES (211, 'discover', 'el-icon-discover', 'icon');
INSERT INTO `sys_dict` VALUES (212, 'place', 'el-icon-place', 'icon');
INSERT INTO `sys_dict` VALUES (213, 'location', 'el-icon-location', 'icon');
INSERT INTO `sys_dict` VALUES (214, 'location-outline', 'el-icon-location-outline', 'icon');
INSERT INTO `sys_dict` VALUES (215, 'location-information', 'el-icon-location-information', 'icon');
INSERT INTO `sys_dict` VALUES (216, 'add-location', 'el-icon-add-location', 'icon');
INSERT INTO `sys_dict` VALUES (217, 'delete-location', 'el-icon-delete-location', 'icon');
INSERT INTO `sys_dict` VALUES (218, 'map-location', 'el-icon-map-location', 'icon');
INSERT INTO `sys_dict` VALUES (219, 'alarm-clock', 'el-icon-alarm-clock', 'icon');
INSERT INTO `sys_dict` VALUES (220, 'timer', 'el-icon-timer', 'icon');
INSERT INTO `sys_dict` VALUES (221, 'watch-1', 'el-icon-watch-1', 'icon');
INSERT INTO `sys_dict` VALUES (222, 'watch', 'el-icon-watch', 'icon');
INSERT INTO `sys_dict` VALUES (223, 'lock', 'el-icon-lock', 'icon');
INSERT INTO `sys_dict` VALUES (224, 'unlock', 'el-icon-unlock', 'icon');
INSERT INTO `sys_dict` VALUES (225, 'key', 'el-icon-key', 'icon');
INSERT INTO `sys_dict` VALUES (226, 'service', 'el-icon-service', 'icon');
INSERT INTO `sys_dict` VALUES (227, 'mobile-phone', 'el-icon-mobile-phone', 'icon');
INSERT INTO `sys_dict` VALUES (228, 'bicycle', 'el-icon-bicycle', 'icon');
INSERT INTO `sys_dict` VALUES (229, 'truck', 'el-icon-truck', 'icon');
INSERT INTO `sys_dict` VALUES (230, 'ship', 'el-icon-ship', 'icon');
INSERT INTO `sys_dict` VALUES (231, 'basketball', 'el-icon-basketball', 'icon');
INSERT INTO `sys_dict` VALUES (232, 'football', 'el-icon-football', 'icon');
INSERT INTO `sys_dict` VALUES (233, 'soccer', 'el-icon-soccer', 'icon');
INSERT INTO `sys_dict` VALUES (234, 'baseball', 'el-icon-baseball', 'icon');
INSERT INTO `sys_dict` VALUES (235, 'wind-power', 'el-icon-wind-power', 'icon');
INSERT INTO `sys_dict` VALUES (236, 'light-rain', 'el-icon-light-rain', 'icon');
INSERT INTO `sys_dict` VALUES (237, 'lightning', 'el-icon-lightning', 'icon');
INSERT INTO `sys_dict` VALUES (238, 'heavy-rain', 'el-icon-heavy-rain', 'icon');
INSERT INTO `sys_dict` VALUES (239, 'sunrise', 'el-icon-sunrise', 'icon');
INSERT INTO `sys_dict` VALUES (240, 'sunrise-1', 'el-icon-sunrise-1', 'icon');
INSERT INTO `sys_dict` VALUES (241, 'sunset', 'el-icon-sunset', 'icon');
INSERT INTO `sys_dict` VALUES (242, 'sunny', 'el-icon-sunny', 'icon');
INSERT INTO `sys_dict` VALUES (243, 'cloudy', 'el-icon-cloudy', 'icon');
INSERT INTO `sys_dict` VALUES (244, 'partly-cloudy', 'el-icon-partly-cloudy', 'icon');
INSERT INTO `sys_dict` VALUES (245, 'cloudy-and-sunny', 'el-icon-cloudy-and-sunny', 'icon');
INSERT INTO `sys_dict` VALUES (246, 'moon', 'el-icon-moon', 'icon');
INSERT INTO `sys_dict` VALUES (247, 'moon-night', 'el-icon-moon-night', 'icon');
INSERT INTO `sys_dict` VALUES (248, 'dish', 'el-icon-dish', 'icon');
INSERT INTO `sys_dict` VALUES (249, 'dish-1', 'el-icon-dish-1', 'icon');
INSERT INTO `sys_dict` VALUES (250, 'food', 'el-icon-food', 'icon');
INSERT INTO `sys_dict` VALUES (251, 'chicken', 'el-icon-chicken', 'icon');
INSERT INTO `sys_dict` VALUES (252, 'fork-spoon', 'el-icon-fork-spoon', 'icon');
INSERT INTO `sys_dict` VALUES (253, 'knife-fork', 'el-icon-knife-fork', 'icon');
INSERT INTO `sys_dict` VALUES (254, 'burger', 'el-icon-burger', 'icon');
INSERT INTO `sys_dict` VALUES (255, 'tableware', 'el-icon-tableware', 'icon');
INSERT INTO `sys_dict` VALUES (256, 'sugar', 'el-icon-sugar', 'icon');
INSERT INTO `sys_dict` VALUES (257, 'dessert', 'el-icon-dessert', 'icon');
INSERT INTO `sys_dict` VALUES (258, 'ice-cream', 'el-icon-ice-cream', 'icon');
INSERT INTO `sys_dict` VALUES (259, 'hot-water', 'el-icon-hot-water', 'icon');
INSERT INTO `sys_dict` VALUES (260, 'water-cup', 'el-icon-water-cup', 'icon');
INSERT INTO `sys_dict` VALUES (261, 'coffee-cup', 'el-icon-coffee-cup', 'icon');
INSERT INTO `sys_dict` VALUES (262, 'cold-drink', 'el-icon-cold-drink', 'icon');
INSERT INTO `sys_dict` VALUES (263, 'goblet', 'el-icon-goblet', 'icon');
INSERT INTO `sys_dict` VALUES (264, 'goblet-full', 'el-icon-goblet-full', 'icon');
INSERT INTO `sys_dict` VALUES (265, 'goblet-square', 'el-icon-goblet-square', 'icon');
INSERT INTO `sys_dict` VALUES (266, 'goblet-square-full', 'el-icon-goblet-square-full', 'icon');
INSERT INTO `sys_dict` VALUES (267, 'refrigerator', 'el-icon-refrigerator', 'icon');
INSERT INTO `sys_dict` VALUES (268, 'grape', 'el-icon-grape', 'icon');
INSERT INTO `sys_dict` VALUES (269, 'watermelon', 'el-icon-watermelon', 'icon');
INSERT INTO `sys_dict` VALUES (270, 'cherry', 'el-icon-cherry', 'icon');
INSERT INTO `sys_dict` VALUES (271, 'apple', 'el-icon-apple', 'icon');
INSERT INTO `sys_dict` VALUES (272, 'pear', 'el-icon-pear', 'icon');
INSERT INTO `sys_dict` VALUES (273, 'orange', 'el-icon-orange', 'icon');
INSERT INTO `sys_dict` VALUES (274, 'ice-tea', 'el-icon-ice-tea', 'icon');
INSERT INTO `sys_dict` VALUES (275, 'ice-drink', 'el-icon-ice-drink', 'icon');
INSERT INTO `sys_dict` VALUES (276, 'milk-tea', 'el-icon-milk-tea', 'icon');
INSERT INTO `sys_dict` VALUES (277, 'potato-strips', 'el-icon-potato-strips', 'icon');
INSERT INTO `sys_dict` VALUES (278, 'lollipop', 'el-icon-lollipop', 'icon');
INSERT INTO `sys_dict` VALUES (279, 'ice-cream-square', 'el-icon-ice-cream-square', 'icon');
INSERT INTO `sys_dict` VALUES (280, 'ice-cream-round', 'el-icon-ice-cream-round', 'icon');

-- ----------------------------
-- Table structure for sys_file
-- ----------------------------
-- 系统文件表
-- 用途: 存储系统上传的文件信息，如图片、文档等
-- 字段说明:
--   id: 自增主键，唯一标识
--   name: 文件名称
--   type: 文件类型，如 png、pdf 等
--   size: 文件大小，单位为 KB
--   url: 文件下载链接
--   md5: 文件MD5值，用于判断文件唯一性
--   is_delete: 删除状态，0：未删除，1：已删除
--   enable: 启用状态，0：未启用，1：启用
DROP TABLE IF EXISTS `sys_file`;
CREATE TABLE `sys_file`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件名称',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件类型',
  `size` bigint(20) NULL DEFAULT NULL COMMENT '文件大小(kb)',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '下载链接',
  `md5` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '文件md5，判断文件唯一的标识',
  `is_delete` tinyint(1) NULL DEFAULT 0 COMMENT '0：不删除，1：已经删除',
  `enable` tinyint(4) NULL DEFAULT 1 COMMENT '是否启用，0：不启用，1：启用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 78 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_file
-- ----------------------------
-- 区块链农产品溯源系统文件数据
INSERT INTO `sys_file` VALUES (7, '区块链农产品溯源系统使用手册.pdf', 'pdf', 34742, 'http://localhost:8888/sysFile/blockchain_manual.pdf', 'e23a6f83c7bdd311ad27c3d2702c8f23', 1, 1);
INSERT INTO `sys_file` VALUES (8, '有机大米种植流程图.png', 'png', 418, 'http://localhost:8888/sysFile/rice_planting.png', 'd68fb00dae6dbb72dd541c3678b662f3', 1, 1);
INSERT INTO `sys_file` VALUES (9, '区块链技术在农业中的应用.pptx', 'pptx', 56789, 'http://localhost:8888/sysFile/blockchain_agriculture.pptx', '2ed3d62ef431f3d883ea426f24715032', 1, 1);
INSERT INTO `sys_file` VALUES (10, '农产品溯源码生成规范.pdf', 'pdf', 12345, 'http://localhost:8888/sysFile/trace_code_spec.pdf', '1944e19dc424c426bfb599b36b61c2c8', 1, 1);
INSERT INTO `sys_file` VALUES (11, '系统架构图.png', 'png', 150, 'http://localhost:8888/sysFile/system_architecture.png', '3a9988addd4555fc7232d3a068b73b9c', 1, 1);
INSERT INTO `sys_file` VALUES (12, '有机蔬菜检测报告.pdf', 'pdf', 23456, 'http://localhost:8888/sysFile/vegetable_test_report.pdf', '8746bd3582a01e93ec6c2167986ce935', 1, 1);
INSERT INTO `sys_file` VALUES (13, '区块链农产品溯源系统logo.png', 'png', 7, 'http://localhost:8888/sysFile/blockchain_logo.png', '34ef6a22d96758e116001241f292f26c', 1, 1);
INSERT INTO `sys_file` VALUES (14, '生态水果种植基地照片.jpg', 'jpg', 190, 'http://localhost:8888/sysFile/fruit_farm.jpg', 'd0c89de5c0fec38a2453a659500c7fc6', 1, 1);
INSERT INTO `sys_file` VALUES (15, '系统操作培训视频.mp4', 'mp4', 123456, 'http://localhost:8888/sysFile/system_training.mp4', 'd28bde3177efd4f6a0e45e0ec3559362', 1, 1);
INSERT INTO `sys_file` VALUES (16, '农产品溯源数据标准.xlsx', 'xlsx', 89012, 'http://localhost:8888/sysFile/trace_data_standard.xlsx', '54e81fb10b52f93ca441c62465b18b2e', 1, 1);

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
-- 系统日志表
-- 用途: 存储系统操作日志，记录用户的操作行为
-- 字段说明:
--   id: 自增主键，唯一标识
--   username: 操作人
--   record: 操作记录，描述具体操作内容
--   type: 操作类型，如查询、新增、修改、删除等
--   create_time: 创建时间，默认当前时间戳
DROP TABLE IF EXISTS `sys_log`;
CREATE TABLE `sys_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作人',
  `record` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作记录',
  `type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作类型',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 336 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_log
-- ----------------------------
-- 区块链农产品溯源系统操作日志
INSERT INTO `sys_log` VALUES (8, 'admin', '新增有机大米产品信息', '新增', '2023-09-05 20:47:24');
INSERT INTO `sys_log` VALUES (9, 'admin', '生成有机大米溯源码', '新增', '2023-09-05 20:47:33');
INSERT INTO `sys_log` VALUES (10, 'admin', '查询产品列表', '查询', '2023-09-05 20:51:32');
INSERT INTO `sys_log` VALUES (11, 'admin', '上传有机大米种植环境数据', '上传', '2023-09-05 20:51:37');
INSERT INTO `sys_log` VALUES (12, 'admin', '修改绿色蔬菜产品信息', '修改', '2023-09-05 20:51:47');
INSERT INTO `sys_log` VALUES (13, 'admin', '查询产品溯源信息', '查询', '2023-09-05 20:51:47');
INSERT INTO `sys_log` VALUES (14, 'admin', '删除过期产品信息', '删除', '2023-09-05 20:52:01');
INSERT INTO `sys_log` VALUES (15, 'admin', '查询系统公告', '查询', '2023-09-05 20:52:01');
INSERT INTO `sys_log` VALUES (16, 'admin', '上传有机蔬菜检测报告', '上传', '2023-09-05 20:52:01');
INSERT INTO `sys_log` VALUES (17, 'admin', '新增生态水果产品信息', '新增', '2023-09-05 20:52:22');
INSERT INTO `sys_log` VALUES (18, 'admin', '生成生态水果溯源码', '新增', '2023-09-05 20:52:22');
INSERT INTO `sys_log` VALUES (19, 'admin', '查询产品销售记录', '查询', '2023-09-05 20:52:24');
INSERT INTO `sys_log` VALUES (20, 'admin', '上传生态水果种植基地照片', '上传', '2023-09-05 20:52:29');
INSERT INTO `sys_log` VALUES (21, 'admin', '查询系统文件', '查询', '2023-09-05 20:52:29');
INSERT INTO `sys_log` VALUES (22, 'admin', '修改系统公告', '修改', '2023-09-05 20:52:29');
INSERT INTO `sys_log` VALUES (23, 'admin', '查询有机猪肉产品信息', '查询', '2023-09-07 07:35:01');
INSERT INTO `sys_log` VALUES (24, 'admin', '生成有机猪肉溯源码', '新增', '2023-09-07 07:36:36');
INSERT INTO `sys_log` VALUES (25, 'admin', '上传有机猪肉养殖数据', '上传', '2023-09-07 07:37:34');
INSERT INTO `sys_log` VALUES (26, 'admin', '查询有机鸡蛋产品信息', '查询', '2023-09-07 07:38:33');
INSERT INTO `sys_log` VALUES (27, 'admin', '生成有机鸡蛋溯源码', '新增', '2023-09-07 07:38:35');
INSERT INTO `sys_log` VALUES (28, 'admin', '上传有机鸡蛋检测报告', '上传', '2023-09-07 07:39:27');
INSERT INTO `sys_log` VALUES (29, 'admin', '查询系统操作日志', '查询', '2023-09-07 07:39:32');
INSERT INTO `sys_log` VALUES (30, 'admin', '导出产品溯源数据', '导出', '2023-09-07 07:43:55');
INSERT INTO `sys_log` VALUES (31, 'admin', '导入产品销售数据', '导入', '2023-09-07 07:43:57');
INSERT INTO `sys_log` VALUES (32, 'admin', '查询产品库存', '查询', '2023-09-07 07:44:07');
INSERT INTO `sys_log` VALUES (33, 'admin', '修改系统设置', '修改', '2023-09-07 07:44:27');
INSERT INTO `sys_log` VALUES (34, 'admin', '查询系统字典', '查询', '2023-09-07 07:44:28');
INSERT INTO `sys_log` VALUES (35, 'admin', '新增系统公告', '新增', '2023-09-07 12:36:09');
INSERT INTO `sys_log` VALUES (36, 'admin', '上传系统使用手册', '上传', '2023-09-07 12:36:11');
INSERT INTO `sys_log` VALUES (37, 'admin', '查询系统文件列表', '查询', '2023-09-07 12:36:14');
INSERT INTO `sys_log` VALUES (38, 'admin', '修改产品价格信息', '修改', '2023-09-07 18:31:22');
INSERT INTO `sys_log` VALUES (39, 'admin', '查询产品溯源记录', '查询', '2023-09-07 18:31:23');
INSERT INTO `sys_log` VALUES (40, 'admin', '上传系统培训视频', '上传', '2023-09-07 18:31:25');
INSERT INTO `sys_log` VALUES (41, 'admin', '查询系统公告列表', '查询', '2023-09-09 08:18:56');
INSERT INTO `sys_log` VALUES (42, 'admin', '修改系统公告', '修改', '2023-09-09 08:19:00');
INSERT INTO `sys_log` VALUES (43, 'admin', '查询产品销售统计', '查询', '2023-09-09 08:20:44');
INSERT INTO `sys_log` VALUES (44, 'admin', '导出销售报表', '导出', '2023-09-09 08:20:55');
INSERT INTO `sys_log` VALUES (45, 'admin', '查询系统用户', '查询', '2023-09-09 08:22:25');
INSERT INTO `sys_log` VALUES (46, 'admin', '修改用户权限', '修改', '2023-09-09 08:22:26');
INSERT INTO `sys_log` VALUES (47, 'admin', '查询系统日志', '查询', '2023-09-09 08:23:15');
INSERT INTO `sys_log` VALUES (48, 'admin', '上传系统架构图', '上传', '2023-09-09 08:31:35');
INSERT INTO `sys_log` VALUES (49, 'admin', '查询系统文件', '查询', '2023-09-09 08:31:37');
INSERT INTO `sys_log` VALUES (50, 'admin', '修改系统配置', '修改', '2023-09-09 08:31:38');
INSERT INTO `sys_log` VALUES (51, 'admin', '查询产品库存', '查询', '2023-09-09 08:32:09');
INSERT INTO `sys_log` VALUES (52, 'admin', '新增产品库存', '新增', '2023-09-09 08:33:49');
INSERT INTO `sys_log` VALUES (53, 'admin', '修改产品库存', '修改', '2023-09-09 08:34:16');
INSERT INTO `sys_log` VALUES (54, 'admin', '删除过期库存', '删除', '2023-09-09 08:34:23');
INSERT INTO `sys_log` VALUES (55, 'admin', '查询系统字典', '查询', '2023-09-09 08:35:14');
INSERT INTO `sys_log` VALUES (56, 'admin', '修改系统字典', '修改', '2023-09-09 08:41:09');
INSERT INTO `sys_log` VALUES (57, 'admin', '查询系统文件', '查询', '2023-09-09 08:41:09');
INSERT INTO `sys_log` VALUES (58, 'admin', '上传系统数据标准', '上传', '2023-09-09 08:41:53');
INSERT INTO `sys_log` VALUES (59, 'admin', '查询产品溯源码', '查询', '2023-09-09 08:44:21');
INSERT INTO `sys_log` VALUES (60, 'admin', '生成产品溯源码', '新增', '2023-09-09 08:45:00');
INSERT INTO `sys_log` VALUES (61, 'admin', '上传产品检测报告', '上传', '2023-09-09 08:45:01');
INSERT INTO `sys_log` VALUES (62, 'admin', '查询产品检测报告', '查询', '2023-09-09 08:45:06');
INSERT INTO `sys_log` VALUES (63, 'admin', '修改产品检测报告', '修改', '2023-09-09 08:45:07');
INSERT INTO `sys_log` VALUES (64, 'admin', '查询系统公告', '查询', '2023-09-09 08:49:03');
INSERT INTO `sys_log` VALUES (65, 'admin', '新增系统公告', '新增', '2023-09-09 08:49:04');
INSERT INTO `sys_log` VALUES (66, 'admin', '查询系统文件', '查询', '2023-09-09 15:17:05');
INSERT INTO `sys_log` VALUES (67, 'admin', '上传有机大米种植流程图', '上传', '2023-09-09 15:22:55');
INSERT INTO `sys_log` VALUES (68, 'admin', '上传区块链技术应用PPT', '上传', '2023-09-09 15:31:05');
INSERT INTO `sys_log` VALUES (69, 'admin', '上传农产品溯源码生成规范', '上传', '2023-09-09 15:32:23');
INSERT INTO `sys_log` VALUES (70, 'admin', '上传系统操作培训视频', '上传', '2023-09-09 15:33:02');
INSERT INTO `sys_log` VALUES (71, 'admin', '上传农产品溯源数据标准', '上传', '2023-09-09 15:33:24');
INSERT INTO `sys_log` VALUES (72, 'admin', '上传生态水果种植基地照片', '上传', '2023-09-09 15:33:59');
INSERT INTO `sys_log` VALUES (73, 'admin', '上传有机蔬菜检测报告', '上传', '2023-09-09 15:34:13');
INSERT INTO `sys_log` VALUES (74, 'admin', '上传系统架构图', '上传', '2023-09-09 15:36:29');
INSERT INTO `sys_log` VALUES (75, 'admin', '上传区块链农产品溯源系统logo', '上传', '2023-09-09 15:36:46');
INSERT INTO `sys_log` VALUES (76, 'admin', '查询系统日志', '查询', '2023-09-09 16:37:43');
INSERT INTO `sys_log` VALUES (77, 'admin', '导出系统操作日志', '导出', '2023-09-09 19:03:02');
INSERT INTO `sys_log` VALUES (78, 'admin', '查询系统文件', '查询', '2023-09-09 19:03:07');
INSERT INTO `sys_log` VALUES (79, 'admin', '查询全部字典', '查询', '2023-09-09 19:03:54');
INSERT INTO `sys_log` VALUES (80, 'admin', '查询全部字典', '查询', '2023-09-09 19:04:01');
INSERT INTO `sys_log` VALUES (81, 'admin', '查询全部字典', '查询', '2023-09-09 19:04:04');
INSERT INTO `sys_log` VALUES (82, 'admin', '查询文件分页', '查询', '2023-09-09 19:04:17');
INSERT INTO `sys_log` VALUES (83, 'admin', '查询文件分页', '查询', '2023-09-09 19:04:48');
INSERT INTO `sys_log` VALUES (84, 'admin', '查询文件分页', '查询', '2023-09-09 19:05:43');
INSERT INTO `sys_log` VALUES (85, 'admin', '查询文件分页', '查询', '2023-09-09 19:06:40');
INSERT INTO `sys_log` VALUES (86, 'admin', '查询文件分页', '查询', '2023-09-09 19:07:51');
INSERT INTO `sys_log` VALUES (87, 'admin', '查询文件分页', '查询', '2023-09-09 19:10:08');
INSERT INTO `sys_log` VALUES (88, 'admin', '查询文件分页', '查询', '2023-09-09 19:12:07');
INSERT INTO `sys_log` VALUES (89, 'admin', '查询文件分页', '查询', '2023-09-09 19:13:53');
INSERT INTO `sys_log` VALUES (90, 'admin', '查询文件分页', '查询', '2023-09-09 19:16:09');
INSERT INTO `sys_log` VALUES (91, 'admin', 'updateEnable', '修改', '2023-09-09 19:16:13');
INSERT INTO `sys_log` VALUES (92, 'admin', '查询文件分页', '查询', '2023-09-09 19:16:16');
INSERT INTO `sys_log` VALUES (93, 'admin', 'updateEnable', '修改', '2023-09-09 19:16:17');
INSERT INTO `sys_log` VALUES (94, 'admin', '查询文件分页', '查询', '2023-09-09 19:16:55');
INSERT INTO `sys_log` VALUES (95, 'admin', '查询文件分页', '查询', '2023-09-09 19:17:15');
INSERT INTO `sys_log` VALUES (96, 'admin', 'updateEnable', '修改', '2023-09-09 19:17:33');
INSERT INTO `sys_log` VALUES (97, 'admin', 'updateEnable', '修改', '2023-09-09 19:17:34');
INSERT INTO `sys_log` VALUES (98, 'admin', 'updateEnable', '修改', '2023-09-09 19:17:46');
INSERT INTO `sys_log` VALUES (99, 'admin', '查询文件分页', '查询', '2023-09-09 19:17:46');
INSERT INTO `sys_log` VALUES (100, 'admin', '查询文件分页', '查询', '2023-09-09 19:18:16');
INSERT INTO `sys_log` VALUES (101, 'admin', '查询文件分页', '查询', '2023-09-09 19:19:04');
INSERT INTO `sys_log` VALUES (102, 'admin', '查询全部字典', '查询', '2023-09-09 19:19:16');
INSERT INTO `sys_log` VALUES (103, 'admin', '查询文件分页', '查询', '2023-09-09 19:19:18');
INSERT INTO `sys_log` VALUES (104, 'admin', '查询文件分页', '查询', '2023-09-09 19:19:46');
INSERT INTO `sys_log` VALUES (105, 'admin', '查询文件分页', '查询', '2023-09-09 19:24:51');
INSERT INTO `sys_log` VALUES (106, 'admin', '查询文件分页', '查询', '2023-09-09 19:24:52');
INSERT INTO `sys_log` VALUES (107, 'admin', '查询文件分页', '查询', '2023-09-09 19:24:54');
INSERT INTO `sys_log` VALUES (108, 'admin', '根据id删除文件', '删除', '2023-09-09 19:25:00');
INSERT INTO `sys_log` VALUES (109, 'admin', '查询文件分页', '查询', '2023-09-09 19:25:00');
INSERT INTO `sys_log` VALUES (110, 'admin', '查询文件分页', '查询', '2023-09-09 19:25:00');
INSERT INTO `sys_log` VALUES (111, 'admin', '查询文件分页', '查询', '2023-09-09 19:25:22');
INSERT INTO `sys_log` VALUES (112, 'admin', '查询文件分页', '查询', '2023-09-09 19:25:26');
INSERT INTO `sys_log` VALUES (113, 'admin', '查询文件分页', '查询', '2023-09-09 19:25:57');
INSERT INTO `sys_log` VALUES (114, 'admin', '查询文件分页', '查询', '2023-09-09 19:26:18');
INSERT INTO `sys_log` VALUES (115, 'admin', '查询文件分页', '查询', '2023-09-09 19:26:27');
INSERT INTO `sys_log` VALUES (116, 'admin', '查询文件分页', '查询', '2023-09-09 19:29:01');
INSERT INTO `sys_log` VALUES (117, 'admin', '批量删除文件', '删除', '2023-09-09 19:29:41');
INSERT INTO `sys_log` VALUES (118, 'admin', '查询文件分页', '查询', '2023-09-09 19:29:41');
INSERT INTO `sys_log` VALUES (119, 'admin', '查询文件分页', '查询', '2023-09-09 19:29:41');
INSERT INTO `sys_log` VALUES (120, 'admin', '查询文件分页', '查询', '2023-09-09 20:17:41');
INSERT INTO `sys_log` VALUES (121, 'admin', '查询文件分页', '查询', '2023-09-10 07:44:07');
INSERT INTO `sys_log` VALUES (122, 'admin', '查询文件分页', '查询', '2023-09-10 08:48:17');
INSERT INTO `sys_log` VALUES (123, 'admin', '查询文件分页', '查询', '2023-09-10 08:54:55');
INSERT INTO `sys_log` VALUES (124, 'admin', '查询字典分页', '查询', '2023-09-10 09:23:59');
INSERT INTO `sys_log` VALUES (125, 'admin', '查询文件分页', '查询', '2023-09-10 09:24:11');
INSERT INTO `sys_log` VALUES (126, 'admin', '查询字典分页', '查询', '2023-09-10 09:47:25');
INSERT INTO `sys_log` VALUES (127, 'admin', '查询全部字典', '查询', '2023-09-10 09:47:27');
INSERT INTO `sys_log` VALUES (128, 'admin', '查询全部字典', '查询', '2023-09-10 09:48:23');
INSERT INTO `sys_log` VALUES (129, 'admin', '查询文件分页', '查询', '2023-09-10 09:49:02');
INSERT INTO `sys_log` VALUES (130, 'admin', '查询文件分页', '查询', '2023-09-10 09:58:57');
INSERT INTO `sys_log` VALUES (131, 'admin', '查询文件分页', '查询', '2023-09-10 09:58:57');
INSERT INTO `sys_log` VALUES (132, 'admin', '查询文件分页', '查询', '2023-09-10 09:59:08');
INSERT INTO `sys_log` VALUES (133, 'admin', '查询文件分页', '查询', '2023-09-10 09:59:08');
INSERT INTO `sys_log` VALUES (134, 'admin', '查询文件分页', '查询', '2023-09-10 09:59:28');
INSERT INTO `sys_log` VALUES (135, 'admin', '查询文件分页', '查询', '2023-09-10 09:59:37');
INSERT INTO `sys_log` VALUES (136, 'admin', '查询文件分页', '查询', '2023-09-10 10:00:27');
INSERT INTO `sys_log` VALUES (137, 'admin', '查询文件分页', '查询', '2023-09-10 10:01:29');
INSERT INTO `sys_log` VALUES (138, 'admin', '批量删除文件', '删除', '2023-09-10 10:01:44');
INSERT INTO `sys_log` VALUES (139, 'admin', '查询文件分页', '查询', '2023-09-10 10:01:51');
INSERT INTO `sys_log` VALUES (140, 'admin', '查询文件分页', '查询', '2023-09-10 10:01:52');
INSERT INTO `sys_log` VALUES (141, 'admin', '查询文件分页', '查询', '2023-09-10 10:02:04');
INSERT INTO `sys_log` VALUES (142, 'admin', '查询文件分页', '查询', '2023-09-10 10:04:08');
INSERT INTO `sys_log` VALUES (143, 'admin', '查询文件分页', '查询', '2023-09-10 10:04:18');
INSERT INTO `sys_log` VALUES (144, 'admin', '查询文件分页', '查询', '2023-09-10 10:04:31');
INSERT INTO `sys_log` VALUES (145, 'admin', '查询文件分页', '查询', '2023-09-10 10:04:51');
INSERT INTO `sys_log` VALUES (146, 'admin', '查询文件分页', '查询', '2023-09-10 10:05:18');
INSERT INTO `sys_log` VALUES (147, 'admin', '查询文件分页', '查询', '2023-09-10 10:08:55');
INSERT INTO `sys_log` VALUES (148, 'admin', '查询文件分页', '查询', '2023-09-10 10:09:04');
INSERT INTO `sys_log` VALUES (149, 'admin', '查询文件分页', '查询', '2023-09-10 10:10:13');
INSERT INTO `sys_log` VALUES (150, 'admin', '查询文件分页', '查询', '2023-09-10 10:10:22');
INSERT INTO `sys_log` VALUES (151, 'admin', '查询文件分页', '查询', '2023-09-10 10:12:29');
INSERT INTO `sys_log` VALUES (152, 'admin', '查询文件分页', '查询', '2023-09-10 10:12:31');
INSERT INTO `sys_log` VALUES (153, 'admin', '查询文件分页', '查询', '2023-09-10 10:12:40');
INSERT INTO `sys_log` VALUES (154, 'admin', '批量删除文件', '删除', '2023-09-10 10:15:22');
INSERT INTO `sys_log` VALUES (155, 'admin', '查询文件分页', '查询', '2023-09-10 10:15:22');
INSERT INTO `sys_log` VALUES (156, 'admin', '查询文件分页', '查询', '2023-09-10 10:15:22');
INSERT INTO `sys_log` VALUES (157, 'admin', '查询文件分页', '查询', '2023-09-10 10:17:04');
INSERT INTO `sys_log` VALUES (158, 'admin', '查询文件分页', '查询', '2023-09-10 10:22:00');
INSERT INTO `sys_log` VALUES (159, 'admin', '查询文件分页', '查询', '2023-09-10 10:25:52');
INSERT INTO `sys_log` VALUES (160, 'admin', '查询字典分页', '查询', '2023-09-10 11:37:07');
INSERT INTO `sys_log` VALUES (161, 'admin', '查询全部字典', '查询', '2023-09-10 11:38:32');
INSERT INTO `sys_log` VALUES (162, 'admin', '查询全部字典', '查询', '2023-09-10 11:39:22');
INSERT INTO `sys_log` VALUES (163, 'admin', '查询字典分页', '查询', '2023-09-10 11:54:08');
INSERT INTO `sys_log` VALUES (164, 'admin', '查询全部字典', '查询', '2023-09-10 11:54:08');
INSERT INTO `sys_log` VALUES (165, 'admin', '查询全部字典', '查询', '2023-09-10 11:55:26');
INSERT INTO `sys_log` VALUES (166, 'admin', '查询文件分页', '查询', '2023-09-10 13:46:24');
INSERT INTO `sys_log` VALUES (167, 'admin', '查询文件分页', '查询', '2023-09-10 14:26:20');
INSERT INTO `sys_log` VALUES (168, 'admin', '查询文件分页', '查询', '2023-09-10 14:30:47');
INSERT INTO `sys_log` VALUES (169, 'admin', '查询文件分页', '查询', '2023-09-10 15:07:08');
INSERT INTO `sys_log` VALUES (170, 'admin', '查询文件分页', '查询', '2023-09-10 15:57:46');
INSERT INTO `sys_log` VALUES (171, 'admin', '查询文件分页', '查询', '2023-09-10 16:25:51');
INSERT INTO `sys_log` VALUES (172, 'admin', '查询文件分页', '查询', '2023-09-10 16:57:30');
INSERT INTO `sys_log` VALUES (173, 'admin', '查询全部字典', '查询', '2023-09-10 16:57:31');
INSERT INTO `sys_log` VALUES (174, 'admin', '查询字典分页', '查询', '2023-09-10 16:57:32');
INSERT INTO `sys_log` VALUES (175, 'admin', '查询字典分页', '查询', '2023-09-10 18:06:37');
INSERT INTO `sys_log` VALUES (176, 'admin', '查询全部字典', '查询', '2023-09-10 18:06:39');
INSERT INTO `sys_log` VALUES (177, 'admin', '查询全部字典', '查询', '2023-09-10 18:07:08');
INSERT INTO `sys_log` VALUES (178, 'admin', '查询字典分页', '查询', '2023-09-10 18:07:13');
INSERT INTO `sys_log` VALUES (179, 'admin', '查询全部字典', '查询', '2023-09-10 18:07:14');
INSERT INTO `sys_log` VALUES (180, 'admin', '查询字典分页', '查询', '2023-09-10 18:10:38');
INSERT INTO `sys_log` VALUES (181, 'admin', '查询全部字典', '查询', '2023-09-10 18:10:38');
INSERT INTO `sys_log` VALUES (182, 'admin', '查询全部字典', '查询', '2023-09-10 18:10:49');
INSERT INTO `sys_log` VALUES (183, 'admin', '查询全部字典', '查询', '2023-09-10 18:53:30');
INSERT INTO `sys_log` VALUES (184, 'admin', '查询全部字典', '查询', '2023-09-10 18:53:42');
INSERT INTO `sys_log` VALUES (185, 'admin', '查询文件分页', '查询', '2023-09-10 18:54:28');
INSERT INTO `sys_log` VALUES (186, 'admin', '查询全部字典', '查询', '2023-09-10 18:54:32');
INSERT INTO `sys_log` VALUES (187, 'admin', '查询全部字典', '查询', '2023-09-10 18:54:36');
INSERT INTO `sys_log` VALUES (188, 'admin', '查询文件分页', '查询', '2023-09-10 18:54:59');
INSERT INTO `sys_log` VALUES (189, 'admin', '查询字典分页', '查询', '2023-09-10 18:55:19');
INSERT INTO `sys_log` VALUES (190, 'admin', '查询文件分页', '查询', '2023-09-11 08:13:57');
INSERT INTO `sys_log` VALUES (191, 'admin', '查询全部字典', '查询', '2023-09-11 08:13:59');
INSERT INTO `sys_log` VALUES (192, 'admin', '查询全部字典', '查询', '2023-09-11 12:40:00');
INSERT INTO `sys_log` VALUES (193, 'admin', '查询全部字典', '查询', '2023-09-11 12:47:50');
INSERT INTO `sys_log` VALUES (194, 'admin', '查询全部字典', '查询', '2023-09-11 13:02:55');
INSERT INTO `sys_log` VALUES (195, 'admin', '查询字典分页', '查询', '2023-09-11 18:27:42');
INSERT INTO `sys_log` VALUES (196, 'user', '查询文件分页', '查询', '2023-09-11 18:28:14');
INSERT INTO `sys_log` VALUES (197, 'user', '查询文件分页', '查询', '2023-09-11 18:29:02');
INSERT INTO `sys_log` VALUES (198, 'user', '查询文件分页', '查询', '2023-09-11 18:29:08');
INSERT INTO `sys_log` VALUES (199, 'user', '查询文件分页', '查询', '2023-09-12 06:56:22');
INSERT INTO `sys_log` VALUES (200, 'user', '查询文件分页', '查询', '2023-09-12 06:57:33');
INSERT INTO `sys_log` VALUES (201, 'user', '查询文件分页', '查询', '2023-09-12 06:57:34');
INSERT INTO `sys_log` VALUES (202, 'admin', '查询文件分页', '查询', '2023-09-12 06:58:07');
INSERT INTO `sys_log` VALUES (203, 'admin', '查询全部字典', '查询', '2023-09-12 06:58:08');
INSERT INTO `sys_log` VALUES (204, 'admin', '查询字典分页', '查询', '2023-09-12 06:58:09');
INSERT INTO `sys_log` VALUES (205, 'admin', '查询文件分页', '查询', '2023-09-12 07:20:41');
INSERT INTO `sys_log` VALUES (206, 'admin', '查询文件分页', '查询', '2023-09-12 07:21:40');
INSERT INTO `sys_log` VALUES (207, 'admin', '查询文件分页', '查询', '2023-09-12 07:21:45');
INSERT INTO `sys_log` VALUES (208, 'admin', '查询文件分页', '查询', '2023-09-12 07:22:20');
INSERT INTO `sys_log` VALUES (209, 'admin', '查询字典分页', '查询', '2023-09-12 13:09:31');
INSERT INTO `sys_log` VALUES (210, 'user', '查询文件分页', '查询', '2023-09-12 13:11:22');
INSERT INTO `sys_log` VALUES (211, 'user', '查询文件分页', '查询', '2023-09-12 13:12:41');
INSERT INTO `sys_log` VALUES (212, 'admin', '查询文件分页', '查询', '2023-09-13 06:51:15');
INSERT INTO `sys_log` VALUES (213, 'admin', '查询字典分页', '查询', '2023-09-13 06:51:24');
INSERT INTO `sys_log` VALUES (214, 'admin', '查询全部字典', '查询', '2023-09-13 06:51:27');
INSERT INTO `sys_log` VALUES (215, 'admin', '查询字典分页', '查询', '2023-09-13 20:22:25');
INSERT INTO `sys_log` VALUES (216, 'admin', '查询文件分页', '查询', '2023-09-13 20:22:35');
INSERT INTO `sys_log` VALUES (217, 'admin', '查询全部字典', '查询', '2023-09-13 20:43:48');
INSERT INTO `sys_log` VALUES (218, 'admin', '查询字典分页', '查询', '2023-09-13 20:44:44');
INSERT INTO `sys_log` VALUES (219, 'admin', '查询字典分页', '查询', '2023-09-13 20:48:40');
INSERT INTO `sys_log` VALUES (220, 'admin', '查询文件分页', '查询', '2023-09-13 20:48:45');
INSERT INTO `sys_log` VALUES (221, 'user', '查询文件分页', '查询', '2023-09-13 20:49:13');
INSERT INTO `sys_log` VALUES (222, 'user', '查询文件分页', '查询', '2023-09-13 20:49:40');
INSERT INTO `sys_log` VALUES (223, 'user', '查询文件分页', '查询', '2023-09-14 19:33:53');
INSERT INTO `sys_log` VALUES (224, 'admin', '查询字典分页', '查询', '2023-09-15 18:57:01');
INSERT INTO `sys_log` VALUES (225, 'admin', '查询文件分页', '查询', '2023-09-23 18:16:53');
INSERT INTO `sys_log` VALUES (226, 'admin', '查询字典分页', '查询', '2023-09-23 18:17:02');
INSERT INTO `sys_log` VALUES (227, 'admin', '查询全部字典', '查询', '2023-09-23 18:17:02');
INSERT INTO `sys_log` VALUES (228, 'admin', '查询全部字典', '查询', '2023-09-23 18:18:02');
INSERT INTO `sys_log` VALUES (229, 'admin', '查询全部字典', '查询', '2023-09-23 18:18:17');
INSERT INTO `sys_log` VALUES (230, 'admin', '查询全部字典', '查询', '2023-09-23 18:18:37');
INSERT INTO `sys_log` VALUES (231, 'admin', '查询全部字典', '查询', '2023-09-23 18:18:54');
INSERT INTO `sys_log` VALUES (232, 'admin', '查询全部字典', '查询', '2023-09-23 18:28:43');
INSERT INTO `sys_log` VALUES (233, 'admin', '查询全部字典', '查询', '2023-09-23 18:28:45');
INSERT INTO `sys_log` VALUES (234, 'admin', '查询全部字典', '查询', '2023-09-23 18:29:36');
INSERT INTO `sys_log` VALUES (235, 'admin', '查询全部字典', '查询', '2024-04-15 19:13:51');
INSERT INTO `sys_log` VALUES (236, 'admin', '查询文件分页', '查询', '2024-04-15 19:13:52');
INSERT INTO `sys_log` VALUES (237, 'admin', '查询全部字典', '查询', '2024-04-15 19:13:59');
INSERT INTO `sys_log` VALUES (238, 'admin', '查询全部字典', '查询', '2024-04-15 19:14:20');
INSERT INTO `sys_log` VALUES (239, 'admin', '查询全部字典', '查询', '2024-04-15 19:14:58');
INSERT INTO `sys_log` VALUES (240, 'admin', '查询全部字典', '查询', '2024-04-15 20:47:33');
INSERT INTO `sys_log` VALUES (241, 'admin', '查询全部字典', '查询', '2024-04-16 19:50:10');
INSERT INTO `sys_log` VALUES (242, 'admin', '查询字典分页', '查询', '2024-04-16 19:50:10');
INSERT INTO `sys_log` VALUES (243, 'admin', '查询文件分页', '查询', '2024-04-16 19:50:13');
INSERT INTO `sys_log` VALUES (244, 'admin', '查询字典分页', '查询', '2024-04-16 19:51:40');
INSERT INTO `sys_log` VALUES (245, 'admin', '查询字典分页', '查询', '2024-04-16 20:56:07');
INSERT INTO `sys_log` VALUES (246, 'admin', '查询字典分页', '查询', '2024-04-16 20:56:08');
INSERT INTO `sys_log` VALUES (247, 'admin', '查询全部字典', '查询', '2024-04-16 20:56:09');
INSERT INTO `sys_log` VALUES (248, 'admin', '查询文件分页', '查询', '2024-04-16 20:56:11');
INSERT INTO `sys_log` VALUES (249, 'admin', '查询文件分页', '查询', '2024-05-09 22:36:47');
INSERT INTO `sys_log` VALUES (250, 'admin', '查询文件分页', '查询', '2024-05-09 22:36:59');
INSERT INTO `sys_log` VALUES (251, 'admin', '查询文件分页', '查询', '2024-05-09 22:37:06');
INSERT INTO `sys_log` VALUES (252, 'admin', '查询文件分页', '查询', '2024-05-09 22:37:17');
INSERT INTO `sys_log` VALUES (253, 'admin', '查询全部字典', '查询', '2024-05-09 22:44:52');
INSERT INTO `sys_log` VALUES (254, 'admin', '查询字典分页', '查询', '2024-05-10 19:02:59');
INSERT INTO `sys_log` VALUES (255, 'admin', '查询全部字典', '查询', '2024-05-10 19:03:00');
INSERT INTO `sys_log` VALUES (256, 'admin', '查询文件分页', '查询', '2024-05-10 19:03:49');
INSERT INTO `sys_log` VALUES (257, 'admin', '查询文件分页', '查询', '2024-05-10 19:07:23');
INSERT INTO `sys_log` VALUES (258, 'admin', '查询文件分页', '查询', '2024-05-10 19:07:26');
INSERT INTO `sys_log` VALUES (259, 'admin', '查询文件分页', '查询', '2024-05-10 19:07:29');
INSERT INTO `sys_log` VALUES (260, 'admin', '查询文件分页', '查询', '2024-05-10 19:07:29');
INSERT INTO `sys_log` VALUES (261, 'admin', '查询文件分页', '查询', '2024-05-10 19:07:33');
INSERT INTO `sys_log` VALUES (262, 'admin', '查询文件分页', '查询', '2024-05-10 19:07:36');
INSERT INTO `sys_log` VALUES (263, 'admin', '批量删除文件', '删除', '2024-05-10 19:07:41');
INSERT INTO `sys_log` VALUES (264, 'admin', '查询文件分页', '查询', '2024-05-10 19:07:41');
INSERT INTO `sys_log` VALUES (265, 'admin', '查询文件分页', '查询', '2024-05-10 19:07:42');
INSERT INTO `sys_log` VALUES (266, 'admin', '批量删除文件', '删除', '2024-05-10 19:07:47');
INSERT INTO `sys_log` VALUES (267, 'admin', '查询文件分页', '查询', '2024-05-10 19:07:48');
INSERT INTO `sys_log` VALUES (268, 'admin', '查询文件分页', '查询', '2024-05-10 19:07:48');
INSERT INTO `sys_log` VALUES (269, 'admin', '批量删除文件', '删除', '2024-05-10 19:07:50');
INSERT INTO `sys_log` VALUES (270, 'admin', '查询文件分页', '查询', '2024-05-10 19:07:50');
INSERT INTO `sys_log` VALUES (271, 'admin', '查询文件分页', '查询', '2024-05-10 19:07:50');
INSERT INTO `sys_log` VALUES (272, 'admin', '查询字典分页', '查询', '2024-05-10 19:08:02');
INSERT INTO `sys_log` VALUES (273, 'admin', '查询文件分页', '查询', '2024-05-10 20:41:53');
INSERT INTO `sys_log` VALUES (274, 'admin', '查询全部字典', '查询', '2024-05-10 20:41:55');
INSERT INTO `sys_log` VALUES (275, 'admin', '查询全部字典', '查询', '2024-05-10 20:42:32');
INSERT INTO `sys_log` VALUES (276, 'admin', '查询全部字典', '查询', '2024-05-19 18:15:05');
INSERT INTO `sys_log` VALUES (277, 'admin', '查询全部字典', '查询', '2024-05-19 18:15:20');
INSERT INTO `sys_log` VALUES (278, 'admin', '查询字典分页', '查询', '2024-05-19 18:16:12');
INSERT INTO `sys_log` VALUES (279, 'admin', '查询文件分页', '查询', '2024-05-19 18:16:16');
INSERT INTO `sys_log` VALUES (280, 'admin', '查询文件分页', '查询', '2024-05-19 18:21:14');
INSERT INTO `sys_log` VALUES (281, 'admin', '查询字典分页', '查询', '2024-05-19 18:23:21');
INSERT INTO `sys_log` VALUES (282, 'admin', '查询全部字典', '查询', '2024-05-19 18:23:22');
INSERT INTO `sys_log` VALUES (283, 'admin', '查询字典分页', '查询', '2024-05-19 18:23:23');
INSERT INTO `sys_log` VALUES (284, 'admin', '查询字典分页', '查询', '2024-05-19 18:23:25');
INSERT INTO `sys_log` VALUES (285, 'admin', '查询全部字典', '查询', '2024-05-19 18:23:26');
INSERT INTO `sys_log` VALUES (286, 'admin', '查询全部字典', '查询', '2024-05-19 18:23:28');
INSERT INTO `sys_log` VALUES (287, 'admin', '查询全部字典', '查询', '2024-05-19 18:23:29');
INSERT INTO `sys_log` VALUES (288, 'admin', '查询文件分页', '查询', '2024-05-19 18:23:30');
INSERT INTO `sys_log` VALUES (289, 'admin', '查询字典分页', '查询', '2024-05-19 18:27:46');
INSERT INTO `sys_log` VALUES (290, 'admin', '查询文件分页', '查询', '2024-05-19 18:27:58');
INSERT INTO `sys_log` VALUES (291, 'admin', 'updateEnable', '修改', '2024-05-19 18:28:00');
INSERT INTO `sys_log` VALUES (292, 'admin', 'updateEnable', '修改', '2024-05-19 18:28:01');
INSERT INTO `sys_log` VALUES (293, 'admin', '查询全部字典', '查询', '2024-08-05 10:50:16');
INSERT INTO `sys_log` VALUES (294, 'admin', '查询全部字典', '查询', '2024-08-05 10:50:25');
INSERT INTO `sys_log` VALUES (295, 'admin', '查询全部字典', '查询', '2024-08-05 10:50:30');
INSERT INTO `sys_log` VALUES (296, 'admin', '查询全部字典', '查询', '2024-08-05 10:50:58');
INSERT INTO `sys_log` VALUES (297, 'admin', '查询全部字典', '查询', '2024-08-05 10:53:30');
INSERT INTO `sys_log` VALUES (298, 'admin', '查询全部字典', '查询', '2024-08-05 10:53:36');
INSERT INTO `sys_log` VALUES (299, 'admin', '查询全部字典', '查询', '2024-08-05 11:05:17');
INSERT INTO `sys_log` VALUES (300, 'admin', '查询全部字典', '查询', '2024-08-05 11:05:21');
INSERT INTO `sys_log` VALUES (301, 'admin', '查询全部字典', '查询', '2024-08-05 11:05:24');
INSERT INTO `sys_log` VALUES (302, 'admin', '查询全部字典', '查询', '2024-08-05 11:05:28');
INSERT INTO `sys_log` VALUES (303, 'admin', '查询全部字典', '查询', '2024-08-05 11:06:03');
INSERT INTO `sys_log` VALUES (304, 'admin', '查询文件分页', '查询', '2024-08-05 11:07:05');
INSERT INTO `sys_log` VALUES (305, 'admin', '查询字典分页', '查询', '2024-08-05 11:23:44');
INSERT INTO `sys_log` VALUES (306, 'admin', '查询字典分页', '查询', '2024-08-05 11:24:20');
INSERT INTO `sys_log` VALUES (307, 'admin', '查询字典分页', '查询', '2024-08-05 11:24:39');
INSERT INTO `sys_log` VALUES (308, 'admin', '查询字典分页', '查询', '2024-08-05 11:25:05');
INSERT INTO `sys_log` VALUES (309, 'admin', '查询字典分页', '查询', '2024-08-05 11:25:08');
INSERT INTO `sys_log` VALUES (310, 'admin', '查询字典分页', '查询', '2024-08-05 11:25:43');
INSERT INTO `sys_log` VALUES (311, 'admin', '查询全部字典', '查询', '2024-08-05 11:25:52');
INSERT INTO `sys_log` VALUES (312, 'admin', '查询字典分页', '查询', '2024-08-05 11:27:09');
INSERT INTO `sys_log` VALUES (313, 'admin', '查询全部字典', '查询', '2024-08-05 11:27:51');
INSERT INTO `sys_log` VALUES (314, 'admin', '查询全部字典', '查询', '2024-08-05 11:28:01');
INSERT INTO `sys_log` VALUES (315, 'admin', '查询全部字典', '查询', '2024-08-05 11:28:13');
INSERT INTO `sys_log` VALUES (316, 'admin', '查询全部字典', '查询', '2024-08-05 11:28:38');
INSERT INTO `sys_log` VALUES (317, 'admin', '查询全部字典', '查询', '2024-08-05 11:29:18');
INSERT INTO `sys_log` VALUES (318, 'admin', '查询全部字典', '查询', '2024-08-05 11:29:35');
INSERT INTO `sys_log` VALUES (319, 'admin', '查询全部字典', '查询', '2024-08-05 11:30:35');
INSERT INTO `sys_log` VALUES (320, 'admin', '查询文件分页', '查询', '2024-08-05 11:30:45');
INSERT INTO `sys_log` VALUES (321, 'admin', '查询文件分页', '查询', '2024-08-05 11:32:15');
INSERT INTO `sys_log` VALUES (322, 'admin', '查询文件分页', '查询', '2024-08-05 11:36:11');
INSERT INTO `sys_log` VALUES (323, 'admin', '查询文件分页', '查询', '2024-08-05 11:36:14');
INSERT INTO `sys_log` VALUES (324, 'admin', '查询文件分页', '查询', '2024-08-05 11:43:55');
INSERT INTO `sys_log` VALUES (325, '2581455827@QQ.COM', '查询文件分页', '查询', '2024-08-05 16:05:28');
INSERT INTO `sys_log` VALUES (326, 'admin', '查询全部字典', '查询', '2024-11-20 15:49:46');
INSERT INTO `sys_log` VALUES (327, 'admin', '查询全部字典', '查询', '2024-11-20 15:50:06');
INSERT INTO `sys_log` VALUES (328, 'admin', '查询全部字典', '查询', '2024-11-20 15:50:31');
INSERT INTO `sys_log` VALUES (329, 'admin', '查询全部字典', '查询', '2024-11-20 15:51:30');
INSERT INTO `sys_log` VALUES (330, 'admin', '查询字典分页', '查询', '2024-11-20 15:51:33');
INSERT INTO `sys_log` VALUES (331, 'admin', '查询全部字典', '查询', '2024-11-20 15:52:09');
INSERT INTO `sys_log` VALUES (332, 'admin', '查询全部字典', '查询', '2024-11-20 15:52:15');
INSERT INTO `sys_log` VALUES (333, 'admin', '查询全部字典', '查询', '2024-11-20 17:36:17');
INSERT INTO `sys_log` VALUES (334, 'admin', '查询全部字典', '查询', '2024-11-20 17:36:36');
INSERT INTO `sys_log` VALUES (335, 'admin', '查询文件分页', '查询', '2024-12-06 21:05:07');

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '菜单名称',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '菜单路径',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '菜单图标',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '菜单描述',
  `pid` int(11) NULL DEFAULT NULL COMMENT '父级id',
  `page_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '页面路径',
  `sort_num` int(11) NULL DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (4, '系统管理', NULL, 'el-icon-menu', '系统管理菜单', NULL, NULL, 2);
INSERT INTO `sys_menu` VALUES (5, '用户管理', '/user', 'el-icon-user', '用户页面信息管理', 4, 'User', 2);
INSERT INTO `sys_menu` VALUES (6, '角色管理', '/role', 'el-icon-user-solid', '角色页面管理', 4, 'Role', 3);
INSERT INTO `sys_menu` VALUES (7, '字典管理', '/dict', 'el-icon-info', '字典管理', 4, 'Dict', 4);
INSERT INTO `sys_menu` VALUES (8, '菜单管理', '/menu', 'el-icon-menu', '菜单管理', 4, 'Menu', 5);
INSERT INTO `sys_menu` VALUES (9, '日志管理', '/sysLog', 'el-icon-document', '日志页面', 4, 'SysLog', 8);
INSERT INTO `sys_menu` VALUES (11, '文件管理', '/sysFile', 'el-icon-document', '11', NULL, 'SysFile', 11);
INSERT INTO `sys_menu` VALUES (13, '公告管理', '/notice', 'el-icon-s-data', '公告页面管理', NULL, 'Notice', 16);
INSERT INTO `sys_menu` VALUES (15, '主页', '/home', 'el-icon-house', '后台主页', NULL, 'Home', 1);
INSERT INTO `sys_menu` VALUES (18, '农产品管理', '/Product', 'el-icon-menu', NULL, NULL, 'Product', 1);
INSERT INTO `sys_menu` VALUES (19, '库存管理', '/Warehouse', 'el-icon-house', NULL, NULL, 'Warehouse', 2);
INSERT INTO `sys_menu` VALUES (21, '溯源', '/Trace', 'el-icon-more', NULL, NULL, 'Trace', 3);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '角色名称',
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '唯一标识',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '角色描述',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (9, '管理员', 'ROLE_ADMIN', '超级管理员。有全部权限');
INSERT INTO `sys_role` VALUES (10, '用户', 'ROLE_USER', '用户权限');

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` int(11) NOT NULL COMMENT '角色id',
  `menu_id` int(11) NOT NULL COMMENT '菜单id',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (9, 4);
INSERT INTO `sys_role_menu` VALUES (9, 5);
INSERT INTO `sys_role_menu` VALUES (9, 6);
INSERT INTO `sys_role_menu` VALUES (9, 7);
INSERT INTO `sys_role_menu` VALUES (9, 8);
INSERT INTO `sys_role_menu` VALUES (9, 9);
INSERT INTO `sys_role_menu` VALUES (9, 11);
INSERT INTO `sys_role_menu` VALUES (9, 13);
INSERT INTO `sys_role_menu` VALUES (9, 15);
INSERT INTO `sys_role_menu` VALUES (9, 18);
INSERT INTO `sys_role_menu` VALUES (9, 19);
INSERT INTO `sys_role_menu` VALUES (9, 20);
INSERT INTO `sys_role_menu` VALUES (9, 21);
INSERT INTO `sys_role_menu` VALUES (10, 4);
INSERT INTO `sys_role_menu` VALUES (10, 9);
INSERT INTO `sys_role_menu` VALUES (10, 11);
INSERT INTO `sys_role_menu` VALUES (10, 13);
INSERT INTO `sys_role_menu` VALUES (10, 15);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'id主键',
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码',
  `nickname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '昵称',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `phone` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系方式',
  `role_id` int(11) NOT NULL COMMENT '角色id',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `header_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户头像',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 84 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (73, 'admin', '123456', 'test111', '北京市四合院', '10927@qq.com', '12312312111', 9, '2023-09-01 12:56:10', 'http://localhost:8888/sysFile/2gy1hct88xfrd9j20k00k0dho.jpg');
INSERT INTO `sys_user` VALUES (75, 'user', '123456', '12', '121', '1', '1', 10, '2023-09-02 06:02:13', 'http://localhost:8888/sysFile/9516662fgy1hct88xfrd9j20k00k0dho.jpg');
INSERT INTO `sys_user` VALUES (83, '2581455827@QQ.COM', '123456', NULL, NULL, NULL, NULL, 10, '2024-08-05 16:05:13', NULL);

-- ----------------------------
-- Table structure for warehouse
-- ----------------------------
DROP TABLE IF EXISTS `warehouse`;
CREATE TABLE `warehouse`  (
  `id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `traceCode` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '溯源码',
  `amount` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '发货数量',
  `sendDate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发货日期',
  `origin` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '产地',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '产品名称',
  `recvDate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '收货日期',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of warehouse
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
