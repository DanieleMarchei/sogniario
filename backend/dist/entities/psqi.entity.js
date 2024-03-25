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
exports.Psqi = void 0;
const swagger_1 = require("@nestjs/swagger");
const typeorm_1 = require("typeorm");
const user_entity_1 = require("./user.entity");
let Psqi = class Psqi {
};
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Psqi.prototype, "id", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Date)
], Psqi.prototype, "q1", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number" }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q2", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Date)
], Psqi.prototype, "q3", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 23 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q4", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 24 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q5", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 3 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q6", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 3 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q7", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 3 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q8", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 3 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q9", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 3 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q10", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 3 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q11", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 3 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q12", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 3 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q13", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 3 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q14", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Boolean)
], Psqi.prototype, "q15", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], Psqi.prototype, "q15_text", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 3 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q15_extended", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 3 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q16", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 3 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q17", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 3 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q18", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: "number", minimum: 0, maximum: 3 }),
    (0, typeorm_1.Column)(),
    __metadata("design:type", Number)
], Psqi.prototype, "q19", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ default: new Date() }),
    __metadata("design:type", Date)
], Psqi.prototype, "compiled_date", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: () => user_entity_1.User }),
    (0, typeorm_1.ManyToOne)(() => user_entity_1.User, (user) => user.psqis),
    __metadata("design:type", user_entity_1.User)
], Psqi.prototype, "user", void 0);
Psqi = __decorate([
    (0, typeorm_1.Entity)()
], Psqi);
exports.Psqi = Psqi;
//# sourceMappingURL=psqi.entity.js.map