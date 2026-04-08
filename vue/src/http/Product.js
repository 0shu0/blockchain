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
        "funcParam": [params.traceCode, params.origin, params.name, params.manufacturer],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [
                {"name": "_traceCode", "type": "string", "value": params.traceCode},
                {"name": "_origin", "type": "string", "value": params.origin},
                {"name": "_name", "type": "string", "value": params.name},
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
    console.log("提交参数：", pam);
    return webaseHttp.post('/WeBASE-Front/trans/handle', pam, { timeout: 30000 })
        .then(res => {
            console.log("交易提交成功：", res);
            return res.data;
        }).catch(err => {
            console.error("交易失败：", err);
            throw err;
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
    return webaseHttp.post('/WeBASE-Front/trans/handle', params, { timeout: 30000 })
        .then(res => {
            if (!Array.isArray(res)) return [];
            return res.map(item => cvtRes(item));
        })
        .catch(err => {
            console.error("加载产品列表失败：", err);
            return [];
        });
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
                "components": [
                    {"name": "traceCode", "type": "string"},
                    {"name": "origin", "type": "string"},
                    {"name": "name", "type": "string"},
                    {"name": "manufacturer", "type": "string"}
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
}

export function updateProduct(params) {
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Trace",
        "contractPath": "Product",
        "version": "",
        "funcName": "updateObject",
        "funcParam": [params.traceCode, params.origin, params.name, params.manufacturer],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [
                {"name": "_traceCode", "type": "string", "value": params.traceCode},
                {"name": "_origin", "type": "string", "value": params.origin},
                {"name": "_name", "type": "string", "value": params.name},
                {"name": "_manufacturer", "type": "string", "value": params.manufacturer}
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
    return webaseHttp.post('/WeBASE-Front/trans/handle', pam).then(res => {
        return res;
    });
}

export function deleteProduct(id) {
    let params = {
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
    };
    return webaseHttp.post('/WeBASE-Front/trans/handle', params, { timeout: 30000 })
        .then(res => {
            console.log("删除产品成功：", res);
            return res.data;
        }).catch(err => {
            console.error("删除产品失败：", err);
            throw err;
        });
}

function cvtRes(item) {
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