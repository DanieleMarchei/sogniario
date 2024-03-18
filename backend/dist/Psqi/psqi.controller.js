"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.PsqiController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const crud_1 = require("@nestjsx/crud");
const psqi_service_1 = require("./psqi.service");
const psqi_entity_1 = require("../entities/psqi.entity");
let PsqiController = class PsqiController {
    constructor(service) {
        this.service = service;
    }
};
PsqiController = __decorate([
    (0, crud_1.Crud)({
        model: {
            type: psqi_entity_1.Psqi,
        },
    }),
    (0, swagger_1.ApiTags)("Psqi"),
    (0, common_1.Controller)("Psqi"),
    __metadata("design:paramtypes", [psqi_service_1.PsqiService])
], PsqiController);
exports.PsqiController = PsqiController;
//# sourceMappingURL=psqi.controller.js.map