"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PsqiModule = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const psqi_controller_1 = require("./psqi.controller");
const psqi_service_1 = require("./psqi.service");
const psqi_entity_1 = require("../entities/psqi.entity");
let PsqiModule = class PsqiModule {
};
PsqiModule = __decorate([
    (0, common_1.Module)({
        imports: [typeorm_1.TypeOrmModule.forFeature([psqi_entity_1.Psqi])],
        controllers: [psqi_controller_1.PsqiController],
        providers: [psqi_service_1.PsqiService],
    })
], PsqiModule);
exports.PsqiModule = PsqiModule;
//# sourceMappingURL=psqi.module.js.map