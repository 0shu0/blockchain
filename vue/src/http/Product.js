import webaseHttp from "@/utils/webaseHttp";

let contractAddress = "0x5330ed53ebc59e87343861a582d7dcba64e926d6";
let user = "0x65183d971dff322a603a0c96f61a13bab3be0ab0";

export function addProduct(params) {
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "addObject",
        "funcParam": [ params.traceCode ,params.origin ,params.name ,params.id ,params.manufacturer],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [
                {"name": "_traceCode", "type": "string", "value": params.traceCode},
                {"name": "_origin", "type": "string", "value": params.origin},
                {"name": "_name", "type": "string", "value": params.name},
                {"name": "_id", "type": "string", "value": params.id},
                {"name": "_manufacturer", "type": "string", "value": params.manufacturer}
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
    // 🔴 关键修改：在post请求里加 { timeout: 30000 }，单独设置30秒超时
    return webaseHttp.post('/', pam, { timeout: 30000 })
        .then(res => {
            console.log("新建产品合约调用成功：", res);
            return res;
        }).catch(err => {
            console.error("新建产品失败-合约/请求报错：", err);
            throw err;
        })
}

export function deleteProduct(id) {
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "deleteObject",
        "funcParam": [id],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [{"name": "_id", "type": "string", "value": id}],
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
    return webaseHttp.post('/', pam).then(res => {
        return res;
    });
}

export function getAllProduct() {
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
                    {"name": "traceCode", "type": "string"},
                    {"name": "origin", "type": "string"},
                    {"name": "name", "type": "string"},
                    {"name": "id", "type": "string"},
                    {"name": "manufacturer", "type": "string"}
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
    return webaseHttp.post('/', params).then(res => {
        // 核心修复：判断res是否为数组，非数组返回空数组，避免map报错
        if (!Array.isArray(res)) {
            console.warn("合约返回非数组格式：", res);
            return [];
        }
        let objs = res.map(item => {
            return cvtRes(item);
        });
        return objs;
    }).catch(err => {
        // 新增：捕获请求/合约报错，打印日志并返回空数组，避免页面卡死
        console.error("获取产品列表失败：", err);
        return [];
    });
}

export function getProductById(id) {
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "getObjectById",
        "funcParam": [id],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": true,
            "inputs": [{"name": "_id", "type": "string", "value": id}],
            "name": "getObjectById",
            "outputs": [{
                "components": [{"name": "traceCode", "type": "string"}, {
                    "name": "origin", "type": "string"
                }, {"name": "name", "type": "string"}, {"name": "id", "type": "string"}, {
                    "name": "manufacturer", "type": "string"
                }], "name": "", "type": "tuple"
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
    return webaseHttp.post('/', params).then(res => {
        return res;
    })
}

export function getProductByCode(id) {
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "getObjectByCode",
        "funcParam": [id],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": true,
            "inputs": [{"name": "_code", "type": "string", "value": id}],
            "name": "getObjectByCode",
            "outputs": [{
                "components": [{"name": "traceCode", "type": "string"}, {
                    "name": "origin", "type": "string"
                }, {"name": "name", "type": "string"}, {"name": "id", "type": "string"}, {
                    "name": "manufacturer", "type": "string"
                }], "name": "", "type": "tuple"
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
    return webaseHttp.post('/', params).then(res => {
        return cvtRes(res);
    })
}

export function updateProduct(params) {
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "updateObject",
        "funcParam": [params.traceCode, params.origin, params.name, params.id, params.manufacturer],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [{"name": "_traceCode", "type": "string", "value": params.traceCode}, {
                "name": "_origin", "type": "string", "value": params.origin
            }, {"name": "_name", "type": "string", "value": params.name}, {
                "name": "_id", "type": "string", "value": params.id
            }, {"name": "_manufacturer", "type": "string", "value": params.manufacturer}],
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
    return webaseHttp.post('/', pam).then(res => {
        return res;
    });
}

function cvtRes(item) {
    // 修复：判断item是否为数组/存在，避免item[0]报错
    if (!Array.isArray(item)) {
        console.warn("合约返回非数组item：", item);
        return { traceCode: '', origin: '', name: '', id: '', manufacturer: '' };
    }
    return {
        "traceCode": item[0] || '',
        "origin": item[1] || '',
        "name": item[2] || '',
        "id": item[3] || '',
        "manufacturer": item[4] || '',
    }
}
