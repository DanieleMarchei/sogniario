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
exports.User = void 0;
const swagger_1 = require("@nestjs/swagger");
const typeorm_1 = require("typeorm");
const gender_enum_1 = require("./gender.enum");
const dream_entity_1 = require("./dream.entity");
const chronotype_entity_1 = require("./chronotype.entity");
const psqi_entity_1 = require("./psqi.entity");
const organization_entity_1 = require("./organization.entity");
let User = class User {
};
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], User.prototype, "id", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ nullable: false }),
    __metadata("design:type", String)
], User.prototype, "username", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ nullable: false }),
    __metadata("design:type", String)
], User.prototype, "password", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ nullable: false }),
    __metadata("design:type", String)
], User.prototype, "type", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ nullable: true }),
    __metadata("design:type", Date)
], User.prototype, "birthdate", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({
        type: "enum",
        enum: gender_enum_1.Gender,
        default: gender_enum_1.Gender.NOT_SPECIFIED,
        nullable: false,
    }),
    __metadata("design:type", Number)
], User.prototype, "gender", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ default: new Date() }),
    __metadata("design:type", Date)
], User.prototype, "created_at", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ default: false }),
    __metadata("design:type", Boolean)
], User.prototype, "first_access", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ default: new Date() }),
    __metadata("design:type", Date)
], User.prototype, "last_edit", void 0);
__decorate([
    (0, swagger_1.ApiProperty)(),
    (0, typeorm_1.Column)({ default: false }),
    __metadata("design:type", Boolean)
], User.prototype, "deleted", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => dream_entity_1.Dream, (dream) => dream.user),
    __metadata("design:type", Array)
], User.prototype, "dreams", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => chronotype_entity_1.Chronotype, (chronotype) => chronotype.user),
    __metadata("design:type", Array)
], User.prototype, "chronotypes", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => psqi_entity_1.Psqi, (psqi) => psqi.user),
    __metadata("design:type", Array)
], User.prototype, "psqis", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ type: () => organization_entity_1.Organization }),
    (0, typeorm_1.ManyToOne)(() => organization_entity_1.Organization, (organization) => organization.users),
    __metadata("design:type", organization_entity_1.Organization)
], User.prototype, "organization", void 0);
User = __decorate([
    (0, typeorm_1.Entity)()
], User);
exports.User = User;
//# sourceMappingURL=user.entity.js.map