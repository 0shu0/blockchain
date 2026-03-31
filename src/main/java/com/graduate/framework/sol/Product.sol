pragma solidity ^0.5.2;
pragma experimental ABIEncoderV2;

contract Product {
    struct Object {
    string traceCode;
    string origin;
    string name;
    string id;
    string manufacturer;
    }

    mapping(string => Object) private records;
    string[] private recordKeys;
    uint256 private recordCount;

    // 添加新药品记录
    function addObject( string memory _traceCode ,string memory _origin ,string memory _name ,string memory _id ,string memory _manufacturer) public {
        require(bytes(records[_id].id).length == 0, "该记录已存在，添加失败!");
        records[_id] = Object(_traceCode,_origin,_name,_id,_manufacturer);
        recordKeys.push(_id);
        recordCount++;
    }

    // 查询所有记录
    function getAllObjects() public view returns (Object[] memory) {
        Object[] memory allObjects = new Object[](recordCount);
        for (uint256 i = 0; i < recordKeys.length; i++) {
            allObjects[i] = records[recordKeys[i]];
        }
        return allObjects;
    }

    // 根据ID查询记录
    function getObjectById(string memory _id) public view returns (Object memory) {
		 for (uint256 i = 0; i < recordKeys.length; i++) {
            if (keccak256(abi.encodePacked(records[recordKeys[i]].id)) == keccak256(abi.encodePacked(_id))) {
                return records[recordKeys[i]];
            }
        }
    }
 
    function getObjectByCode(string memory _code) public view returns (Object memory) {
		 for (uint256 i = 0; i < recordKeys.length; i++) {
            if (keccak256(abi.encodePacked(records[recordKeys[i]].traceCode)) == keccak256(abi.encodePacked(_code))) {
                return records[recordKeys[i]];
            }
        }
    }


    // 根据ID修改记录
    function updateObject( string memory _traceCode ,string memory _origin ,string memory _name ,string memory _id ,string memory _manufacturer) public {
        require(bytes(records[_id].id).length > 0, "记录不存在");
        records[_id] = Object( _traceCode , _origin , _name , _id , _manufacturer);
    }

    // 根据ID删除记录
    function deleteObject(string memory _id) public {
        require(bytes(records[_id].id).length > 0, "记录不存在");
        delete records[_id];

        // 从记录的键中移除
        for (uint256 i = 0; i < recordKeys.length; i++) {
            if (keccak256(abi.encodePacked(recordKeys[i])) == keccak256(abi.encodePacked(_id))) {
                recordKeys[i] = recordKeys[recordKeys.length - 1]; // 用最后的记录覆盖当前
                recordKeys.pop(); // 删除最后的记录
                recordCount--;
                break;
            }
        }
    }
}
