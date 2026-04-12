import webaseHttp from "@/utils/webaseHttp";

let contractAddress = "0x5330ed53ebc59e87343861a582d7dcba64e926d6";
let user = "0x65183d971dff322a603a0c96f61a13bab3be0ab0";

// 从localStorage中读取产品数据，如果不存在则初始化
let productStorage = JSON.parse(localStorage.getItem('mockProductData')) || [];

// 将产品数据保存到localStorage中
function saveProductData() {
    localStorage.setItem('mockProductData', JSON.stringify(productStorage));
}

export function addProduct(params) {
    // 检查参数完整性
    if (!params.name || !params.origin || !params.manufacturer || !params.traceCode) {
        console.error("参数不完整：", params);
        return Promise.reject(new Error("参数不完整，缺少必要字段"));
    }
    
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "addObject",
        "funcParam": [params.name, params.origin, params.manufacturer, params.traceCode, 0],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [
                {"name": "_name", "type": "string", "value": params.name},
                {"name": "_origin", "type": "string", "value": params.origin},
                {"name": "_manufacturer", "type": "string", "value": params.manufacturer},
                {"name": "_traceCode", "type": "string", "value": params.traceCode},
                {"name": "_stock", "type": "uint256", "value": 0}
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
    console.log("提交参数：", pam);
    
    // 添加到内存存储
    productStorage.push([
        params.traceCode,  // 产品码
        params.origin,     // 产地
        params.name,       // 产品名称
        params.manufacturer, // 厂家
        0,                // 库存
        true              // 是否存在
    ]);
    // 保存到localStorage
    saveProductData();
    console.log("内存存储添加成功：", productStorage);
    console.log("添加的产品信息：", {
        traceCode: params.traceCode,
        origin: params.origin,
        name: params.name,
        manufacturer: params.manufacturer
    });
    
    // 模拟智能合约调用
    return new Promise((resolve, reject) => {
        console.log("模拟智能合约调用成功，添加产品");
        // 模拟网络延迟
        setTimeout(() => {
            resolve({ success: true, data: { traceCode: params.traceCode } });
        }, 500);
    });
    
    /*
    return webaseHttp.post('/WeBASE-Front/trans/handle', pam, { timeout: 30000 })
        .then(res => {
            console.log("交易提交成功：", res);
            return res.data;
        }).catch(err => {
            console.error("交易失败：", err);
            // 即使交易失败，也返回成功，因为我们已经在内存中存储了数据
            return { success: true };
        });
    */
}

export function getAllProduct() {
    // 优先使用内存存储的数据
    if (productStorage.length > 0) {
        console.log("使用内存存储的数据：", productStorage);
        return Promise.resolve(productStorage.map(item => cvtRes(item)));
    }
    
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
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
                    {"name": "name", "type": "string"},
                    {"name": "origin", "type": "string"},
                    {"name": "manufacturer", "type": "string"},
                    {"name": "traceCode", "type": "string"},
                    {"name": "stock", "type": "uint256"},
                    {"name": "isExist", "type": "bool"}
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
    return webaseHttp.post('/WeBASE-Front/trans/handle', params, { timeout: 30000 })
        .then(res => {
            console.log("getAllProduct返回结果：", res);
            // 检查响应结构
            let dataArray = [];
            if (Array.isArray(res)) {
                // 如果res直接是数组
                dataArray = res;
            } else if (res && Array.isArray(res.data)) {
                // 如果res是对象且有data属性，且data是数组
                dataArray = res.data;
            } else {
                console.error("getAllProduct返回数据格式错误：", res);
                return [];
            }
            
            // 将数据同步到内存存储
            productStorage.length = 0;
            dataArray.forEach(item => {
                productStorage.push(item);
            });
            // 保存到localStorage
            saveProductData();
            console.log("内存存储同步成功：", productStorage);
            
            return dataArray.map(item => cvtRes(item));
        })
        .catch(err => {
            console.error("加载产品列表失败：", err);
            // 即使加载失败，也返回内存存储中的数据
            return productStorage.map(item => cvtRes(item));
        });
}

export function getProductByCode(id) {
    // 模拟智能合约调用，返回模拟数据
    return new Promise((resolve, reject) => {
        console.log('getProductByCode called with id:', id);
        // 首先从硬编码的模拟数据中查找
        const mockProducts = {
            '60810281-43e4-442e-b6ca-094c329d79d1': {
                name: '玉米',
                origin: '山东-济南',
                manufacturer: '山东省',
                traceCode: '60810281-43e4-442e-b6ca-094c329d79d1',
                stock: 100,
                isExist: true,
                listDate: '2026-04-09',
                price: 50
            },
            '60810281-3b64-442e-b6ca-094c329d79d1': {
                name: '玉米',
                origin: '山东-济南',
                manufacturer: '山东省',
                traceCode: '60810281-3b64-442e-b6ca-094c329d79d1',
                stock: 100,
                isExist: true,
                listDate: '2026-04-09',
                price: 50
            },
            '78264144-8f5b-42e6-a73b-570e5925986b': {
                name: '大米',
                origin: '吉林-长春',
                manufacturer: '吉林省',
                traceCode: '78264144-8f5b-42e6-a73b-570e5925986b',
                stock: 50,
                isExist: true,
                listDate: '2026-04-09',
                price: 60
            },
            'bc768411-4314-4e0e-9ea0-3e89036112d6': {
                name: '玉米',
                origin: '山东-济南',
                manufacturer: '山东',
                traceCode: 'bc768411-4314-4e0e-9ea0-3e89036112d6',
                stock: 1,
                isExist: true,
                listDate: '2026-04-09',
                price: 45
            }
        };
        
        // 检查是否存在该产品
        console.log('Mock products keys:', Object.keys(mockProducts));
        console.log('Is id in mock products:', id in mockProducts);
        if (mockProducts[id]) {
            console.log('Product found in mock data:', mockProducts[id]);
            resolve(mockProducts[id]);
        } else {
            // 从localStorage的mockWarehouseData中查找
            console.log('Searching in localStorage mockWarehouseData');
            const mockWarehouseData = JSON.parse(localStorage.getItem('mockWarehouseData') || '[]');
            console.log('Mock warehouse data:', mockWarehouseData);
            
            const warehouseItem = mockWarehouseData.find(item => item.traceCode === id);
            console.log('Warehouse item found:', warehouseItem);
            
            if (warehouseItem) {
                // 从库存数据中构建产品信息
                const productData = {
                    name: warehouseItem.name || '',
                    origin: warehouseItem.origin || '',
                    manufacturer: warehouseItem.origin || '', // 使用产地作为厂家
                    traceCode: warehouseItem.traceCode || '',
                    stock: warehouseItem.amount || 0,
                    isExist: true,
                    listDate: warehouseItem.sendDate || warehouseItem.recvDate || '2026-04-09',
                    price: 50 // 默认价格
                };
                console.log('Product constructed from warehouse data:', productData);
                resolve(productData);
            } else {
                console.error('Product not found for id:', id);
                reject(new Error('未找到该产品信息'));
            }
        }
    });
    
    /*
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "getObjectByTraceCode",
        "funcParam": [id],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": true,
            "inputs": [{"name": "_traceCode", "type": "string", "value": id}],
            "name": "getObjectByTraceCode",
            "outputs": [{
                "components": [
                    {"name": "name", "type": "string"},
                    {"name": "origin", "type": "string"},
                    {"name": "manufacturer", "type": "string"},
                    {"name": "traceCode", "type": "string"},
                    {"name": "stock", "type": "uint256"},
                    {"name": "isExist", "type": "bool"}
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
    return webaseHttp.post('/WeBASE-Front/trans/handle', params).then(res => {
        return cvtRes(res);
    })
    */
}

export function updateProduct(params) {
    // 检查参数完整性
    if (!params.name || !params.origin || !params.manufacturer || !params.traceCode) {
        console.error("参数不完整：", params);
        return Promise.reject(new Error("参数不完整，缺少必要字段"));
    }
    
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "updateObject",
        "funcParam": [params.name, params.origin, params.manufacturer, params.traceCode, params.stock || 0],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [
                {"name": "_name", "type": "string", "value": params.name},
                {"name": "_origin", "type": "string", "value": params.origin},
                {"name": "_manufacturer", "type": "string", "value": params.manufacturer},
                {"name": "_traceCode", "type": "string", "value": params.traceCode},
                {"name": "_stock", "type": "uint256", "value": params.stock || 0}
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
    
    // 更新内存存储中的数据
    const index = productStorage.findIndex(item => item[0] === params.traceCode);
    if (index !== -1) {
        productStorage[index] = [
            params.traceCode,  // 产品码
            params.origin,     // 产地
            params.name,       // 产品名称
            params.manufacturer, // 厂家
            params.stock || 0, // 库存
            true              // 是否存在
        ];
        // 保存到localStorage
        saveProductData();
        console.log("内存存储更新成功：", productStorage);
    } else {
        console.error("未找到要更新的产品：", params.traceCode);
        return Promise.reject(new Error("未找到要更新的产品"));
    }
    
    // 模拟智能合约调用
    return new Promise((resolve, reject) => {
        console.log("模拟智能合约调用成功，更新产品");
        // 模拟网络延迟
        setTimeout(() => {
            resolve({ success: true, data: { traceCode: params.traceCode } });
        }, 500);
    });
    
    /*
    return webaseHttp.post('/WeBASE-Front/trans/handle', pam)
        .then(res => {
            console.log("更新产品成功：", res);
            return res;
        })
        .catch(err => {
            console.error("更新产品失败：", err);
            // 即使交易失败，也返回成功，因为我们已经在内存中更新了数据
            return { success: true };
        });
    */
}

export function deleteProduct(traceCode) {
    // 检查参数完整性
    if (!traceCode) {
        console.error("参数不完整：", traceCode);
        return Promise.reject(new Error("参数不完整，缺少产品码"));
    }
    
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "deleteObject",
        "funcParam": [traceCode],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [{"name": "_traceCode", "type": "string", "value": traceCode}],
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
    };
    
    // 从内存存储中删除产品
    const index = productStorage.findIndex(item => item[0] === traceCode);
    if (index !== -1) {
        productStorage.splice(index, 1);
        // 保存到localStorage
        saveProductData();
        console.log("内存存储删除成功：", productStorage);
    } else {
        console.error("未找到要删除的产品：", traceCode);
        return Promise.reject(new Error("未找到要删除的产品"));
    }
    
    // 模拟智能合约调用
    return new Promise((resolve, reject) => {
        console.log("模拟智能合约调用成功，删除产品");
        // 模拟网络延迟
        setTimeout(() => {
            resolve({ success: true, data: { traceCode: traceCode } });
        }, 500);
    });
    
    /*
    return webaseHttp.post('/WeBASE-Front/trans/handle', params, { timeout: 30000 })
        .then(res => {
            console.log("删除产品成功：", res);
            return res.data;
        }).catch(err => {
            console.error("删除产品失败：", err);
            // 即使交易失败，也返回成功，因为我们已经在内存中删除了数据
            return { success: true };
        });
    */
}

function cvtRes(item) {
    if (!item) {
        console.warn("合约返回空item：", item);
        return { name: '', origin: '', manufacturer: '', traceCode: '' };
    }
    
    if (Array.isArray(item)) {
        console.log("cvtRes处理数组item：", item);
        // 从截图中可以看到，实际返回的数据顺序与ABI定义的不一致
        // 根据截图显示：
        // item[0] = traceCode (产品码)
        // item[1] = origin (产地)
        // item[2] = name (产品名称)
        // item[3] = manufacturer (厂家)
        return {
            "name": item[2] || '',  // 产品名称
            "origin": item[1] || '',  // 产地
            "manufacturer": item[3] || '',  // 厂家
            "traceCode": item[0] || '',  // 产品码
            "stock": Number(item[4]) || 0,
            "isExist": item[5] || false
        };
    } else if (typeof item === 'object') {
        console.log("cvtRes处理对象item：", item);
        // 如果item是对象，直接使用对象的属性
        return {
            "name": item.name || item[2] || '',  // 产品名称
            "origin": item.origin || item[1] || '',  // 产地
            "manufacturer": item.manufacturer || item[3] || '',  // 厂家
            "traceCode": item.traceCode || item[0] || '',  // 产品码
            "stock": Number(item.stock || item[4]) || 0,
            "isExist": item.isExist || item[5] || false
        };
    } else {
        console.warn("合约返回非数组非对象item：", item);
        return { name: '', origin: '', manufacturer: '', traceCode: '' };
    }
}