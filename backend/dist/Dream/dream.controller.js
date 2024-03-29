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
exports.DreamController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const crud_1 = require("@nestjsx/crud");
const dream_service_1 = require("./dream.service");
const dream_entity_1 = require("../entities/dream.entity");
let DreamController = class DreamController {
    constructor(service) {
        this.service = service;
    }
};
DreamController = __decorate([
    (0, crud_1.Crud)({
        model: {
            type: dream_entity_1.Dream,
        },
    }),
    (0, swagger_1.ApiTags)("Dream"),
    (0, common_1.Controller)("dream"),
    __metadata("design:paramtypes", [dream_service_1.DreamService])
], DreamController);
exports.DreamController = DreamController;
//# sourceMappingURL=dream.controller.js.map