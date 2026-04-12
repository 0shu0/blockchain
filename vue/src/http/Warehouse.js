import webaseHttp from "@/utils/webaseHttp";

// 使用与Product.js相同的合约地址和用户地址
let contractAddress = "0x5330ed53ebc59e87343861a582d7dcba64e926d6";
let user = "0x65183d971dff322a603a0c96f61a13bab3be0ab0";

// 从localStorage中读取模拟库存记录数据，如果不存在则初始化
let mockWarehouseData = JSON.parse(localStorage.getItem('mockWarehouseData'));

// 如果localStorage中没有数据，则使用初始数据
if (!mockWarehouseData) {
    mockWarehouseData = [
        {
            "traceCode": "60810281-43e4-442e-b6ca-094c329d79d1",
            "amount": 100,
            "sendDate": "2026-04-09",
            "origin": "山东-济南",
            "name": "玉米",
            "id": "12345678-1234-1234-1234-123456789012",
            "recvDate": "2026-04-09",
            "productId": "60810281-43e4-442e-b6ca-094c329d79d1"
        },
        {
            "traceCode": "78264144-8f5b-42e6-a73b-570e5925986b",
            "amount": 50,
            "sendDate": "2026-04-09",
            "origin": "吉林-长春",
            "name": "大米",
            "id": "87654321-4321-4321-4321-210987654321",
            "recvDate": "2026-04-09",
            "productId": "78264144-8f5b-42e6-a73b-570e5925986b"
        }
    ];
    // 将初始数据保存到localStorage中
    saveMockData();
}

// 将模拟数据保存到localStorage中
function saveMockData() {
    localStorage.setItem('mockWarehouseData', JSON.stringify(mockWarehouseData));
}

export function addWarehouse(params) {
    // 检查参数是否完整
    console.log('接收到的参数：', params);
    
    // 模拟智能合约调用，将新的发货记录添加到模拟数据中
    return new Promise((resolve, reject) => {
        console.log('模拟智能合约调用成功，添加新的发货记录');
        // 确保参数顺序正确
        const newRecord = {
            "traceCode": params.traceCode || '',
            "amount": params.amount || 0,
            "sendDate": params.sendDate || '',
            "origin": params.origin || '',
            "name": params.name || '',
            "id": params.id || '',
            "recvDate": params.recvDate || '',
            "productId": params.productId || ''
        };
        console.log('新的发货记录：', newRecord);
        mockWarehouseData.push(newRecord);
        // 将模拟数据保存到localStorage中
        saveMockData();
        console.log('当前库存记录数据：', mockWarehouseData);
        resolve({ status: 'success' });
    });
    
    /*
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Warehouse",
        "version": "",
        "funcName": "addObject",
        "funcParam": [
            params.traceCode || '',  // 兜底空字符串，避免undefined
            Number(params.amount) || 0,  // uint256转数字，兜底0
            params.sendDate || '',
            params.origin || '',
            params.name || '',
            params.id || '',
            params.recvDate || '',
            params.productId || ''
        ],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [
                {"name": "_traceCode", "type": "string", "value": params.traceCode || ''},
                {"name": "_amount", "type": "uint256", "value": Number(params.amount) || 0},
                {"name": "_sendDate", "type": "string", "value": params.sendDate || ''},
                {"name": "_origin", "type": "string", "value": params.origin || ''},
                {"name": "_name", "type": "string", "value": params.name || ''},
                {"name": "_id", "type": "string", "value": params.id || ''},
                {"name": "_recvDate", "type": "string", "value": params.recvDate || ''},
                {"name": "_productId", "type": "string", "value": params.productId || ''}
            ],
            "name": "addObject",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function",
            "funcId": 0
        }],
        "useAes": false,
        "useCns": false,
        "cnsName": ""
    }
    console.log("提交到合约的参数：", pam);
    // 修复路径 + 统一超时配置
    return webaseHttp.post('/WeBASE-Front/trans/handle', pam, { timeout: 30000 })
        .then(res => {
            console.log("交易成功：", res);
            return res;
        })
        .catch(err => {
            console.error("交易失败：", err);
            // 尝试处理422错误
            if (err.response && err.response.status === 422) {
                console.error("422错误详情：", err.response.data);
            }
            throw err;
        });
    */
}

export function deleteWarehouse(id) {
    // 模拟智能合约调用，从localStorage中删除指定的库存记录
    return new Promise((resolve, reject) => {
        console.log('删除库存记录，ID：', id);
        // 从mockWarehouseData中删除指定的记录
        const index = mockWarehouseData.findIndex(item => item.id === id);
        if (index !== -1) {
            mockWarehouseData.splice(index, 1);
            // 将更新后的数据保存到localStorage中
            saveMockData();
            console.log('删除成功，当前库存记录数据：', mockWarehouseData);
            resolve({ status: 'success' });
        } else {
            console.error('未找到指定的库存记录，ID：', id);
            reject(new Error('未找到指定的库存记录'));
        }
    });
    
    /*
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Warehouse",
        "version": "",
        "funcName": "deleteObject",
        "funcParam": [id || ''],  // 兜底空字符串
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [{"name": "_id", "type": "string", "value": id || ''}],
            "name": "deleteObject",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function",
            "funcId": 2
        }],
        "useAes": false,
        "useCns": false,
        "cnsName": ""
    }
    // 修复路径 + 统一超时配置
    return webaseHttp.post('/WeBASE-Front/trans/handle', pam, { timeout: 30000 }).then(res => {
        return res;
    });
    */
}

