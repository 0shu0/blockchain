import webaseHttp from "@/utils/webaseHttp";

let contractAddress = "0x7893ec54f706328dd50f8c5c354a9a824efd8b42";
let user = "0x914bec892e9755092eb8bb8d4ebf697c90be2a33";

export function addShop(params) {
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Shop",
        "contractPath": "Trace",
        "version": "",
        "funcName": "addObject",
        "funcParam": [ params.listDate ,params.traceCode ,params.amount ,params.sendDate ,params.price ,params.origin ,params.name ,params.id ,params.recvDate,params.productId],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [
                    {"name": "_listDate", "type": "string", "value": params.listDate}
,                    {"name": "_traceCode", "type": "string", "value": params.traceCode}
,                    {"name": "_amount", "type": "uint256", "value": params.amount}
,                    {"name": "_sendDate", "type": "string", "value": params.sendDate}
,                    {"name": "_price", "type": "uint256", "value": params.price}
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
export function deleteShop(id) {
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Shop",
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
export function getAllShop() {
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Shop",
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
                "components": [                     {"name": "listDate", "type": "string"}
,                    {"name": "traceCode", "type": "string"}
,                    {"name": "amount", "type": "uint256"}
,                    {"name": "sendDate", "type": "string"}
,                    {"name": "price", "type": "uint256"}
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
export function getShopById(id) {
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Shop",
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
                "components": [                     {"name": "listDate", "type": "string"}
,                    {"name": "traceCode", "type": "string"}
,                    {"name": "amount", "type": "uint256"}
,                    {"name": "sendDate", "type": "string"}
,                    {"name": "price", "type": "uint256"}
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
export function getShopByCode(id) {
    let params = {
        "groupId": "1",
        "user": user,
        "contractName": "Shop",
        "contractPath": "Trace",
        "version": "",
        "funcName": "getObjectByCode",
        "funcParam": [id],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": true,
            "inputs": [{"name": "_code", "type": "string", "value": id}],
            "name": "getObjectByCode",
            "outputs": [{
                "components": [                     {"name": "listDate", "type": "string"}
,                    {"name": "traceCode", "type": "string"}
,                    {"name": "amount", "type": "uint256"}
,                    {"name": "sendDate", "type": "string"}
,                    {"name": "price", "type": "uint256"}
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
        return cvtRes(res);
    })
}
export function updateShop(params) {
    let pam = {
        "groupId": "1",
        "user": user,
        "contractName": "Shop",
        "contractPath": "Trace",
        "version": "",
        "funcName": "updateObject",
        "funcParam": [ params.listDate ,params.traceCode ,params.amount ,params.sendDate ,params.price ,params.origin ,params.name ,params.id ,params.recvDate,params.productId],
        "contractAddress": contractAddress,
        "contractAbi": [{
            "constant": false,
            "inputs": [                  {"name": "_listDate", "type": "string", "value": params.listDate}
,                {"name": "_traceCode", "type": "string", "value": params.traceCode}
,                {"name": "_amount", "type": "uint256", "value": params.amount}
,                {"name": "_sendDate", "type": "string", "value": params.sendDate}
,                {"name": "_price", "type": "uint256", "value": params.price}
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
            "listDate": item[0] || '',
            "traceCode": item[1] || '',
            "amount": item[2] || '',
            "sendDate": item[3] || '',
            "price": item[4] || '',
            "origin": item[5] || '',
            "name": item[6] || '',
            "id": item[7] || '',
            "recvDate": item[8] || '',
            "productId": item[9] || '',
    }
}
