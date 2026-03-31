import webaseHttp from "@/utils/webaseHttp";

let contractAddress = "0x9bed475c166a510200bee7ec724afca6a55d6ecd";
let user = "0x914bec892e9755092eb8bb8d4ebf697c90be2a33";

export function addWarehouse(params) {
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Warehouse",
        "contractPath": "Trace",
        "version": "",
        "funcName": "addObject",
        "funcParam": [ params.traceCode ,params.amount ,params.sendDate ,params.origin ,params.name ,params.id ,params.recvDate,params.productId],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [
                    {"name": "_traceCode", "type": "string", "value": params.traceCode}
,                    {"name": "_amount", "type": "uint256", "value": params.amount}
,                    {"name": "_sendDate", "type": "string", "value": params.sendDate}
,                    {"name": "_origin", "type": "string", "value": params.origin}
,                    {"name": "_name", "type": "string", "value": params.name}
,                    {"name": "_id", "type": "string", "value": params.id}
,                    {"name": "_recvDate", "type": "string", "value": params.recvDate}
,                    {"name": "_productId", "type": "string", "value": params.productId}
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
    return webaseHttp.post('/', pam).then(res => {
        return res;
    })
}
export function deleteWarehouse(id) {
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Warehouse",
        "contractPath": "Trace",
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
export function getAllWarehouse() {
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Warehouse",
        "contractPath": "Trace",
        "version": "",
        "funcName": "getAllObjects",
        "funcParam": [],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": true,
            "inputs": [],
            "name": "getAllObjects",
            "outputs": [{
                "components": [                     {"name": "traceCode", "type": "string"}
,                    {"name": "amount", "type": "uint256"}
,                    {"name": "sendDate", "type": "string"}
,                    {"name": "origin", "type": "string"}
,                    {"name": "name", "type": "string"}
,                    {"name": "id", "type": "string"}
,                    {"name": "recvDate", "type": "string"}
,                    {"name": "productId", "type": "string"}
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
        let objs = res.map(item => {
            return cvtRes(item);
        });
        return objs;
    });
}
export function getWarehouseById(id) {
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Warehouse",
        "contractPath": "Trace",
        "version": "",
        "funcName": "getObjectById",
        "funcParam": [id],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": true,
            "inputs": [{"name": "_id", "type": "string", "value": id}],
            "name": "getObjectById",
            "outputs": [{
                "components": [                     {"name": "traceCode", "type": "string"}
,                    {"name": "amount", "type": "uint256"}
,                    {"name": "sendDate", "type": "string"}
,                    {"name": "origin", "type": "string"}
,                    {"name": "name", "type": "string"}
,                    {"name": "id", "type": "string"}
,                    {"name": "recvDate", "type": "string"}
,                    {"name": "productId", "type": "string"}
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
    return webaseHttp.post('/', params).then(res => {
        return res;
    })
}
export function updateWarehouse(params) {
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Warehouse",
        "contractPath": "Trace",
        "version": "",
        "funcName": "updateObject",
        "funcParam": [ params.traceCode ,params.amount ,params.sendDate ,params.origin ,params.name ,params.id ,params.recvDate,params.productId],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [                  {"name": "_traceCode", "type": "string", "value": params.traceCode}
,                {"name": "_amount", "type": "uint256", "value": params.amount}
,                {"name": "_sendDate", "type": "string", "value": params.sendDate}
,                {"name": "_origin", "type": "string", "value": params.origin}
,                {"name": "_name", "type": "string", "value": params.name}
,                {"name": "_id", "type": "string", "value": params.id}
,                {"name": "_recvDate", "type": "string", "value": params.recvDate}
,                {"name": "_productId", "type": "string", "value": params.productId}
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
    return webaseHttp.post('/', pam).then(res => {
        return res;
    });
}
function cvtRes(item) {
    return {
            "traceCode": item[0] || '',
            "amount": item[1] || '',
            "sendDate": item[2] || '',
            "origin": item[3] || '',
            "name": item[4] || '',
            "id": item[5] || '',
            "recvDate": item[6] || '',
            "productId": item[7] || '',
    }
}
