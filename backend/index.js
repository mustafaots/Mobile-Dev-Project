"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const app_1 = __importDefault(require("./src/app"));
const env_1 = __importDefault(require("./src/config/env"));
const start = async () => {
    try {
        app_1.default.listen(env_1.default.port, () => {
            console.info(`API server listening on port ${env_1.default.port}`);
        });
    }
    catch (error) {
        console.error('Unable to start server', error);
        process.exit(1);
    }
};
start();
//# sourceMappingURL=index.js.map