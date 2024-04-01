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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserController = void 0;
const common_1 = require("@nestjs/common");
const swagger_1 = require("@nestjs/swagger");
const crud_1 = require("@nestjsx/crud");
const user_entity_1 = require("../entities/user.entity");
const user_service_1 = require("./user.service");
const auth_decorator_1 = require("../Auth/auth.decorator");
let UserController = class UserController {
    constructor(service) {
        this.service = service;
    }
    async downloadDreams(res) {
        res.set({
            "Content-Type": "application/zip",
            "Content-Disposition": 'attachment; filename="dreamsdump.zip"',
        });
        return new common_1.StreamableFile(await this.service.downloadDreams(1));
    }
};
__decorate([
    (0, auth_decorator_1.Public)(),
    (0, common_1.Get)("/download"),
    __param(0, (0, common_1.Response)({ passthrough: true })),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], UserController.prototype, "downloadDreams", null);
UserController = __decorate([
    (0, crud_1.Crud)({
        model: {
            type: user_entity_1.User,
        },
        query: {
            join: {
                dreams: {},
                psqis: {},
                chronotypes: {},
            },
        },
    }),
    (0, swagger_1.ApiTags)("User"),
    (0, swagger_1.ApiSecurity)("bearer"),
    (0, common_1.Controller)("user"),
    __metadata("design:paramtypes", [user_service_1.UserService])
], UserController);
exports.UserController = UserController;
//# sourceMappingURL=user.controller.js.map