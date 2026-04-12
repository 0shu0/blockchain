pragma solidity ^0.5.2;
pragma experimental ABIEncoderV2;

contract Product {
    // 产品结构体，新增库存相关字段
    struct Object {
        string name;        // 产品名称
        string origin;      // 产地
        string manufacturer;// 厂家
        string traceCode;   // 溯源码（唯一标识）
        uint256 stock;      // 库存数量（新增库存核心字段）
        bool isExist;       // 产品是否存在（辅助判断）
    }

    // 状态变量定义（优化原有命名和逻辑）
    mapping(string => Object) private records; // 溯源码映射产品信息
    string[] private recordKeys;              // 存储所有溯源码
    uint256 private recordCount;              // 产品数量

    // 添加新产品记录
    function addObject(string memory _name, string memory _origin, string memory _manufacturer, string memory _traceCode, uint256 _stock) public {
        require(bytes(records[_traceCode].traceCode).length == 0, "该产品已存在，添加失败!");
        records[_traceCode] = Object(_name, _origin, _manufacturer, _traceCode, _stock, true);
        recordKeys.push(_traceCode);
        recordCount++;
    }

    // 查询所有产品（包含库存）
    function getAllObjects() public view returns (Object[] memory) {
        Object[] memory allObjects = new Object[](recordCount);
        for (uint256 i = 0; i < recordCount; i++) {
            allObjects[i] = records[recordKeys[i]];
        }
        return allObjects;
    }

    // 根据溯源码查询单个产品
    function getObjectByTraceCode(string memory _traceCode) public view returns (Object memory) {
        require(records[_traceCode].isExist, "产品不存在!");
        return records[_traceCode];
    }

    // 新增：库存扣减（常用库存操作）
    function deductStock(string memory _traceCode, uint256 _deductNum) public {
        require(records[_traceCode].isExist, "产品不存在，扣减库存失败!");
        require(records[_traceCode].stock >= _deductNum, "库存不足，扣减失败!");
        records[_traceCode].stock -= _deductNum;
    }

    // 新增：查询单个产品库存
    function getStockByTraceCode(string memory _traceCode) public view returns (uint256) {
        require(records[_traceCode].isExist, "产品不存在!");
        return records[_traceCode].stock;
    }

    // 优化原有方法：按名称查询产品（包含库存）
    function getObjectByName(string memory _name) public view returns (Object memory) {
        for (uint256 i = 0; i < recordCount; i++) {
            if (keccak256(abi.encodePacked(records[recordKeys[i]].name)) == keccak256(abi.encodePacked(_name))) {
                return records[recordKeys[i]];
            }
        }
        // 若未找到，返回空对象（避免报错）
        return Object("", "", "", "", 0, false);
    }

    // 优化原有方法：删除产品
    function deleteObject(string memory _traceCode) public {
        require(records[_traceCode].isExist, "产品不存在，删除失败!");
        // 删除映射中的产品
        delete records[_traceCode];

        // 从列表中移除溯源码
        for (uint256 i = 0; i < recordKeys.length; i++) {
            if (keccak256(abi.encodePacked(recordKeys[i])) == keccak256(abi.encodePacked(_traceCode))) {
                recordKeys[i] = recordKeys[recordKeys.length - 1];
                recordKeys.pop();
                recordCount--;
                break;
            }
        }
    }

    // 优化原有方法：更新产品信息
    function updateObject(string memory _name, string memory _origin, string memory _manufacturer, string memory _traceCode, uint256 _stock) public {
        require(records[_traceCode].isExist, "产品不存在，更新失败!");
        records[_traceCode] = Object(_name, _origin, _manufacturer, _traceCode, _stock, true);
    }
}
