pragma solidity ^0.5.2;
pragma experimental ABIEncoderV2;

contract Shop {
    // 商品记录结构体
    struct Object {
        string listDate;    // 上架日期
        string traceCode;   // 产品溯源码
        uint256 amount;     // 数量
        string sendDate;    // 发货日期
        uint256 price;      // 价格
        string origin;      // 产地
        string name;        // 商品名称
        string id;          // 记录ID
        string recvDate;    // 收货日期
        string productId;   // 产品ID
    }

    // 状态变量
    mapping(string => Object) private records; // ID映射记录信息
    string[] private recordKeys;              // 存储所有记录ID
    uint256 private recordCount;              // 记录数量

    // 添加新商品记录
    function addObject(string memory _listDate, string memory _traceCode, uint256 _amount, string memory _sendDate, uint256 _price, string memory _origin, string memory _name, string memory _id, string memory _recvDate, string memory _productId) public {
        require(bytes(records[_id].id).length == 0, "该记录已存在，添加失败!");
        records[_id] = Object(_listDate, _traceCode, _amount, _sendDate, _price, _origin, _name, _id, _recvDate, _productId);
        recordKeys.push(_id);
        recordCount++;
    }

    // 查询所有商品记录
    function getAllObjects() public view returns (Object[] memory) {
        Object[] memory allObjects = new Object[](recordCount);
        for (uint256 i = 0; i < recordCount; i++) {
            allObjects[i] = records[recordKeys[i]];
        }
        return allObjects;
    }

    // 根据ID查询商品记录
    function getObjectById(string memory _id) public view returns (Object memory) {
        require(bytes(records[_id].id).length > 0, "记录不存在!");
        return records[_id];
    }

    // 根据溯源码查询商品记录
    function getObjectByTraceCode(string memory _traceCode) public view returns (Object memory) {
        for (uint256 i = 0; i < recordCount; i++) {
            if (keccak256(abi.encodePacked(records[recordKeys[i]].traceCode)) == keccak256(abi.encodePacked(_traceCode))) {
                return records[recordKeys[i]];
            }
        }
        // 若未找到，返回空对象（避免报错）
        return Object("", "", 0, "", 0, "", "", "", "", "");
    }

    // 更新商品记录
    function updateObject(string memory _listDate, string memory _traceCode, uint256 _amount, string memory _sendDate, uint256 _price, string memory _origin, string memory _name, string memory _id, string memory _recvDate, string memory _productId) public {
        require(bytes(records[_id].id).length > 0, "记录不存在，更新失败!");
        records[_id] = Object(_listDate, _traceCode, _amount, _sendDate, _price, _origin, _name, _id, _recvDate, _productId);
    }

    // 删除商品记录
    function deleteObject(string memory _id) public {
        require(bytes(records[_id].id).length > 0, "记录不存在，删除失败!");
        // 删除映射中的记录
        delete records[_id];

        // 从列表中移除记录ID
        for (uint256 i = 0; i < recordKeys.length; i++) {
            if (keccak256(abi.encodePacked(recordKeys[i])) == keccak256(abi.encodePacked(_id))) {
                recordKeys[i] = recordKeys[recordKeys.length - 1];
                recordKeys.pop();
                recordCount--;
                break;
            }
        }
    }

    // 根据产品ID查询商品记录
    function getObjectsByProductId(string memory _productId) public view returns (Object[] memory) {
        // 先统计符合条件的记录数量
        uint256 count = 0;
        for (uint256 i = 0; i < recordCount; i++) {
            if (keccak256(abi.encodePacked(records[recordKeys[i]].productId)) == keccak256(abi.encodePacked(_productId))) {
                count++;
            }
        }

        // 创建结果数组
        Object[] memory result = new Object[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < recordCount; i++) {
            if (keccak256(abi.encodePacked(records[recordKeys[i]].productId)) == keccak256(abi.encodePacked(_productId))) {
                result[index] = records[recordKeys[i]];
                index++;
            }
        }
        return result;
    }
}