export function getAllWarehouse() {
    // 模拟智能合约调用，返回模拟数据
    return new Promise((resolve, reject) => {
        console.log('模拟智能合约调用成功，返回模拟数据');
        console.log('当前库存记录数据：', mockWarehouseData);
        // 返回mockWarehouseData数组，这样当用户发货时，新的发货记录会被添加到这个数组中
        resolve(mockWarehouseData);
    });
    
    /*
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Warehouse",
        "version": "",
        "funcName": "getAllObjects",
        "funcParam": [],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": true,
            "inputs": [],
            "name": "getAllObjects",
            "outputs": [{
                "components": [
                    {"name": "traceCode", "type": "string"},
                    {"name": "amount", "type": "uint256"},
                    {"name": "sendDate", "type": "string"},
                    {"name": "origin", "type": "string"},
                    {"name": "name", "type": "string"},
                    {"name": "id", "type": "string"},
                    {"name": "recvDate", "type": "string"},
                    {"name": "productId", "type": "string"}
                ], "name": "", "type": "tuple[]"
            }],
            "payable": false,
            "stateMutability": "view",
            "type": "function",
            "funcId": 4
        }],
        "useAes": false,
        "useCns": false,
        "cnsName": ""
    };
    // 修复路径 + 统一超时配置
    return webaseHttp.post('/WeBASE-Front/trans/handle', params, { timeout: 30000 }).then(res => {
        if (!Array.isArray(res)) {
            console.warn("仓库列表返回非数组：", res);
            return [];
        }
        let objs = res.map(item => {
            return cvtRes(item);
        });
        return objs;
    }).catch(err => {
        console.error("加载仓库列表失败：", err);
        return [];
    });
    */
}

export function getWarehouseById(id) {
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Warehouse",
        "version": "",
        "funcName": "getObjectById",
        "funcParam": [id || ''],  // 兜底空字符串
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": true,
            "inputs": [{"name": "_id", "type": "string", "value": id || ''}],
            "name": "getObjectById",
            "outputs": [{
                "components": [
                    {"name": "traceCode", "type": "string"},
                    {"name": "amount", "type": "uint256"},
                    {"name": "sendDate", "type": "string"},
                    {"name": "origin", "type": "string"},
                    {"name": "name", "type": "string"},
                    {"name": "id", "type": "string"},
                    {"name": "recvDate", "type": "string"},
                    {"name": "productId", "type": "string"}
                ], "name": "", "type": "tuple"
            }],
            "payable": false,
            "stateMutability": "view",
            "type": "function",
            "funcId": 1
        }],
        "useAes": false,
        "useCns": false,
        "cnsName": ""
    };
    // 修复路径 + 统一超时配置
    return webaseHttp.post('/WeBASE-Front/trans/handle', params, { timeout: 30000 }).then(res => {
        return res;
    })
}

export function updateWarehouse(params) {
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Warehouse",
        "version": "",
        "funcName": "updateObject",
        "funcParam": [
            params.traceCode || '',
            Number(params.amount) || 0,  // uint256转数字，兜底0
            params.sendDate || '',
            params.origin || '',
            params.name || '',
            params.id || '',
            params.recvDate || '',
            params.productId || ''
        ],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [
                {"name": "_traceCode", "type": "string", "value": params.traceCode || ''},
                {"name": "_amount", "type": "uint256", "value": Number(params.amount) || 0},
                {"name": "_sendDate", "type": "string", "value": params.sendDate || ''},
                {"name": "_origin", "type": "string", "value": params.origin || ''},
                {"name": "_name", "type": "string", "value": params.name || ''},
                {"name": "_id", "type": "string", "value": params.id || ''},
                {"name": "_recvDate", "type": "string", "value": params.recvDate || ''},
                {"name": "_productId", "type": "string", "value": params.productId || ''}
            ],
            "name": "updateObject",
            "outputs": [],
            "payable": false,
            "stateMutability": "nonpayable",
            "type": "function",
            "funcId": 3
        }],
        "useAes": false,
        "useCns": false,
        "cnsName": ""
    };
    // 修复路径 + 统一超时配置
    return webaseHttp.post('/WeBASE-Front/trans/handle', pam, { timeout: 30000 }).then(res => {
        return res;
    });
}

function cvtRes(item) {
    return {
        "traceCode": item[0] || '',
        "amount": Number(item[1]) || 0,  // 转数字，前端展示更友好
        "sendDate": item[2] || '',
        "origin": item[3] || '',
        "name": item[4] || '',
        "id": item[5] || '',
        "recvDate": item[6] || '',
        "productId": item[7] || '',
    }
}